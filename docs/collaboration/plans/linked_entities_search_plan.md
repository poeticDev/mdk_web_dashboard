# 강의 연관 엔티티 검색 컴포넌트 설계

## 1. 요청 요약
- 강의 엔티티 생성/수정 시 학과와 담당자(유저) 정보를 실제 DB에서 검색해 선택할 수 있어야 한다.
- 향후 강의실, 유저, 빌딩 등 다른 도메인에서도 동일한 검색 UI를 재사용할 수 있도록 공통 컴포넌트를 먼저 구축한다.
- 1차 적용 대상은 `classroom_timetable_modal.dart` (강의 등록/수정 모달)이며, 기존의 단순 텍스트 필드를 검색 컴포넌트로 교체한다.

## 2. 범위와 목표
1. **데이터 조회 계층**
   - 학과, 유저 검색 API를 호출하는 DTO/RemoteDataSource/Repository/UseCase를 설계한다.
   - 필터, 페이지네이션 대비를 위해 검색어·limit·cursor 기반 파라미터를 받아야 한다.
   - 반복 호출이 잦으므로 결과 TTL 캐시 또는 in-flight dedupe를 고려한다.
2. **공통 검색 UI 컴포넌트**
   - `EntitySearchField`(가칭): 라벨, 플레이스홀더, 선택 콜백, 선택 값 표시, clear 버튼 제공.
   - 입력 디바운스(예: 250ms) + 로딩 인디케이터 + 결과 리스트를 드롭다운/모달로 노출.
   - Riverpod 기반 상태관리: `EntitySearchController` + `entitySearchResultsProvider`.
3. **Classroom Timetable Modal 적용**
   - 학과/담당자 필드를 각각 학과 검색, 유저 검색으로 교체.
   - 선택 결과는 `LectureOriginWriteInput` 생성 시 `departmentId`/`instructorId`로 주입.
   - 기존 free-text 입력 대비 UX 변화(검색 실패, 필수 여부)에 대한 안내 문구 추가.

## 3. API 계약 (서버 문서 기준)
- 참고 문서: `/Users/poeticdev/workspace_back/mdk-nest-server/docs/frontend_api.md`
- 학과
  - `GET /departments?q=`: 이름/코드 부분 검색. `q` 누락 시 전체 목록 반환. (`frontend_api.md` 4.3 참조)
  - `POST /departments/batch`: `{ "departmentIds": [...] }` 로 일괄 조회, 응답 배열 순서 보존.
- 사용자
  - `GET /users?q=`: username/displayName에 검색어가 포함된 사용자만 반환. 응답 예시는 `[{ id, username, displayName, departmentName? }]`. (`frontend_api.md` 4.4)
- 응답 형태가 리스트이므로 UI 페이지네이션이 필요하면 프론트에서 클라이언트 페이징 혹은 추가 API 협의가 필요하다.
- 서버 문서에 페이징/limit 파라미터가 언급되지 않았으므로, 초기 버전은 검색어 필터 + 전량 로딩을 기본으로 구현하고, 데이터가 많아질 경우 백엔드에 추가 파라미터(예: `limit`, `cursor`) 확장을 제안한다.

## 4. 아키텍처 제안
```
UI(EntitySearchField) ──> Controller(EntitySearchController, notifier)
                         │
                         ▼
                 UseCase(SearchDepartmentsUseCase / SearchUsersUseCase)
                         │
                         ▼
             Repository(DepartmentRepository / UserRepository)
                         │
                         ▼
            RemoteDataSource(Dio + DTO + mapper)
```

### UI 컴포넌트
- **입력 영역**: 기본적으로 `TextFormField`(또는 공용 `AppTextField`) 위젯을 사용하며, 우측에 clear 버튼과 로딩 인디케이터를 배치한다. 입력 중에는 250ms 디바운스로 검색을 트리거하고, 결과수가 0개면 빈 상태 문구(아이콘 포함)를 표시한다.
- **팝오버 리스트**: 데스크톱/웹에서는 텍스트 필드 아래에 `Autocomplete` 유사 오버레이를 띄워 최대 6~8개 옵션을 보여주고, 화살표 키/Enter로 탐색 및 선택할 수 있게 한다. 리스트 항목은 주 라벨(예: 학과명) + 서브텍스트(예: 코드, 소속 건물)를 한 줄/두 줄 레이아웃으로 구성한다.
- **ModalBottomSheet 대응**: 모바일/좁은 화면에서는 필드를 탭하면 `showModalBottomSheet` 로 전체 검색 화면을 띄워 최근 검색어, 결과 리스트, 취소 버튼을 제공한다. 동일 컨트롤러 상태를 공유해 데스크톱/모바일 구현이 일관되도록 한다.
- **상태 관리**: 컴포넌트는 `query`, `debouncedQuery`, `isLoading`, `results`, `selectedItem`, `errorMessage`, `hasMore` 상태를 가진다. 선택이 완료되면 팝오버를 닫고 선택 라벨을 필드에 표시하며, clear 시에는 상태를 초기화해 재검색을 준비한다.
- **접근성**: 웹 빌드 기준으로 ARIA role(`combobox`, `listbox`, `option`)을 설정하고, 키보드 포커스 이동/스크린리더 announce가 가능하도록 `Semantics` 위젯을 함께 구성한다.

### Controller / Provider
- family provider로 엔티티 타입(학과/유저 등)과 검색 파라미터를 분기.
- `ref.keepAlive()`와 내부 debounce를 이용해 모달 내 focus 이동에도 상태 유지.
- `ref.onDispose`에서 pending 요청 취소(Dio cancel token).

### Repository
- 파라미터 객체 `EntitySearchQuery { String keyword; int limit; String? cursor; Map<String,String>? filters; }`.
- 응답 `EntitySearchResult<T> { List<T> items; String? nextCursor; bool hasMore; }`.
- 캐시 키: `type+keyword`. TTL 30초.

## 5. 단계별 구현 계획
1. **도메인 모델 정의**
   - `DepartmentSummaryEntity`, `UserSummaryEntity` 기존 정의 확인/보완.
   - 공통 `EntityOption` 뷰모델(아이콘, 라벨, 서브텍스트).
2. **데이터 레이어**
   - DTO/RemoteDataSource/Repository/UseCase 스켈레톤 생성.
   - Mock 구현 제공(백엔드 준비 전 UI 개발 가능).
3. **공통 검색 컴포넌트**
   - 위젯 + Controller + Provider 작성, Storybook/샘플 위젯으로 동작 검증.
4. **모달 적용**
   - 학과/담당자 입력 필드 교체 → 선택된 값 UI 반영.
   - `LectureOriginWriteInput` 생성 로직 수정(선택된 id 사용).
   - 선택값 초기화/수정 시 기존 recurrence 로직과 충돌 없도록 테스트.
5. **테스트**
   - Repository 단위 테스트: 캐시/에러/빈 결과.
   - Controller 테스트: 디바운스, 상태 전이, clear 동작.
   - Widget 테스트: 검색 시나리오, 선택/clear 이벤트.

## 6. 리스크 및 오픈 이슈
- **API 명세 추적**: `/Users/poeticdev/workspace_back/mdk-nest-server/docs/frontend_api.md` 가 최신 스펙이므로, 작업 전마다 해당 문서를 기준으로 파라미터/응답 필드를 재확인한다.
- **페이지네이션 정책**: 서버가 모든 목록 API에 `items + meta(page, limit, total, totalPages, hasPrev, hasNext)` 구조를 사용하므로(`frontend_api.md` 4장), UI도 페이지/limit를 파라미터로 전달하고 `meta` 기반으로 “더 보기/다음 페이지” UX 를 구성해야 한다.
- **유저 검색 권한**: `GET /users?q=` 는 권한 제한 없이 사용 가능하므로 별도 Role 체크 로직이 필요 없다.
- **공통 컴포넌트 확장성**: 향후 필터(건물, 캠퍼스, 역할 등)가 추가될 수 있으므로 검색 파라미터를 딕셔너리 형태로 받아 동적으로 직렬화하는 구조를 유지한다.

## 7. 완료 정의(DoD)
- 학과/유저 검색 Repository + UseCase 테스트 통과.
- 공통 검색 UI 위젯이 문서화되고, Storybook 혹은 샘플 화면에서 동작 확인.
- `classroom_timetable_modal.dart`에서 학과/담당자 선택 시 실제 검색 결과를 사용.
- UX 문서/디자이너와 결과 공유, 필수/옵션 필드 상태 반영.

## 8. Riverpod 상태/재시도 전략
- 참고 문서: `docs/reference_guides/riverpod_rules.md`
- 검색 상태는 `AsyncNotifierProvider.autoDispose.family` 기반 `EntitySearchController` 로 관리한다. 컨트롤러는 `build` 단계에서 최신 검색어를 감시하고 `state` 를 `AsyncValue<EntitySearchState>` 로 유지한다.
- 네트워크 오류 시 Riverpod 3.0 내장 재시도(지수 백오프)를 기본 사용하며, 필요 시 Provider 선언부에서 `retry` 파라미터로 제한을 줄 수 있다.
- UI는 `ref.watch(entitySearchControllerProvider(args))` 로 `AsyncValue` 를 구독하고, `when`/`maybeWhen` 패턴으로 로딩·성공·에러 뷰를 표시한다. 에러 상태에서는 `AsyncValue.refresh` 를 호출하는 “재시도” 버튼을 제공한다.
- `ref.keepAlive()` + `timer` 를 사용해 최근 검색 결과를 일정 시간 유지하고, 모달이 닫힐 때 `onDispose` 에서 Dio cancel token 을 통해 요청을 정리한다.
- 이 설계는 Riverpod 3.0 규칙(Notifier 기반 상태, 자동 재시도 활용, 커스텀 재시도 중복 금지)을 따른다.
