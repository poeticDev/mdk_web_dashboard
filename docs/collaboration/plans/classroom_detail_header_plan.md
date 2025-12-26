# Classroom Detail Header Provider 설계안

## 목적
강의실 상세 페이지에서 "데이터 소유"를 페이지가 아닌 Riverpod provider 계층으로 이동시키고, 헤더 섹션을 데이터 의존성 단위로 분리한다. 이 문서는 실제 구현 전에 필요한 provider 조합, 위젯 분할, 책임 범위를 정의한다.

## 1. Provider 목록과 역할
| Provider | 타입/스코프 | 입력 key | 책임 & 주요 의존성 |
| --- | --- | --- | --- |
| `classroomDetailRepositoryProvider` | `Provider<ClassroomDetailRepository>` | - | ClassroomDetailDto ↔ 엔티티 매핑 및 API 호출 추상화. getIt에서 repository 주입. |
| `classroomDetailParamsProvider` | `Provider<ClassroomDetailParams>` | - | 라우팅으로 전달된 `classroomId` · locale 등을 묶어 하위 family provider들이 공통 참조하도록 함. `ClassroomDetailPage`가 override. |
| `classroomDetailInfoProvider` | `AutoDisposeAsyncNotifierProviderFamily<ClassroomDetailInfo, String>` | `classroomId` | 기본 정보 API 호출, DTO를 `ClassroomDetailInfo`(name, building, devices, config 등)로 변환. 실패 시 retry/error 상태를 노출. |
| `classroomSummaryViewModelProvider` | `Provider.family<ClassroomSummaryInfo, String>` | `classroomId` | `classroomDetailInfoProvider` + (필요 시) 현재 세션/교수/수용인원 파생 데이터를 헤더용 요약 모델로 투영. |
| `classroomDeviceCatalogProvider` | `Provider.family<List<ClassroomDevice>, String>` | `classroomId` | 기본 정보에서 장비 목록만 슬라이싱해 장치 패널 전용 뷰 모델 생성. |
| `classroomSensorSnapshotProvider` | `AutoDisposeNotifierProviderFamily<ClassroomSensorSnapshot, String>` | `classroomId` | 센서 API 미구현 단계에서 더미 데이터를 관리. 이후 실제 REST 클라이언트 연동 시 이 provider 구현만 교체. 내부적으로 `Timer`로 모의 갱신 또는 seed 데이터를 유지. |
| `classroomEnvironmentMetricsProvider` | `Provider.family<List<EnvironmentMetric>, String>` | `classroomId` | `classroomSensorSnapshotProvider`를 구독해 UI에 필요한 값/단위를 `EnvironmentMetric` 리스트로 변환. |
| `classroomDeviceToggleControllerProvider` | `AutoDisposeNotifierProviderFamily<DeviceToggleControllerState, String>` | `classroomId` | 장비 토글 상태를 노출하고 변경 커맨드를 큐잉. 기본 정보/센서 provider에서 초기 상태를 받아 optimistic 업데이트를 처리. 추후 실제 명령 API 추가 시 이 provider가 책임. |
| (기존) `classroomTimetableControllerProvider` | `StateNotifierProviderFamily` | `classroomId` | 시간표/occurrence 데이터 관리. 헤더 세션 표시에서 현재 수업 정보가 필요하면 selector provider로 조합. |
| `classroomCurrentSessionProvider` | `Provider.family<ClassroomSessionSnapshot?, String>` | `classroomId` | `classroomTimetableControllerProvider`의 state를 참조해 현재/다음 수업 정보를 헤더 세션 카드에 제공. |
| `classroomHeaderErrorProvider` | `Provider.family<ClassroomHeaderErrorState, String>` | `classroomId` | 기본 정보 · 센서 · 디바이스 토글 provider들의AsyncError를 모아 페이지 상단 SnackBar 노출 여부를 중앙 관리. |

## 2. 헤더 섹션 분해 제안
1. **ClassroomHeaderShell**: 레이아웃 전용 wrapper. 데이터는 모두 하위 위젯에서 직접 provider를 구독한다.
2. **ClassroomIdentityPanel** (기존 RoomTitle 영역): 강의실명/학과/빌딩/카메라 버튼. `classroomSummaryViewModelProvider` + `classroomDetailInfoProvider`(빌딩/코드)만 필요.
3. **ClassroomSessionPanel** (기존 RoomSummaryCard + Occupancy): 현재 수업명, 교수, 시간, 수용인원, 상태 뱃지를 노출. `classroomSummaryViewModelProvider`와 `classroomCurrentSessionProvider`를 조합.
4. **ClassroomDevicePanel**: 장비 토글 리스트. `classroomDeviceCatalogProvider` + `classroomDeviceToggleControllerProvider`를 구독해 상태/커맨드를 분리.
5. **ClassroomEnvironmentPanel**: 온도/습도 등 센서 카드 묶음. `classroomEnvironmentMetricsProvider` 전용. (향후 카드 종류가 늘어도 provider만 확장하면 됨.)
6. **Alerts/StatusBar (선택)**: provider 오류나 센서 연결 상태 등을 요약해 표시. `classroomHeaderErrorProvider` 의존.

## 3. 하위 위젯별 provider 구독 매핑
| 위젯 | Provider 구독 | 메모 |
| --- | --- | --- |
| `ClassroomHeaderShell` | 없음 (children만 배치) | 외부에서 `roomId`를 전달받아 `ProviderScope` override 혹은 widget 파라미터로 주입.
| `ClassroomIdentityPanel` | `classroomSummaryViewModelProvider(roomId)` | building/code/department 추가 필드가 필요하면 `classroomDetailInfoProvider(roomId).when` 으로 병합.
| `ClassroomSessionPanel` | `classroomSummaryViewModelProvider(roomId)`, `classroomCurrentSessionProvider(roomId)` | session provider가 null이면 "현재 수업 없음" 메시지를 출력.
| `ClassroomDevicePanel` | `classroomDeviceCatalogProvider(roomId)`, `classroomDeviceToggleControllerProvider(roomId)` | catalog는 정적 메타, controller는 토글 상태/액션을 담당.
| `ClassroomEnvironmentPanel` | `classroomEnvironmentMetricsProvider(roomId)` | Async 상태를 반영해 shimmer/에러 처리 가능.
| `ClassroomCameraAction` (버튼) | `classroomDetailInfoProvider(roomId)` | config에 따라 진입 가능 여부를 결정.
| `HeaderAlertBanner` | `classroomHeaderErrorProvider(roomId)` | fetch 실패 시 재시도 액션 제공.

## 4. 센서 정보 provider의 임시 전략
- `classroomSensorSnapshotProvider`는 `AutoDisposeNotifier`로 선언하고, `@visibleForTesting`한 `seedData`를 주입받아 더미 JSON을 유지한다.
- 기본 구현은 `Future.value(_mockSnapshot)`을 반환하거나 `StateNotifier` 내에서 `Timer.periodic`으로 값을 약간씩 변형시켜 UI 갱신을 검증한다.
- 실제 API가 준비되면 notifier 내부에서 REST 호출/웹소켓 구독으로 교체하되, 외부 위젯/상위 provider는 `EnvironmentMetric`만 의존하므로 수정 영향이 최소화된다.
- 더미 데이터 소스는 `lib/ui/classroom_detail/mocks/classroom_sensor_mock.dart` 등 별도 파일에 두고, provider는 현재 sandbox인지 여부(예: `kReleaseMode`)를 기준으로 더미/실제 구현을 선택하도록 설계.

## 5. ClassroomDetailPage 책임 범위
- `ClassroomDetailPage`를 `ConsumerWidget`(또는 `ConsumerStatefulWidget`)으로 전환하되, **레이아웃/탭/스크롤** 만 담당한다.
- `roomId`를 `ClassroomDetailHeaderSection`과 `ClassroomTimetableSection`에 전달하거나, `ProviderScope(overrides: [classroomDetailParamsProvider.overrideWithValue(...)]` 형태로 자식 전체에 주입.
- Page 레벨에서 수행할 일:
  1. `ref.listen(classroomHeaderErrorProvider(roomId), ...)`를 통해 공통 오류 SnackBar/다이얼로그만 처리.
  2. 상단 AppBar 타이틀은 `classroomSummaryViewModelProvider(roomId)`를 구독해 실시간으로 반영.
  3. Timetable 영역은 기존 컨트롤러 provider를 그대로 사용 (변경 없음).
- Page가 mock 데이터를 직접 만들거나 상태를 `setState`로 관리하지 않으며, 모든 UI 데이터는 provider → 하위 위젯 경유로 흐른다.

## 6. 추가 고려 사항
- Provider 간 의존 관계가 많으므로 `classroom_detail_providers.dart` 파일을 추가해 family/provider 구성을 한곳에서 관리한다.
- 헤더 각 위젯은 `classroomId`만 매개변수로 받고 내부에서 `Consumer`로 provider를 구독하도록 리팩터링한다.
- 추후 `ClassroomDetailHeaderData` 모델은 UI 편의용 DTO로 유지하되, provider 조합 결과를 담는 용도로만 사용하거나 위젯 단위로 더 잘게 분할해도 된다.
- 테스트: 각 provider family에 대한 단위 테스트를 작성하여 더미/실제 구현 스위칭 시 회귀를 방지한다.

