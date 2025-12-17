# 시간표(TimeTable) REST API 요약 v1 (2025-12-17)

웹앱/관제웹이 오늘 바로 연동할 수 있도록, 시간표 도메인의 CRUD REST 엔드포인트를 정리한 문서다. 모든 요청/응답은 `Content-Type: application/json` + ISO-8601(+TZ) 문자열을 사용하며, 인증은 기존 JWT 헤더(`Authorization: Bearer ...`) 규칙을 따른다.

## 공통 정보
- Base URL (dev): `http://localhost:3000/api/v1`
- Swagger 문서: `http://localhost:3000/docs`
- Optimistic Locking: `version` 필드 사용. 수정/삭제 시 `x-expected-version` 헤더(정수) 또는 PATCH body의 `expectedVersion`로 현재 버전을 전달해야 한다.

---

## 1. 강의실 시간표 조회 — `GET /classrooms/{classroomId}/timetable`
- **Query**
  - `from` (필수): ISO-8601 문자열. 예 `2025-12-17T00:00:00Z`
  - `to` (필수): ISO-8601 문자열. `from`보다 나중이어야 함.
  - `tz` (선택): 표시용 timezone. 기본 `Asia/Seoul`
  - `view`, `expandRecurrence`, `recurrenceExpandLimit`: 현재는 파싱만 하고 로직에는 미반영.
- **응답 200 (예시)**
```json
{
  "roomId": "e3e70682-c209-4cac-629f-6fbed82c07cd",
  "range": { "from": "2025-12-17T00:00:00Z", "to": "2025-12-17T06:00:00Z" },
  "tz": "Asia/Seoul",
  "lectures": [
    {
      "id": "22222222-2222-2222-2222-222222222222",
      "version": 1,
      "title": "자료구조",
      "type": "lecture",
      "classroomId": "e3e70682-c209-4cac-629f-6fbed82c07cd",
      "startTime": "2025-12-17T01:00:00.000Z",
      "endTime": "2025-12-17T02:30:00.000Z",
      "createdAt": "2025-12-16T23:55:00.000Z",
      "updatedAt": "2025-12-16T23:55:00.000Z"
    }
  ]
}
```
- **에러**: 404(강의실 없음), 400(잘못된 기간).

## 2. 강의 생성 — `POST /lectures`
- **Body (예시)**
```json
{
  "title": "네트워크",
  "type": "lecture",
  "classroomId": "e3e70682-c209-4cac-629f-6fbed82c07cd",
  "startTime": "2025-12-17T05:00:00Z",
  "endTime": "2025-12-17T06:30:00Z",
  "notes": "관제 테스트"
}
```
- **응답 201**: 생성된 `LectureDto` 반환(필드 동일 + `id`, `version`, `createdAt`, `updatedAt`).
- **에러**: 404(존재하지 않는 `classroomId`), 400(Validation 실패).

## 3. 강의 수정 — `PATCH /lectures/{lectureId}`
- **Headers**: `x-expected-version` (정수, 선택). Body 내 `expectedVersion` 사용도 허용.
- **Body (예시)**
```json
{
  "expectedVersion": 1,
  "startTime": "2025-12-17T05:30:00Z",
  "endTime": "2025-12-17T07:00:00Z",
  "notes": "시간 조정"
}
```
- **응답 200**: 최신 `LectureDto` (버전+1) 반환.
- **에러**
  - 404: `lectureId` 없음 또는 이동할 `classroomId`가 없음.
  - 409: 버전 충돌 → 응답 body의 `error.details.latest`에 최신 Lecture DTO 포함.

## 4. 강의 삭제 — `DELETE /lectures/{lectureId}`
- **Headers**: `x-expected-version` (필수, 정수)
- **응답 204**: 본문 없음.
- **에러**
  - 404: 강의 존재하지 않음.
  - 409: 버전 충돌 → 최신 Lecture DTO 포함.

---

## 샘플 워크플로 (Postman 기준)
1. **생성**: POST `/lectures` → 응답의 `id`, `version` 기록.
2. **조회**: GET `/classrooms/{id}/timetable?from=...&to=...` → 목록 확인.
3. **수정**: PATCH `/lectures/{id}` + 헤더 `x-expected-version: {version}` → 성공 후 version+1.
4. **삭제**: DELETE `/lectures/{id}` + 헤더 `x-expected-version: {최신버전}`.
5. **검증**: GET 재호출 시 삭제된 강의가 목록에서 빠졌는지 확인.

## 추가 참고 사항
- Swagger UI에서 모든 엔드포인트에 한국어 설명/예시가 준비되어 있으니, 웹앱 개발 전 필드명과 응답 구조를 직접 확인할 수 있다.
- RRULE 전개, 이벤트 스트리밍, 권한 스코프 등의 고급 기능은 아직 미구현 상태로, 현재는 문자열 저장/조회만 제공한다.
