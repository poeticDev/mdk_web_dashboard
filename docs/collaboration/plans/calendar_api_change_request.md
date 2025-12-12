# 📮 Calendar API 수정 요청 (백엔드 전달용)

## 1. 배경
- `docs/collaboration/design_notes/calendar_design.md` 기준으로 `syncfusion_flutter_calendar` UI를 연결하려면 강의 일정 CRUD 및 필터 API가 필요하다.
- 현재 `docs/architecture/frontend_api.md`에는 인증/감사 로그만 정의되어 있어 캘린더 계약이 공백 상태다.

## 2. 신규/수정 API 제안

### 2.1 `GET /api/lectures`
- 쿼리: `from`(ISO), `to`(ISO), `classroomId`(필수, 단일), `departmentId?`, `instructorId?`, `type?`, `status?`.
- 응답 필드: `id`, `title`, `type`, `classroomId`, `classroomName`, `departmentId`, `departmentName`, `instructorId`, `instructorName`, `colorHex?`, `startTime`, `endTime`, `recurrenceRule?`, `recurrenceException?[]`, `status`(ACTIVE/CANCELED).
- 정렬: `startTime` ASC, `id` ASC secondary.

### 2.2 `POST /api/lectures`
- Body: 위 필드 + `notes?`.
- 검증: 시간 겹침 시 409, 권한 오류 시 403.

### 2.3 `PUT /api/lectures/:id`
- 전체 업데이트, `PATCH` 대체 가능.
- 반복 일정 수정 시 `recurrenceRule`/`recurrenceException` 처리 규칙 명시 필요.

### 2.4 `DELETE /api/lectures/:id`
- soft delete 권장 (`status = CANCELED`, `canceledBy`, `canceledAt`).
- 휴강 처리 시 기존 색상의 채도를 낮춘 상태를 클라이언트가 반영할 수 있도록 `status` 필드로 구분.

### 2.5 참조 데이터
- `GET /api/departments`, `GET /api/instructors`, `GET /api/classrooms`를 최소 ID/이름 페이로드로 노출(필터 드롭다운용).
- 5분 캐시 허용, 변경 감지는 ETag/Last-Modified 추천.

## 3. 권한 정책 업데이트
- Role 목록: `ADMIN`, `OPERATOR`, `LIMITED_OPERATOR`, `VIEWER` (백엔드 기준 이미 반영됨).
- 권한 매핑:
  - `ADMIN`/`OPERATOR`: 모든 강의 CRUD 가능.
  - `LIMITED_OPERATOR`: 지정 `classroomId` 범위만 CRUD 가능. 범위를 토큰/DB 매핑으로 넘겨야 함.
  - `VIEWER`: 조회-only, POST/PUT/DELETE 호출 시 403 + 명시적 에러코드(`CALENDAR_VIEW_ONLY`).

## 4. 응답/에러 표준화
- 에러 payload: `{ "code": "CALENDAR_DUPLICATED_SLOT", "message": "...", "details": {...} }`
- 겹침 감지는 `409 Conflict`.
- 권한 오류는 `403` + `code`.

## 5. 향후 확장 Hook
- Recurrence 예외: 배열(`[{ date: ISO, replacementLectureId?: string }]`).
- Color: `colorHex` 없으면 서버가 타입별 기본 hex 제공 가능(프론트 변주 규칙 참고용).
- Audit: 모든 CRUD는 감사 로그에 `resourceType = "LECTURE"`로 기록.

## 6. 일정
- API 설계 초안 공유: ASAP (이 문서 기준).
- 백엔드 구현 + 스테이징 배포: 캘린더 UI 개발 시작 1주 전까지.
- 계약 확정 시 `docs/architecture/frontend_api.md` 갱신 필요.
