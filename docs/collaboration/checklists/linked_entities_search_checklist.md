# 연관 엔티티 검색 컴포넌트 체크리스트

> 기준 문서: `docs/collaboration/plans/linked_entities_search_plan.md`

## 데이터 계층
- [x] 학과 DTO/RemoteDataSource/Repository/UseCase 구현 (`GET /departments`, `POST /departments/batch`)
- [x] 유저 DTO/RemoteDataSource/Repository/UseCase 구현 (`GET /users?q=`)
- [x] 공통 `EntitySearchQuery` / `EntitySearchResult` 모델 정의 및 테스트
- [x] Riverpod Provider 등록 + DI 연동 (`service_locator.dart`)

## Riverpod 상태 & Controller
- [x] `EntitySearchController` (AsyncNotifier) 구현 및 autoDispose.family Provider 선언
- [x] 검색 디바운스, 요청 취소, 재시도 로직 테스트
- [ ] Provider 기반 재사용 예제/샘플 Widget 작성

## 공통 검색 UI 컴포넌트
- [x] `EntitySearchField` 위젯 (텍스트 필드 + 팝오버) 구현
- [x] ModalBottomSheet(모바일) 대응 UI 구현
- [ ] 접근성(키보드 탐색/ARIA/Semantics) 적용
- [x] 위젯 테스트/골든 스냅샷 추가

## Classroom Timetable Modal 적용
- [ ] 학과 입력 필드 → 검색 컴포넌트로 교체 (`departmentId` 연동)
- [ ] 담당자 입력 필드 → 검색 컴포넌트로 교체 (`instructorId` 연동)
- [ ] 선택/초기화/검증 로직 업데이트 (SnackBar/Validation)
- [ ] 회귀 테스트(수동/자동)로 기존 기능 영향 확인

## 검증 & 문서
- [ ] 새 Repository/Controller/Widget 단위 테스트 통과 (`flutter test`)
- [ ] 필요 시 샘플/Storybook 문서화
- [ ] 체크리스트 업데이트 및 PR 템플릿 요건 반영
