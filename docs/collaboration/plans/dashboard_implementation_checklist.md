# 대시보드 구현 체크리스트 (SSE 기반)

이 문서는 `docs/collaboration/design_notes/dashboard_design.md` 기준으로
대시보드 구현을 단계별 체크리스트로 정리한다. 각 항목 완료 시 `[x]`로 변경하고,
핵심 변경 사항이 있으면 즉시 문서를 갱신한다.

## 0. 사전 준비
- [x] dashboard SSE API 플랜 최신 버전 확인 (`docs/plans/dashboard_api_plan.md`)
- [x] Base URL 및 인증 방식(/api/v1, 쿠키 기반 세션) 재확인
- [x] foundation 초기 선택 정책 확정(로그인 응답의 site/building/department)

## 1. 데이터 계층 준비
- [x] Foundation classrooms 목록 API 연동 준비
  - [x] `GET /api/v1/foundations/{foundationType}/{foundationId}/classrooms` DTO 정의
  - [x] 응답에 `buildingName`, `departmentName` 포함 여부 확인
- [x] RoomState SSE 구독/스트림 API 연동 준비
  - [x] `POST /api/v1/stream/room-states/subscriptions` 요청 DTO 정의
  - [x] `GET /api/v1/stream/room-states?subscriptionId=...` SSE 파서 준비
- [x] Current Lecture SSE 구독/스트림 API 연동 준비
  - [x] `POST /api/v1/stream/occurrences/now/subscriptions` 요청 DTO 정의
  - [x] `GET /api/v1/stream/occurrences/now?subscriptionId=...` SSE 파서 준비

## 2. ViewModel/State 정의
- [x] `DashboardClassroomCardVM` 정의
  - [x] `usageStatus`/`currentLecture`/`roomState` 구조 반영
- [x] `DashboardMetricsVM` 정의
  - [x] `scheduleSummary` + `occupancySummary.notLinked` 기준 반영
- [x] `DashboardFilterState` 정의
- [x] `DashboardState` 정의

## 3. SSE 매핑 로직 구현
- [x] RoomState snapshot → ViewModel 매핑
- [x] RoomState delta → ViewModel 부분 갱신
- [x] Occurrence snapshot → ViewModel 매핑
- [x] `unlinked` 처리(초기 snapshot 전 포함)

## 4. Controller/Provider 설계
- [x] `dashboardController` 설계 (Riverpod + Controller 패턴)
- [x] 로딩/에러/스트리밍 상태 전이 구현
- [x] 필터/검색 로컬 적용 로직 구현

## 5. UI 구현
- [x] `DashboardHeader` (KPI + 검색) 구현
  - [x] KST 기준 날짜+시각 표시
  - [x] KPI 카드 클릭 시 필터 토글
- [x] `ClassroomCard` 구현
  - [x] usageStatus/재실/장비 상태 배지 표시
  - [x] 휴강 표시(`(휴강)` prefix)
- [x] 그리드 레이아웃/반응형 적용

## 6. 데이터 소스/스트림 연동
- [x] Foundation 목록 API 데이터소스/리포지토리 구현
- [x] RoomState SSE 구독/스트림 데이터소스 구현
- [x] Occurrence SSE 구독/스트림 데이터소스 구현
- [x] Dashboard 컨트롤러 초기 로드/구독 연결
- [ ] 연동 검증 체크리스트 반영
  - [ ] Foundation 목록 API 200 확인 + 카드 수 일치
  - [ ] RoomState 구독 생성/연결 성공
  - [ ] roomState.snapshot 수신 후 카드 상태 갱신 확인
  - [ ] roomState.delta 수신 시 해당 카드만 갱신 확인
  - [ ] occurrence.now.snapshot 수신 후 강의 정보 표시 확인
  - [ ] scheduleSummary/occupancySummary 기반 KPI 반영 확인
  - [ ] SSE 재연결 시 Last-Event-ID 동작 확인(가능 시)

## 7. 테스트
- [ ] ViewModel/매핑 로직 단위 테스트
- [ ] 필터/검색 단위 테스트
- [ ] 위젯 테스트 (KPI/카드/빈 상태)
- [ ] SSE 수신 시 갱신 시나리오 통합 테스트(선택)

## 8. 검증
- [ ] `flutter analyze` 통과
- [ ] `flutter test` 통과
- [ ] 런타임 스모크 테스트(대시보드 진입/카드 렌더링)

---
이 체크리스트는 구현 진행 상황에 맞춰 업데이트한다.
