# 연관 엔티티 검색 기능 결과 요약

## 1. 개요
- **목표**: 강의실 시간표 모달에서 학과/담당자 정보를 실제 DB와 연동해 검색·선택·검증하도록 하고, 동일 컴포넌트를 다른 화면에서도 재사용할 수 있게 준비.
- **참고 설계**: `docs/collaboration/plans/linked_entities_search_plan.md`
- **진행 체크**: `docs/collaboration/checklists/linked_entities_search_checklist.md`

## 2. 구현 산출물
| 레이어 | 경로 | 설명 |
| --- | --- | --- |
| 데이터 | `lib/core/directory/...` | 학과/유저 DTO, RemoteDataSource, Repository, UseCase, Provider, DI 등록 |
| 상태 | `lib/core/directory/application/controllers/entity_search_controller.dart` | Riverpod Family AsyncNotifier + 테스트 |
| 공통 UI | `lib/common/widgets/entity_search/entity_search_field.dart` | 텍스트 필드 + 드롭다운/BottomSheet 검색 위젯 (accessibility 적용) |
| 소비처 | `lib/ui/classroom_detail/widgets/classroom_timetable_modal.dart` | 학과/담당자 필드가 EntitySearchField로 교체, id 기반 제출 |
| 테스트 | `test/core/directory/...`, `test/common/widgets/entity_search_field_test.dart` | 데이터/컨트롤러/위젯 단위 테스트 |

## 3. 남은 작업 / 주의사항
- **회귀 테스트**: 모달 교체 이후 전체 Classroom Detail 흐름에 대한 수동/자동 회귀 테스트 필요(체크리스트 항목 미완).
- **문서화**: Storybook 혹은 샘플 화면 스크린샷이 아직 없음 → 향후 UI 가이드에 추가 권장.
- **데이터 보강**: `LectureViewModel` 에 학과/담당자 id 정보가 없어, 수정 모드 초기값을 name으로 대체하고 있음. 추후 API/엔티티 확장 시 id 를 포함하도록 개선 필요.

## 4. 향후 재사용 가이드
1. 다른 화면에서 검색이 필요하면 `EntitySearchField` + 적절한 `EntitySearchArgs` 를 사용.
2. 선택된 엔티티 정보는 `EntityOption` 으로 전달되므로, id/label/metadata 를 필요에 맞게 저장.
3. 키보드/스크린리더 지원이 필요한 경우 `enableBottomSheetOnNarrow`, `onCleared` 옵션을 상황에 맞게 조정.

## 5. 레퍼런스
- 서버 API 문서: `/Users/poeticdev/workspace_back/mdk-nest-server/docs/frontend_api.md`
- Riverpod 규칙: `docs/reference_guides/riverpod_rules.md`
