# 📮 Calendar API 수정 요청 (백엔드 전달용)

## 1. 배경
- `docs/collaboration/design_notes/calendar_design.md` 기준으로 `syncfusion_flutter_calendar` UI를 연결하려면 강의 일정 CRUD 및 필터 API가 필요하다.
- 현재 `docs/architecture/frontend_api.md`에는 인증/감사 로그만 정의되어 있어 캘린더 계약이 공백 상태다.

## 2. 시간표 API 계약 (v1 정리)

### 2.1 `GET /api/v1/classrooms/{classroomId}/timetable`
- 쿼리: `from`(ISO, 필수), `to`(ISO, 필수), `tz?` (기본 `Asia/Seoul`).
- 응답 필드: `roomId`, `range.from`, `range.to`, `tz`, `lectures: LectureDto[]` (`LectureDto`는 서버 엔티티 속성 전부 포함).
- 정렬: 서버에서 `startTime` ASC.
- **미구현/메모**: `departmentId`, `instructorId`, `type`, `status`, recurrence 확장 옵션(`view`, `expandRecurrence`, `recurrenceExpandLimit`)은 현재 파싱만 수행. API 확장 시 본 섹션 업데이트.

### 2.2 `POST /api/v1/lectures`
- Body: `title`, `type`, `classroomId`, `startTime`, `endTime`, 선택 필드(`externalCode`, `departmentId`, `instructorId`, `colorHex`, `recurrenceRule`, `notes`).
- 응답: 201 + 생성된 `LectureDto` (`id`, `version`, `createdAt`, `updatedAt` 포함).
- 검증: 404(없는 `classroomId`), 400(기간/필수값 오류).

### 2.3 `PATCH /api/v1/lectures/{lectureId}`
- Headers: `x-expected-version`(선택) 또는 body `expectedVersion`.
- Body: 수정하려는 필드만 포함 가능.
- 응답: 200 + 최신 `LectureDto`.
- 충돌: 409 응답 `error.details.latest`에 최신 DTO 반환.

### 2.4 `DELETE /api/v1/lectures/{lectureId}`
- Headers: `x-expected-version` 필수.
- 응답: 204(No Content).
- 충돌 처리 동일 (409 + 최신 DTO).

### 2.5 참조 데이터 / 보조 API
- 부서·강사·강의실 목록 API는 아직 스펙 미정. UI에서 캐싱 가능한 단순 목록 API가 필요하면 별도 RFC로 다룬다.

## 3. 권한 정책 업데이트
- Role 목록: `ADMIN`, `OPERATOR`, `LIMITED_OPERATOR`, `VIEWER` (JWT `roles` 클레임으로 전달).
- Bearer 토큰 인증은 필수지만, 세부 권한 매핑/스코프 검증은 아직 구현되지 않았다. 추후 `LIMITED_OPERATOR`의 `classroomId` 범위 제한, `VIEWER` 전용 에러 코드(`CALENDAR_VIEW_ONLY`) 등을 반영해야 한다.

## 4. 응답/에러 표준화
- 현재는 Nest 기본 에러 포맷을 그대로 따른다. 캘린더 도메인 전용 `code` 값을 추가하는 작업(`CALENDAR_DUPLICATED_SLOT`, `CALENDAR_VIEW_ONLY`)은 일정 분리 후 진행한다.
- 시간 겹침 감지, 권한 부족 처리 시 HTTP 상태 코드(409, 403)를 우선 도입하고, 세부 payload 스펙을 확정하면 본 섹션을 갱신한다.

## 5. 향후 확장 Hook
- Recurrence 예외 배열(`[{ date: ISO, replacementLectureId?: string }]`) 설계는 RRULE 전개가 붙을 때 정의한다.
- Color: `colorHex` 미지정 시 서버 기본값을 내려줄지 여부 TBD.
- Audit: 모든 CRUD를 감사 로그(`resourceType = "LECTURE"`)에 적재하도록 백엔드와 협의 예정.

## 6. 일정
- v1 TimeTable API (`/api/v1`)는 2025-12-17 기준 명세 확정.
- 필터/권한/에러 확장 및 참조 데이터 API는 별도 RFC로 다루며, UI 개발 착수 1주 전까지 합의한다.
- 계약 확정 시 `docs/architecture/frontend_api.md`/`docs/collaboration/design_notes/calendar_design.md`를 동기화한다.
