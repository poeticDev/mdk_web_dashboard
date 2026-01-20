# 대시보드 UI 설계 요약

본 문서는 `docs/reference_media/samples/1.png`, `docs/reference_media/samples/2.png` 와이어프레임을 기준으로 전체 강의실 대시보드(전체 화면)와 개별 강의실 화면을 구현하기 위한 설계 및 진행 순서를 정리한다.

## 현재 구현 현황 (2025-12-30 기준)

- 공통 AppBar(CommonAppBar)와 페이지 메타 구조는 이미 구현되어 대시보드/상세 화면에서 재사용 가능하다.
- Classroom Detail 화면에는 연관 엔티티 검색 컴포넌트(EntitySearchField)·Riverpod Controller 구조가 적용되어 있으며, 대시보드 필터도 같은 패턴을 사용할 예정이다.
- Dashboard 메트릭/카드/필터 UI는 아직 본격 개발되지 않았으므로, 아래 설계 항목을 최신 컴포넌트 기준으로 업데이트해 차기 세션에서 착수한다.
- Responsive 정책과 테마(AppTheme/AppTypography)는 AGENTS.md 및 reference guide에 따라 코드에 반영되어 있으므로, 대시보드 구현 시 동일 정책을 따른다.

## 0. 로그인 이후 랜딩/자동 라우팅 정책

로그인 직후 한 번만 실행되는 “랜딩 스플래시”를 통해 강의실 목록을 선조회하고,
강의실 개수가 1개면 곧바로 상세 화면으로 이동한다. (대시보드를 건너뜀)

### 0.1 요구사항

- 판단 기준: **전체 강의실 목록 기준**
- 실행 시점: 로그인 성공 직후 **첫 진입 시점 1회**
- 라우팅:
  - 강의실 1개 → `classroom_detail`로 자동 이동
  - 강의실 2개 이상 → `dashboard`
  - 강의실 0개 → `dashboard` (빈 상태 안내는 대시보드에서 처리)
- 사용자 개입 없이 바로 이동
- 랜딩 페이지에서 진행 상태(메시지 + 로딩) 표시

### 0.2 라우팅 구조 변경

- 신규 라우트: `/landing` (`RouteNames.landing`)
- 로그인 이후 리다이렉트 경로:
  - `/login` → `/landing`
  - `/landing`은 내부 판단 후 `dashboard` 혹은 `classroom_detail`로 이동
- 로그인되지 않은 사용자는 기존 정책대로 `/login`으로 강제 리다이렉트

### 0.3 데이터 플로우

1. `LandingPage` 진입
2. `LandingController`가 인증된 사용자 정보를 기반으로 foundation selection 결정
   - 우선순위: `buildingId` → `departmentId` → `siteId`
3. `FoundationClassroomsReadRepository.fetchClassrooms(...)` 호출
4. 결과 개수에 따라 라우팅 결정

### 0.4 상태 모델(예시)

`LandingState`
- `step`: `checkingSession | loadingClassrooms | decidingRoute | error`
- `message`: 사용자에게 보여줄 진행 상태 텍스트
- `errorMessage`: 오류 발생 시 표시 메시지
- `nextRoute`: 라우팅 결정 결과(내부용)

### 0.5 UI/UX 정책

- 중앙 로딩 인디케이터 + 진행 메시지 표시
- 오류 발생 시 재시도 버튼 제공
- 자동 이동은 1회만 수행 (중복 라우팅 방지)

### 0.6 예외 처리

- `foundation` 선택 실패: 에러 메시지 표시 + 재시도
- API 실패: 에러 메시지 표시 + 재시도
- 0개 반환: 대시보드로 이동 (빈 상태 안내는 대시보드에서 처리)

### 0.7 책임 분리

- `LandingController`
  - 랜딩용 단일 책임: “초기 강의실 목록 조회 및 라우팅 결정”
  - 대시보드 로딩/실시간 스트리밍 등과 분리
- `DashboardController`
  - 대시보드 진입 이후에만 초기화/스트리밍 수행

## 1. 전체 강의실 화면 (docs/reference_media/samples/1.png)

### 1.1 화면 구조

1. **헤더 바**
   - 공통 앱바 구현 완료(lib/common/app_bar)
   - 페이지 타이틀 : `관리 강의실 전체 보기`
2. **상단 메트릭 카드 영역**
   - 1. 현재 시각/날짜 표시(실시간, KST timezone) : 앱 공통 카드 위젯 활용. 판단의 기준 시점 명확화.
   - 2. 전체 강의실 수, 사용 중, 미사용, 미연동 카드 : 각각을 앱 공통 카드 위젯을 활용하여 재사용 가능한 `StatusMetricCard` 위젯으로 만든다.  각각 '전체 관리 대상 강의실 수', '실시간 사용 중인 강의실 수', '실시간 미사용 강의실 수', '관제 시스템 미연동 강의실 수'를 표시. 클릭(터치) 시, 각 사용 상태에 해당하는 하단 강의실 카드 그리드에 표시.
   - 3. 검색 필드(건물, 강의실, 학과의 name, code를 기준으로 검색).
   - 이 영역은 `ResponsiveGrid`로 구현하되 1, 2, 3 각 항목을 하나의 자식으로 가지게 한다. 
3. **강의실 카드 그리드**
   - 강의실별 정보 카드: (정적 정보) 강의실명, 학과, (동적 정보) 현재 강의명, 현재 강의자, 현재 강의 시작/종료시간, 상태 뱃지(사용 중/미사용).
   - 카드 상단 상태 뱃지: 좌측 2개(재실 상태-boolean, 장비 상태-boolean), 우측 1개(사용중/미사용-boolean, 미연동 = null)
   - 카드 내 액션 버튼(자세히 보기) → 개별 화면으로 라우트.
   - 그리드는 `SliverGrid` or `GridView`로 구현하고, 반응형 레이아웃(열 수) 조정 필요.

### 1.2 데이터 모델 및 상태

#### 1) 데이터 소스 기준(현 시점, `/api/v1`)
- **Foundation 기준 강의실 목록**: `GET /api/v1/foundations/{foundationType}/{foundationId}/classrooms`
  - 응답에 `buildingName`, `departmentName`을 포함하도록 확장 예정
- **RoomState 구독 생성**: `POST /api/v1/stream/room-states/subscriptions`
- **RoomState SSE 연결**: `GET /api/v1/stream/room-states?subscriptionId=...`
- **Current Lecture 구독 생성**: `POST /api/v1/stream/occurrences/now/subscriptions`
- **Current Lecture SSE 연결**: `GET /api/v1/stream/occurrences/now?subscriptionId=...`

#### 2) 데이터 합성 플로우(확정안)
1. `GET /api/v1/foundations/{foundationType}/{foundationId}/classrooms` → 대시보드 대상 classroomIds 확보
    - 초기 foundation 값은 로그인 응답에 포함된 `site/building/department` 정보를 기준으로 선택한다.
    - 기본은 `site`이며, 사용자 컨텍스트에 따라 `building`/`department`로 좁힐 수 있다.
2. **RoomState 구독 생성** → `subscriptionId` 확보
   - 요청 payload: `classroomIds`, `sensors=["presence"]`, `equipment=["power"]`
   - 추후 `temperature/humidity` 등 추가 확장 가능하도록 설계
3. **RoomState SSE 연결** → `roomState.snapshot` + `roomState.delta` 수신
4. **Current Lecture 구독 생성**(include: `scheduleSummary`) → `subscriptionId` 확보
5. **Current Lecture SSE 연결** → `occurrence.now.snapshot` 수신
6. 위 결과를 합성해 카드/메트릭 계산

#### 3) ViewModel (합성 결과)
- `DashboardClassroomCardVM`
  - `id`, `name`, `code`, `siteId`
  - `buildingName`, `departmentName`
  - `usageStatus`: `inUse | idle | unlinked`
    - `inUse`: `currentLecture != null` && `currentLecture.status != cancelled`
    - `idle`: 현재 진행 강의 없음
    - `unlinked`: RoomState 미수신 또는 `status.isStale == true`
  - `currentLecture`: `title`, `instructorName`, `startAt`, `endAt`, `status`
  - `roomState`: `isOccupied`, `isEquipmentOn`, `updatedAt`, `statusFlags`
    - `isEquipmentOn`은 `equipment.power.isOn == true`로 판단

- `DashboardMetricsVM`
  - `totalCount`, `inUseCount`, `idleCount`, `unlinkedCount` → scheduleSummary 기반(서버 계산)
  - `timestamp`
  - `scheduleSummary?` (occurrence SSE include)
  - `occupancySummary?` (roomState snapshot, notLinked 포함)
  - KPI는 `scheduleSummary`를 우선 사용하며, 클라이언트에서 `usageStatus`로 재계산하지 않는다.
  - `unlinkedCount`는 `occupancySummary.notLinked`를 기준으로 사용한다.

#### 4) 상태 모델
- `DashboardFilterState`
  - `query` (건물/강의실/학과 name+code)
  - `usageStatus` (Set)
  - `departmentIds?`, `buildingIds?`
- `DashboardState`
  - `cards: List<DashboardClassroomCardVM>`
  - `metrics: DashboardMetricsVM`
  - `filters: DashboardFilterState`
  - `isLoading`, `errorMessage`, `lastUpdatedAt`

#### 5) 필터/검색 정책
- 검색 대상: `classroom.name`, `classroom.code`, `building.name`, `building.code`, `department.name`, `department.code`
- 상태 필터:
  - `inUse`: `usageStatus == inUse`
  - `idle`: `usageStatus == idle`
  - `unlinked`: 재실 센서 값을 알 수 없는 강의실

#### 6) 실시간 업데이트 정책(초안)
- **SSE 기본**
  - RoomState: `event: roomState.snapshot`, `event: roomState.delta`
  - Occurrence: `event: occurrence.now.snapshot` (기본), 필요 시 delta
  - UI 반영: 수신 즉시 카드/메트릭 갱신(300ms 디바운스)

#### 7) SSE → ViewModel 매핑 규칙
**A. RoomState Snapshot**
- 입력: `roomState.snapshot.payload.classrooms[]`
- 매핑:
  - `roomState.isOccupied` ← `sensors.presence.value` (boolean)
  - `roomState.updatedAt` ← `lastUpdatedAt`
  - `roomState.statusFlags` ← `status` (isStale/hasError/hasSensorError/hasEquipmentError)
  - `roomState.isEquipmentOn` ← `equipment.power.isOn`

**B. RoomState Delta**
- 입력: `roomState.delta.payload.updates[]`
- 매핑:
  - `type == "sensor"` + `sensorType == "presence"` → `roomState.isOccupied` 갱신
  - `type == "equipment"` + `equipmentType == "power"` → `roomState.isEquipmentOn` 갱신
  - `occupancySummary` 포함 시 `DashboardMetricsVM.occupancySummary` 갱신

**C. Current Lecture Snapshot**
- 입력: `occurrence.now.snapshot.payload.currents[]`
- 매핑:
  - `currentLecture` ← `title`, `instructorName`, `startAt`, `endAt`, `status`
  - `usageStatus` ← `currentLecture != null && status != cancelled ? inUse : idle`
  - `scheduleSummary` 포함 시 `DashboardMetricsVM.scheduleSummary` 갱신

**D. Current Lecture Delta(옵션)**
- 입력: `occurrence.now.delta` (도입 시)
- 매핑:
  - snapshot과 동일 규칙으로 해당 classroomId만 갱신

**E. Unlinked 판단**
- `roomState` 미수신 또는 `status.isStale == true`인 경우 `usageStatus = unlinked`
- `unlinked`는 RoomState 우선, occurrence 정보와 무관하게 표시
- 초기 snapshot 도착 전에는 모든 카드가 일시적으로 `unlinked` 상태로 표기한다.

#### 8) 상태 전이 / 로딩 정책
**A. 초기 진입**
1. foundation classrooms 조회 → 로딩 상태 유지
2. SSE 구독 생성(룸 상태, 강의 진행) → `isStreaming=true`
3. 첫 snapshot 수신 시 `cards/metrics` 채움, `isLoading=false`

**B. SSE 재연결**
- `Last-Event-ID`를 사용해 서버에 재연결
- 재연결 동안 `isStreaming=false`, UI에는 “연결 재시도 중” 배지 표시
- 재연결 성공 시 최신 snapshot으로 복구

**C. 부분 업데이트**
- delta 수신 시 해당 classroomId만 업데이트
- 메트릭은 변경된 클래스룸만 반영해 재계산

**D. 오류 처리**
- foundation 조회 실패: `errorMessage` 표시, 재시도 버튼 제공
- SSE 연결 실패: `errorMessage` 없이 연결 상태 배지로 안내(기존 데이터 유지)

**E. 필터 변경**
- 로컬 필터만 적용(서버 재요청 없음)
- 필터 변경 시 cards 재정렬/재계산, metrics는 **원본 데이터 기준** 유지

#### 9) UI 섹션별 데이터 매핑
**A. 상단 KPI 카드**
- `전체`: `metrics.totalCount`
- `사용 중`: `metrics.inUseCount`
- `미사용`: `metrics.idleCount`
- `미연동`: `metrics.unlinkedCount`
- `현재 시각`: KST 기준 실시간 날짜+시각

**B. 검색/필터**
- 입력값은 `DashboardFilterState.query`에만 반영
- 상태 필터 클릭 시 `DashboardFilterState.usageStatus` 토글

**C. 강의실 카드**
- 제목: `card.name` (없으면 `buildingName + code` 조합)
- 학과: `departmentName` (없으면 "미지정")
- 상태 뱃지(우측): `usageStatus`
- 재실/장비 아이콘(좌측):
  - 재실: `roomState.isOccupied`
  - 장비: `roomState.isEquipmentOn`
- 현재 강의:
  - 존재 시 `title`, `instructorName`, `startAt ~ endAt`
  - `status == cancelled`일 때 제목 앞에 `(휴강)` 표시
  - 없으면 “일정 없음”
- CTA: `자세히 보기` → classroom_detail 라우팅

**D. 빈 상태**
- 검색 결과가 0일 때 “검색 결과 없음” 안내
- SSE 미연결 시 카드 상단에 “연결 끊김” 뱃지 표시

#### 10) 테스트 전략(초안)
**A. 단위 테스트**
- `DashboardMetricsVM` 계산 로직 (scheduleSummary 기반)
- `usageStatus` 판정 로직 (inUse/idle/unlinked)
- RoomState delta 병합 로직 (classroomId 단위 업데이트)

**B. 위젯 테스트**
- KPI 카드가 metrics에 맞게 렌더링되는지 검증
- 필터/검색 입력에 따라 카드 수가 변하는지 검증
- RoomState 미수신 시 “연결 끊김” 뱃지 노출 확인

**C. 통합 테스트(선택)**
- SSE snapshot 수신 후 카드가 갱신되는지 확인(테스트 더블 사용)
- 재연결 시 `Last-Event-ID` 경로가 호출되는지 확인

### 1.3 컴포넌트 설계

- `DashboardHeader`: 날짜/시간 표시 + 메트릭 + 검색 필드를 포함하는 컴파운드 위젯. 검색 필드는 `EntitySearchField` 혹은 동일 인터페이스를 활용.
- `ClassroomCard`: 상태 뱃지, 아이콘, 버튼 등을 포함. 상태별 컬러는 `AppColors`로 매핑.
- `StatusBadge`: 사용 중/미사용/미연동 등 상태 텍스트를 색상으로 구분.

### 1.4 진행 순서

1. **Route/Navigation**: `/dashboard` → 전체 화면 라우트 구성.
2. **클래스 카드 데이터 모델 정의 + mock 데이터**.
3. **상단 메트릭 카드 위젯 → 검색 필드 UI 구현**.
4. **그리드 카드 구현**.
5. **반응형 조정 및 Theme 연결**.
6. **상태 관리/필터 로직 추가**.

## 2. 개별 강의실 화면 (docs/reference_media/samples/2.png)

### 2.1 화면 구조

1. **상단 바**
   - 뒤로 가기, 페이지 타이틀(`강의실 개별 정보`), 사용자 아이콘.
2. **강의실 요약 + 제어 패널**
   - 왼쪽: 강의실 이름/학과, 현재 수업 정보, 상태 뱃지.
   - 오른쪽: 전등/장비 ON/OFF 스위치, 환경 정보(온도/습도), 실시간 카메라 버튼.
   - 재실 상태 아이콘
3. **캘린더 영역**
   - 현행 구현(`ClassroomTimetableSection`)을 재사용해 주간/월간 토글, 날짜 네비게이션, 일정 블록을 제공한다.
   - `EntitySearchField` 기반 일정 등록 모달이 이미 마련되어 있으므로, 대시보드에서도 동일 모달을 호출한다.

### 2.2 데이터 및 상태

- `ClassroomDetail` 모델: 요약 정보 + 환경 정보 + 장비 상태.
- `ScheduleEvent` 모델.
- 스위치/실시간 센서 값은 컨트롤러가 API 호출로 갱신하는 구조(추후 연결).

### 2.3 컴포넌트 설계

- `RoomInfoCard`: 상태 뱃지, 수업 정보.
- `ControlToggle`: 전등/장비 스위치.
- `EnvironmentInfoCard`: 온도/습도 값.
- `ScheduleCalendar`: 주/월 전환 가능한 캘린더 위젯.
- `ScheduleFormSheet`: 일정 등록/수정 폼(모달).

### 2.4 진행 순서

1. **상세 라우트 구성:** `/dashboard/:roomId` 형태.
2. **Room info + control panel 레이아웃 제작**.
3. **환경 정보 카드 및 실시간 버튼 UI 구현**.
4. **캘린더 위젯 도입(주간 뷰 먼저) → 월간 토글**.
5. **일정 등록 패널 레이아웃**.
6. **상태 관리/데이터 바인딩 추가**.

## 3. 공통 고려 사항

- **Theme**: `AppTheme`와 상태 뱃지 색상을 재사용. 카드/배경에서 `surface`/`surfaceElevated` 활용.
- **타이포그래피**: `AppTypography`의 `headlineSmall`, `titleMedium`, `bodyMedium` 등 사용.
- **Iconography**: Material Icons 기본, 필요 시 Custom Icon set 고려.
- **Responsive Layout**: 아래 3.1 ResponsiveFramework & Helper 사용 가이드 참조
- **상태관리**: Riverpod Controller(`dashboardController`, `classroomDetailController`) 설계 → API 연동 전 Mock 데이터로 UI 완성.
- **테스트 전략**:

  - 레이아웃/상태 위젯 테스트 (Widget tests).
  - Controller 단위 테스트 (데이터 필터/메트릭 계산).
  - Golden test로 카드/캘린더 모양 검증 검토.

  ### 3.1 ResponsiveFramework & Helper 사용 가이드
1. **전역 Breakpoint:** `lib/main.dart`에서 `ResponsiveBreakpoints.builder`를 통해 `MOBILE(0-599) / TABLET(600-1023) / DESKTOP(1024-1439) / 4K(1440+)`를 유지한다. 새로운 진입점이나 `MaterialApp` 구성을 변경할 때도 동일한 builder를 감싸야 한다.
2. **공통 헬퍼:** `lib/common/responsive/responsive_layout.dart`에 정의된 `ResponsiveLayoutBuilder`, `context.deviceFormFactor`, `context.responsivePagePadding()`, `context.responsiveColumns()` 등을 사용해 각 화면의 레이아웃/여백/열 수를 결정한다. 직접 `MediaQuery` 값을 계산하거나 매직 넘버를 쓰지 않는다.
3. **페이지 패딩:** 모든 주요 페이지는 `context.responsivePagePadding()`을 활용해 기본 여백 정책을 공유한다. 추가 여백이 필요하면 helper의 named parameter를 이용해 override하고, override한 이유를 주석으로 남긴다.
4. **위젯 레이아웃:** `LayoutBuilder`가 필요한 상황에서도 우선 `ResponsiveLayoutBuilder`로 formFactor를 받아 사용하고, 반복되는 반응형 패턴은 공통 responsive 위젯(예: `ResponsiveRowColumn`, 그리드 helper)으로 추상화한다.
5. **테스트:** 위젯 테스트에서 breakpoint 별 상태를 검증하려면 `ResponsiveBreakpoints.builder`로 테스트 위젯을 감싼 뒤 원하는 스크린 크기를 주입한다. formFactor 의존 로직이 있으면 각 케이스를 명시적으로 검증한다.
6. **문서 참조:** 새로운 화면을 구현할 때 본 섹션과 `docs/architecture/dashboard_design.md`의 responsive 요구사항을 함께 확인해 디자인-구현 불일치를 방지한다.

## 4. 향후 TODO

- API 계약 및 데이터 모델 문서화(frontend_api.md 확장).
- 실시간 센서/카메라 버튼 동작 정의.
- 접근성(스크린 리더, 키보드 네비게이션) 가이드 포함.
- 다국어 지원 시 `AppLocalizations` 반영.
