# 프론트 웹앱 연동용 API 레퍼런스

MDK Nest Server가 제공하는 최소 인증/감사 로그 및 시간표(TimeTable) API 계약을 정리했다. 모든 예시는 개발 환경(`http://localhost:3000`) 기준이며, 서버는 `/api/v1`을 prefix로 사용한다.

## 1. 공통 규칙
| 항목 | 값/설명 |
| --- | --- |
| Base URL | `http://localhost:3000/api/v1` (Nest `main.ts`, `PORT` 기본값 3000)
| CORS 허용 출처 | `http://localhost:53982` 한정, `credentials: true` 필요 (`app.enableCors`)
| 인증 방식 | Bearer JWT 기반. 모든 시간표 API는 `Authorization: Bearer <token>` 헤더를 요구하며, 토큰 발급/갱신은 기존 로그인 모듈이 담당한다. 레거시 세션 API는 관리 콘솔 유지 목적에 한해 `sid` 쿠키를 허용한다.
| 토큰 정책 | JWT에는 사용자 역할·권한 스코프가 포함되며, 만료 시 재로그인 또는 리프레시 토큰 플로우(구현 예정)로 갱신한다. 레거시 세션 제한(동시 접속 10개/유휴 30분/절대 8시간)은 기존 `/api` 루트에만 적용된다.
| 요청 헤더 | `Content-Type: application/json`, `Accept: application/json`
| 오류 포맷 | Nest 기본 `{ "statusCode": number, "message": string | string[], "error": string }`
| 권한 등급 | `Role.Admin`, `Role.Operator`, `Role.LimitedOperator`, `Role.Viewer`. 감사 로그 API는 `admin`만 접근 가능(`RolesGuard`). 시간표 API는 JWT의 역할 기반 권한만 검증하며 세부 스코프 에러 코드는 추후 확장 예정이다.

### 1.1 브라우저 Fetch 기본 예시
```ts
const client = async (path: string, init: RequestInit = {}) => {
  const response = await fetch(`http://localhost:3000${path}`, {
    credentials: 'include',
    headers: { 'Content-Type': 'application/json', ...init.headers },
    ...init,
  });
  if (!response.ok) throw await response.json();
  return response.json();
};
```

## 2. 인증 & 세션 API
### 2.1 `POST /api/login`
- **설명**: Passport Local 전략. `username` 필드명 고정(`LocalStrategy`). 성공 시 사용자 정보 + `sid` 쿠키 세팅.
- **필수 헤더**: `Content-Type: application/json`
- **요청 바디**
```json
{
  "username": "admin",
  "password": "plain-text"
}
```
- **성공 응답 (200)**
```json
{
  "message": "login successful",
  "user": {
    "id": 1,
    "username": "admin",
    "displayName": "시스템 관리자",
    "authType": "local"
  }
}
```
- **오류**
| 상태 | 사유 |
| --- | --- |
| 401 | 아이디/비밀번호 불일치 또는 비활성 사용자(`LocalStrategy`) |
| 429 | 전역 세션 제한 초과(`SessionsService.enforceSessionLimits`) |

> **Note**: 성공 시 `Set-Cookie: sid=<uuid>; HttpOnly; SameSite=Lax`가 내려오므로, 브라우저 요청에 `credentials: 'include'` 설정이 필수다.

### 2.2 `GET /api/me`
- **설명**: 현재 세션 사용자를 조회. `SessionAuthGuard`가 `sid` 쿠키를 검증하고 `req.user`를 주입.
- **성공 응답 (200)**
```json
{
  "id": 1,
  "userName": "admin",
  "displayName": "시스템 관리자"
}
```
- **오류**
| 상태 | 사유 |
| --- | --- |
| 401 | `sid` 누락, 만료, 타임아웃, 강제 종료 (`SessionAuthGuard`) |

> **통합 패턴**: 프론트는 앱 부팅 시 `GET /api/me`로 세션 여부를 판별하고, 401일 때 로그인 화면으로 리다이렉트한다.

### 2.3 `POST /api/logout`
- **설명**: 쿠키에 담긴 `sid`를 찾아 세션을 비활성화하고 쿠키 삭제. 가드 미적용이라 만료 세션에서도 안전하게 호출 가능.
- **성공 응답 (200)**
```json
{ "message": "logout successful" }
```
- **오류**: 서버 예외 외 특별한 케이스 없음. `sid`가 없으면 DB 작업 없이 쿠키만 제거.

## 3. 감사 로그 API (Admin)
### 3.1 `GET /api/admin/audit-logs`
- **설명**: 관리자 전용 감사 로그 목록. `SessionAuthGuard` + `RolesGuard(@Roles(Role.Admin))` 적용.
- **쿼리 파라미터**
| 파라미터 | 타입 | 기본값 | 설명 |
| --- | --- | --- | --- |
| `page` | number | 1 | 1부터 시작. 음수/0 전달 시 무시. |
| `pageSize` | number | 20 | 최대 100 권장. |
| `userId` | number | - | 특정 사용자 필터. |
| `action` | string | - | `LOGIN_SUCCESS`, `LOGOUT`, `SESSION_INVALID` 등 자유 입력. |
| `resourceType` | string | - | 예: `SYSTEM`, `DEVICE`. |
| `resourceId` | string | - | 비즈니스 리소스 식별자. |
| `result` | string | - | `SUCCESS`, `FAILURE`. |
| `from` | ISO string | - | `createdAt >= from`. |
| `to` | ISO string | - | `createdAt <= to`. |

- **응답 (200)**
```json
{
  "items": [
    {
      "id": 12,
      "createdAt": "2024-11-05T01:02:03.456Z",
      "action": "LOGIN_SUCCESS",
      "result": "SUCCESS",
      "userId": 1,
      "usernameSnapshot": "시스템 관리자",
      "sessionId": "e0f...",
      "ipAddress": "127.0.0.1",
      "userAgent": "Mozilla/5.0",
      "resourceType": "SYSTEM",
      "resourceId": "AUTH",
      "errorCode": null,
      "detail": "사용자 로그인 성공",
      "metadata": { "roles": ["admin"] }
    }
  ],
  "total": 35,
  "page": 1,
  "pageSize": 20
}
```
- **오류**
| 상태 | 사유 |
| --- | --- |
| 401 | 세션 누락/만료 |
| 403 | `admin` 역할이 아닌 경우(`RolesGuard`) |

## 4. 응답 모델 요약
### 4.1 `UserSummary`
| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | number | 사용자 PK |
| `username`/`userName` | string | 로그인 아이디 (`/api/login` vs `/api/me` naming 차이 주의) |
| `displayName` | string | UI 표시 이름 |
| `authType` | string | `local` 등 인증 소스 |

### 4.2 `AuditLogItem`
| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | number | 감사 로그 PK |
| `createdAt` | string(ISO) | 생성 시각 |
| `action` | string | 수행된 동작 코드 |
| `result` | string | `SUCCESS`/`FAILURE` |
| `userId` | number|null | 수행 주체 |
| `usernameSnapshot` | string|null | 당시 표시 이름 |
| `sessionId` | string|null | 세션 UUID |
| `ipAddress`/`userAgent` | string|null | 접속 단말 정보 |
| `resourceType`/`resourceId` | string|null | 영향받은 리소스 |
| `errorCode` | string|null | 실패 코드 |
| `detail` | string|null | 설명 메시지 |
| `metadata` | object|null | 추가 JSON 데이터 |

## 5. 프론트 구현 체크리스트
1. **로그인 폼**: `username`, `password`를 JSON으로 보내고, 응답 사용자 정보를 전역 상태(예: SessionStore)에 저장.
2. **세션 부트스트랩**: 앱 시작 시 `GET /api/me`로 로그인 여부 확인. 401이면 쿠키 삭제 없이 로그인 페이지로 이동.
3. **요청 헬퍼**: `fetch`/`axios` 인스턴스에 `withCredentials`/`credentials: 'include'` 강제.
4. **401/403 처리**: 공통 인터셉터에서 401 ➜ 로그인, 403 ➜ 권한 부족 토스트 등을 노출.
5. **감사 로그 화면(관리자)**: 필터 폼 → 쿼리 파라미터 직렬화 → 표 렌더링. 페이지네이션은 `total`, `page`, `pageSize` 활용.
6. **세션 만료 UX**: `SessionAuthGuard`가 만료 세션을 강등시키므로, `/api/me` 혹은 보호 API 호출 실패 시 사용자에게 재로그인을 안내.

---
필요 시 추가 API가 생기면 이 문서에 REST 경로, DTO, 상태 코드를 같은 포맷으로 확장한다.

## 4. 시간표(TimeTable) API

### 4.1 공통 규칙
- Base Path: `/classrooms/{classroomId}/timetable` 및 `/lectures` (모두 `/api/v1` 하위)
- 인증: `Authorization: Bearer <token>` 필수
- Optimistic Locking: `version` 필드를 사용하며 수정/삭제 시 `x-expected-version` 헤더 또는 요청 body의 `expectedVersion` 전달
- 날짜 포맷: ISO-8601(+TZ)
- 콘텐츠 타입: `application/json`

#### Lecture 엔티티 필드 (서버 기준)
| 필드 | 타입 | 설명 |
| --- | --- | --- |
| `id` | string | UUID (BaseEntity PK)
| `title` | string | 과목 또는 이벤트명
| `version` | int | Optimistic Lock 버전
| `externalCode` | string? | 외부 timetabling 코드
| `type` | enum `LectureType` | 기본 `lecture`
| `classroomId` | string | `Classroom` FK (ManyToOne)
| `departmentId` | string? | `Department` FK, nullable
| `instructorId` | string? | `User` FK, nullable
| `colorHex` | string? | `#RRGGBB`
| `startTime` | ISO string | `timestamptz`
| `endTime` | ISO string | `timestamptz`
| `recurrenceRule` | string? | iCal RRULE
| `notes` | string? | 자유 입력 메모
| `createdAt`/`updatedAt` | ISO string | BaseEntity 타임스탬프

> **참고**: Nullable 필드는 Swagger 예제에서 생략되어 있다. 프론트 로직에서는 존재 여부를 항상 체크해야 하며, `department`/`instructor` 관계는 현재 optional이다.

### 4.2 `GET /classrooms/{classroomId}/timetable`
- Query: `from`(필수), `to`(필수), `tz`(선택, 기본 `Asia/Seoul`)
- 응답: `roomId`, `range`, `tz`, `lectures: LectureDto[]`
- 상태 코드: 200, 400(잘못된 기간), 404(강의실 없음)
- **향후 확장**: `view`, `expandRecurrence`, `recurrenceExpandLimit` 및 복수 필터(`departmentId`, `instructorId`, `type`, `status`)를 분석만 하고 있으니, 구현 시 이 문서를 업데이트한다는 TODO를 남겨 둔다.

### 4.3 `POST /lectures`
- Body: `title`, `type`, `classroomId`, `startTime`, `endTime`, 선택 필드(`externalCode`, `departmentId`, `instructorId`, `colorHex`, `recurrenceRule`, `notes`)
- 응답: 201 + 생성된 `LectureDto`
- 오류: 400(검증 실패), 404(없는 `classroomId`)

### 4.4 `PATCH /lectures/{lectureId}`
- Headers: `x-expected-version`(선택)
- Body: 변경 필드 + `expectedVersion` 허용
- 응답: 200 + 최신 `LectureDto`
- 오류: 404(리소스 없음), 409(버전 충돌, 응답 `error.details.latest`에 최신 DTO 포함)

### 4.5 `DELETE /lectures/{lectureId}`
- Headers: `x-expected-version` 필수
- 응답: 204
- 오류: 404(리소스 없음), 409(버전 충돌)

### 4.6 샘플 연동 순서
1. `POST /lectures`로 강의 생성 후 `id`/`version` 확보
2. `GET /classrooms/{classroomId}/timetable`로 신규 일정 확인
3. 필요 시 `PATCH /lectures/{lectureId}` + `x-expected-version` 헤더로 수정
4. 삭제는 `DELETE /lectures/{lectureId}` + 최신 버전 헤더 사용
5. 재조회하여 리스트 반영 여부 확인

> 다중 필터 및 세부 권한/에러 스펙은 아직 미구현 상태이므로, 구현 완료 시 4.2 섹션에 추가한다.
