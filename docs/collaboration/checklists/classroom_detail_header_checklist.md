# Classroom Detail Header 리팩터링 체크리스트

> 참조 설계: `docs/collaboration/plans/classroom_detail_header_plan.md`
> 원칙: 각 단계 완료 시 - [x]로 표시하고, 실제 구현/설계 변경분은 체크리스트와 설계 문서 모두에 반영한다.

## 준비
- [x] 담당 브랜치 최신화 및 설계 문서 재검토
- [x] 필요한 DTO/Repository 스펙 재확인 (`ClassroomDetailDto`, timetable 모듈 등)

## 구현 단계
1. **Provider 토대 구성**
   - [x] `lib/domains/foundation`/`lib/domains/devices` 구조 점검 및 repository contract 정의(필요 시 stub)
   - [x] `classroomRepositoryProvider`/`classroomDeviceRepositoryProvider` 등 공통 Provider 정의 파일(`classroom_detail_providers.dart`) 생성
2. **기본 정보 provider**
   - [x] `classroomDetailInfoProvider`를 `AutoDisposeAsyncNotifierProviderFamily`로 구현 (API + mapper 연결)
   - [x] `classroomSummaryViewModelProvider`, `classroomDeviceCatalogProvider` 파생 provider 추가 및 단위 테스트 작성
3. **센서/환경 provider**
   - [x] 더미 데이터 소스(`classroom_sensor_mock_data_source.dart`) 작성
   - [x] `classroomSensorSnapshotProvider` + `classroomEnvironmentMetricsProvider` 구현, 주기적 갱신 로직 포함
4. **디바이스 토글 컨트롤러**
   - [x] `classroomDeviceToggleControllerProvider` 초안 (optimistic state, 액션 stub)
   - [x] 향후 API 연동을 위한 TODO/인터페이스 명시
5. **헤더 위젯 분해 및 provider 주입**
   - [x] `ClassroomDetailHeaderSection`을 shell + Identity/Session/Device/Environment 패널 위젯으로 분리
   - [x] 각 위젯이 직접 provider를 구독하도록 Consumer 리팩터링
   - [ ] Header alert/status bar 구현 및 `classroomHeaderErrorProvider` 연결
6. **페이지 책임 조정**
   - [x] `ClassroomDetailPage`를 Consumer 기반으로 전환하고 ProviderScope override/roomId 전달 로직 정리
   - [x] AppBar/에러 Snackbar 등이 provider 상태를 반영하도록 수정
7. **검증 및 문서 갱신**
   - [x] 새 provider/위젯 단위 테스트 및 기존 timetable 테스트 통과 확인
   - [x] 설계 문서와 본 체크리스트 진행 상황 업데이트
   - [ ] PR 노트/가이드라인에 주요 설계 변경 요약
