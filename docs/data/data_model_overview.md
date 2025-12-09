# 데이터 모델 설계도 (초안)

본 문서는 현재 `web_dashboard` 관제 웹앱에서 사용 중이거나 향후 구현 예정인 핵심 데이터 모델을 정리한 초안이다. 로그인/인증 도메인과 대시보드(강의실) 도메인을 중심으로 엔티티 구조와 상태 모델, DTO, 확장 포인트를 정의한다.

## 1. 도메인 계층 개요

| 계층 | 설명 | 관련 폴더 |
| --- | --- | --- |
| Domain Entities | 비즈니스 규칙에 종속된 불변 객체 | `lib/core/**/domain/entities` |
| Value Objects | 입력 값 검증/불변 책임 | `lib/core/**/domain/value_objects` |
| Application State | Riverpod Notifier가 관리하는 UI 상태 | `lib/core/**/domain/state` |
| DTO/Data Source | API와의 입출력 모델 | `lib/core/**/data` 및 추후 `lib/common/network` |

## 2. 인증 도메인 (현 구현)

### 2.1 Entities & Value Objects

- **AuthUser**
  - `id`: int
  - `username`: String
  - `displayName`: String
  - `roles`: List\<String\>
  - `email` : String

- **LoginCredentials (Value Object)**
  - `username`, `password`
  - null-safe + 불변 (Freezed)

### 2.2 Application State

- **LoginFormState**
  - `username`, `password`
  - `isSubmitting`: bool
  - `errorMessage`: String?
- **AuthState**
  - `currentUser`: AuthUser?
  - `isAuthenticated`: bool
  - `isLoadingMe`: bool

### 2.3 Repository & DTO

- `AuthRepository` 인터페이스 + `AuthRepositoryImpl`
- DTO는 `/api/login`, `/api/me` 응답 스펙(`docs/frontend_api.md`) 기준

## 3. 대시보드 도메인 (설계안)

### 3.1 공통 타입

| 모델 | 속성 | 설명 |
| --- | --- | --- |
| `Building` | `id`, `name`, `alias` | 건물 메타데이터 |
| `Department` | `id`, `name` | 학과 정보 (필터용) |
| `Professor` | `id`, `name`, `email`? | 강의자 정보 |

### 3.2 강의실 요약 (전체 화면)

- **ClassroomSummary**
  - `id`: String (예: building-room)
  - `building`: Building
  - `roomNumber`: String
  - `department`: Department
  - `status`: `ClassroomUsageStatus` (enum: `inUse`, `idle`, `maintenance`)
  - `currentCourse`: `CourseSlot?`
  - `nextSlot`: `CourseSlot?`
  - `capacity`: int?
  - `occupancy`: int?

- **CourseSlot**
  - `title`
  - `professor`: Professor
  - `startTime`, `endTime`

- **DashboardMetrics**
  - `totalRooms`, `inUseCount`, `idleCount`, `maintenanceCount`
  - `timestamp`: DateTime (현재 시각)

- **DashboardFilter**
  - `query`: String? (건물/호수/학과)
  - `status`: Set\<ClassroomUsageStatus\>
  - `departmentIds`: List\<String\>

### 3.3 강의실 상세

- **ClassroomDetail**
  - `summary`: ClassroomSummary
  - `equipmentStatus`: `EquipmentState`
  - `environment`: `EnvironmentSnapshot`
  - `schedule`: List\<ScheduleEvent\>
  - `cameraUrl`: String?

- **EquipmentState**
  - `lighting`: bool
  - `devices`: bool
  - `lastUpdated`: DateTime

- **EnvironmentSnapshot**
  - `temperature`: double
  - `humidity`: double
  - `measuredAt`: DateTime

- **ScheduleEvent**
  - `id`
  - `title`
  - `professor`
  - `start`
  - `end`
  - `roomId`
  - `isRecurring`: bool
  - `recurrenceRule`: Recurrence? (추후 RFC5545 스타일)

- **ScheduleDraft (Form State)**
  - `title`, `lecturer`, `date`, `startTime`, `endTime`
  - `allDay`, `repeatType`, `notes`

### 3.4 상태 모델 (예상 Riverpod Notifier)

| 상태 | 내용 |
| --- | --- |
| `DashboardState` | `List<ClassroomSummary>`, `DashboardMetrics`, `DashboardFilter`, `isLoading`, `errorMessage` |
| `ClassroomDetailState` | `ClassroomDetail?`, `isLoading`, `errorMessage`, `selectedDateRange` |

## 4. API/스토리지 설계 초안

| 엔드포인트 | 설명 |
| --- | --- |
| `GET /api/classrooms` | 요약 정보 목록 (필터/검색 지원) |
| `GET /api/classrooms/{id}` | 단일 강의실 상세 (환경, 장비, 스케줄 포함) |
| `GET /api/classrooms/{id}/schedule` | 주간/월간 이벤트 |
| `POST /api/classrooms/{id}/schedule` | 일정 등록 |
| `PATCH /api/classrooms/{id}/equipment` | 전등/장비 상태 토글 |
| `GET /api/metrics/classrooms` | 전체/사용중/미사용 카운트 |

*위 endpoint들은 추후 백엔드 API와 협의 후 `docs/frontend_api.md`에 통합 예정.*

## 5. 확장/개선 제안

1. **공통 ID 스킴 정의**  
   - `Building` + `Room` → `ClassroomId` Value Object로 묶으면 문자열 조작을 피할 수 있다.
2. **환경 센서 이력**  
   - `EnvironmentSnapshot` 리스트를 `EnvironmentHistory`로 관리해 그래프/트렌드 표시 가능.
3. **권한 모델 확장**  
   - `AuthUser.roles` 기반으로 강의실 제어 권한을 구분할 필요 있음 (예: Admin vs Viewer).
4. **오프라인 캐시**  
   - `common/network`와 연계해 `dashboard_state`를 persist하면 재접속 시 초기 로딩 속도를 개선할 수 있다.

본 설계 초안을 기반으로 사용자/백엔드 의견을 반영해 모델을 구체화하고, 각 도메인 폴더에 실제 엔티티 클래스를 추가해 나간다.
