# 대시보드 UI 설계 요약

본 문서는 `docs/reference_media/samples/1.png`, `docs/reference_media/samples/2.png` 와이어프레임을 기준으로 전체 강의실 대시보드(전체 화면)와 개별 강의실 화면을 구현하기 위한 설계 및 진행 순서를 정리한다.

## 현재 구현 현황 (2025-12-30 기준)

- 공통 AppBar(CommonAppBar)와 페이지 메타 구조는 이미 구현되어 대시보드/상세 화면에서 재사용 가능하다.
- Classroom Detail 화면에는 연관 엔티티 검색 컴포넌트(EntitySearchField)·Riverpod Controller 구조가 적용되어 있으며, 대시보드 필터도 같은 패턴을 사용할 예정이다.
- Dashboard 메트릭/카드/필터 UI는 아직 본격 개발되지 않았으므로, 아래 설계 항목을 최신 컴포넌트 기준으로 업데이트해 차기 세션에서 착수한다.
- Responsive 정책과 테마(AppTheme/AppTypography)는 AGENTS.md 및 reference guide에 따라 코드에 반영되어 있으므로, 대시보드 구현 시 동일 정책을 따른다.

## 1. 전체 강의실 화면 (docs/reference_media/samples/1.png)

### 1.1 화면 구조

1. **헤더 바**
   - 공통 앱바 구현 완료(lib/common/app_bar)
   - 페이지 타이틀 : `관리 강의실 전체 보기`
2. **상단 메트릭 카드 영역**
   - 1. 현재 시각/날짜 표시(실시간) : 앱 공통 카드 위젯 활용
   - 2. 전체 강의실 수, 사용 중, 미사용, 미연동 카드 : 각각을 앱 공통 카드 위젯을 활용하여 재사용 가능한 `StatusMetricCard` 위젯으로 만든다. 클릭(터치) 시, 각 사용 상태에 해당하는 하단 강의실 카드 그리드에 표시
   - 3. 검색 필드(건물/호수/학과명).
   - 이 영역은 `ResponsiveGrid`로 구현하되 1, 2, 3 각 항목을 하나의 자식으로 가지게 한다. 
3. **강의실 카드 그리드**
   - 강의실별 정보 카드: 강의실명, 학과, 현재 강의명, 현재 강의자, 현재 강의 시작/종료시간, 상태 뱃지(사용 중/미사용).
   - 카드 상단 상태 뱃지: 좌측 2개(재실 상태-boolean, 장비 상태-boolean), 우측 1개(사용중/미사용-boolean, 미연동 = null)
   - 카드 내 액션 버튼(자세히 보기) → 개별 화면으로 라우트.
   - 그리드는 `SliverGrid` or `GridView`로 구현하고, 반응형 레이아웃(열 수) 조정 필요.

### 1.2 데이터 모델 및 상태

- `ClassroomSummary` 모델: `classroomId`, `classroomName`, `classroomCode`, `buildingName`, `buildingCode`, `departmentName`, `departmentId`, `status`, `courseName`, `professor`, `startAt`, `endAt`, `isOccupied`, `isOn`.
- 상단 메트릭은 `List<ClassroomSummary>` 기반 계산.
- 검색 및 필터 상태는 Riverpod `StateNotifier`로 관리.

### 1.3 컴포넌트 설계

- `DashboardHeader`: 날짜/시간 표시 + 메트릭 + 검색 필드를 포함하는 컴파운드 위젯. 검색 필드는 `EntitySearchField` 혹은 동일 인터페이스를 활용.
- `ClassroomCard`: 상태 뱃지, 아이콘, 버튼 등을 포함. 상태별 컬러는 `AppColors`로 매핑.
- `StatusBadge`: 사용 중/미사용/미연동 등 상태 텍스트를 색상으로 구분.

### 1.4 진행 순서

1. **Route/Navigation**: `/dashboard` → 전체 화면 라우트 구성.
2. **클래스 카드 데이터 모델 정의 + mock 데이터**.
3. **상단 메트릭 카드 위젯 → 검색 필드 UI 구현**.
4. **그리드 카드 구현**.
5. **반응형 조정 및 Theme 연결**.
6. **상태 관리/필터 로직 추가**.

## 2. 개별 강의실 화면 (docs/reference_media/samples/2.png)

### 2.1 화면 구조

1. **상단 바**
   - 뒤로 가기, 페이지 타이틀(`강의실 개별 정보`), 사용자 아이콘.
2. **강의실 요약 + 제어 패널**
   - 왼쪽: 강의실 이름/학과, 현재 수업 정보, 상태 뱃지.
   - 오른쪽: 전등/장비 ON/OFF 스위치, 환경 정보(온도/습도), 실시간 카메라 버튼.
   - 재실 상태 아이콘
3. **캘린더 영역**
   - 현행 구현(`ClassroomTimetableSection`)을 재사용해 주간/월간 토글, 날짜 네비게이션, 일정 블록을 제공한다.
   - `EntitySearchField` 기반 일정 등록 모달이 이미 마련되어 있으므로, 대시보드에서도 동일 모달을 호출한다.

### 2.2 데이터 및 상태

- `ClassroomDetail` 모델: 요약 정보 + 환경 정보 + 장비 상태.
- `ScheduleEvent` 모델.
- 스위치/실시간 센서 값은 컨트롤러가 API 호출로 갱신하는 구조(추후 연결).

### 2.3 컴포넌트 설계

- `RoomInfoCard`: 상태 뱃지, 수업 정보.
- `ControlToggle`: 전등/장비 스위치.
- `EnvironmentInfoCard`: 온도/습도 값.
- `ScheduleCalendar`: 주/월 전환 가능한 캘린더 위젯.
- `ScheduleFormSheet`: 일정 등록/수정 폼(모달).

### 2.4 진행 순서

1. **상세 라우트 구성:** `/dashboard/:roomId` 형태.
2. **Room info + control panel 레이아웃 제작**.
3. **환경 정보 카드 및 실시간 버튼 UI 구현**.
4. **캘린더 위젯 도입(주간 뷰 먼저) → 월간 토글**.
5. **일정 등록 패널 레이아웃**.
6. **상태 관리/데이터 바인딩 추가**.

## 3. 공통 고려 사항

- **Theme**: `AppTheme`와 상태 뱃지 색상을 재사용. 카드/배경에서 `surface`/`surfaceElevated` 활용.
- **타이포그래피**: `AppTypography`의 `headlineSmall`, `titleMedium`, `bodyMedium` 등 사용.
- **Iconography**: Material Icons 기본, 필요 시 Custom Icon set 고려.
- **Responsive Layout**: 아래 3.1 ResponsiveFramework & Helper 사용 가이드 참조
- **상태관리**: Riverpod Controller(`dashboardController`, `classroomDetailController`) 설계 → API 연동 전 Mock 데이터로 UI 완성.
- **테스트 전략**:

  - 레이아웃/상태 위젯 테스트 (Widget tests).
  - Controller 단위 테스트 (데이터 필터/메트릭 계산).
  - Golden test로 카드/캘린더 모양 검증 검토.

  ### 3.1 ResponsiveFramework & Helper 사용 가이드
1. **전역 Breakpoint:** `lib/main.dart`에서 `ResponsiveBreakpoints.builder`를 통해 `MOBILE(0-599) / TABLET(600-1023) / DESKTOP(1024-1439) / 4K(1440+)`를 유지한다. 새로운 진입점이나 `MaterialApp` 구성을 변경할 때도 동일한 builder를 감싸야 한다.
2. **공통 헬퍼:** `lib/common/responsive/responsive_layout.dart`에 정의된 `ResponsiveLayoutBuilder`, `context.deviceFormFactor`, `context.responsivePagePadding()`, `context.responsiveColumns()` 등을 사용해 각 화면의 레이아웃/여백/열 수를 결정한다. 직접 `MediaQuery` 값을 계산하거나 매직 넘버를 쓰지 않는다.
3. **페이지 패딩:** 모든 주요 페이지는 `context.responsivePagePadding()`을 활용해 기본 여백 정책을 공유한다. 추가 여백이 필요하면 helper의 named parameter를 이용해 override하고, override한 이유를 주석으로 남긴다.
4. **위젯 레이아웃:** `LayoutBuilder`가 필요한 상황에서도 우선 `ResponsiveLayoutBuilder`로 formFactor를 받아 사용하고, 반복되는 반응형 패턴은 공통 responsive 위젯(예: `ResponsiveRowColumn`, 그리드 helper)으로 추상화한다.
5. **테스트:** 위젯 테스트에서 breakpoint 별 상태를 검증하려면 `ResponsiveBreakpoints.builder`로 테스트 위젯을 감싼 뒤 원하는 스크린 크기를 주입한다. formFactor 의존 로직이 있으면 각 케이스를 명시적으로 검증한다.
6. **문서 참조:** 새로운 화면을 구현할 때 본 섹션과 `docs/architecture/dashboard_design.md`의 responsive 요구사항을 함께 확인해 디자인-구현 불일치를 방지한다.

## 4. 향후 TODO

- API 계약 및 데이터 모델 문서화(frontend_api.md 확장).
- 실시간 센서/카메라 버튼 동작 정의.
- 접근성(스크린 리더, 키보드 네비게이션) 가이드 포함.
- 다국어 지원 시 `AppLocalizations` 반영.
