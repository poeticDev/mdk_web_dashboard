/goal
현재 관제 웹앱(Flutter Web)에서 사용할 "공통 상단 AppBar"를 설계하고 구현해줘.
이 AppBar는 대시보드 이후 주요 페이지 상단에 고정으로 노출되고,
다음 요소를 포함해야 한다.

1) 뒤로가기 버튼
2) 현재 페이지 제목 표시
3) 라이트/다크 테마 토글 버튼
4) 사용자 정보 배너(사용자 이름 + 역할 + 프로필/이니셜 아이콘)

/context
- 현재 페이지 제목은 라우트 기준으로 결정한다.
  - 각 라우트에 대응되는 enum 또는 meta 객체가 있고, 여기서 title을 가져오도록 설계해줘.
- 테마는 mdk_app_theme 패키지를 사용하며, 전역 ThemeController(or Riverpod Provider)를 통해 ThemeMode(light/dark)를 관리한다.
  - AppBar에서는 단지 "토글 이벤트"만 발생시키고, 실제 themeMode 변경은 기존 컨트롤러/프로바이더 로직을 재사용했으면 한다.
- 사용자 정보는 auth 관련 상태에서 가져온다. 다만 현재는 더미 데이터로 구현하고 실제 구현은 추후에 한다.
- 이 AppBar는 web 기준 상단 고정 UI이기 때문에,
  - 높이는 적당한 고정값(예: 64~72)으로 하고
  - 좌측에는 로고 + 현재 페이지 제목,
    - 로고는 assets/img/logo.png 활용
  - 우측에는 테마 토글 버튼 + 사용자 배너가 나열되도록 레이아웃을 구성해줘.
- 가능한 한 mdk_app_theme의 색상/타이포그래피/spacing 토큰을 활용하고, 하드코딩된 색상 값은 최대한 피한다.

/requirements
1. 위젯 구조
   - 공통으로 사용할 AppBar 위젯을 하나 정의해줘.
     - 예: `class CommonAppBar extends StatelessWidget implements PreferredSizeWidget`
   - 내부는 소규모 컴포넌트로 분리해서 설계해줘. 테마 토글의 경우 기존 위젯을 만들어 둔 게 있으니 활용해.
     - 예: `_BackButton`, `_PageTitle`, `_ThemeToggleButton`, `_UserBanner`
   - 나중에 확장이 쉽도록, 각 부분은 별도 위젯/메서드로 분리해.

2. 현재 페이지 제목
   - 현재 라우트 정보를 읽어서 title을 가져오는 헬퍼를 설계해줘.
     - 예: `PageMeta.of(context)` 또는 route name -> title 매핑 함수 등.
   - title이 너무 길어질 경우, web 상단에서 레이아웃이 깨지지 않도록
     - overflow 처리(ellipsis)까지 포함해줘.

3. 사용자 배너
   - 사용자 이름, 역할, 이니셜/아바타를 우측에 표시하는 작은 카드/버튼 형태로 만들어줘.
   - 배너를 클릭했을 때 펼쳐지는 메뉴(예: 내 정보, 로그아웃)를 위한 기본 구조도 설계만 해줘.
     - 실제 라우팅/로그아웃 로직은 TODO로 남기고, 어디서 구현해야 할지 주석으로 안내해줘.

4. 스타일링
   - mdk_app_theme의 AppTheme/AppColors/AppTextStyles/Spacing 등 토큰을 적극적으로 사용하고,
   - 하드코딩된 색/폰트 값은 최대한 배제해줘.
   - 웹 환경에서 상단바가 콘텐츠 위를 덮지 않도록, Scaffold/레이아웃 구조까지 함께 제안해줘..

5. 확장성
   - 나중에 "관리자 전용 AppBar", "심플 버전 AppBar"를 만들 수 있도록,
     - CommonAppBar가 몇 가지 옵션을 받을 수 있게 설계해줘.
     - 예: `showBackButton`, `showThemeToggle`, `showUserBanner`, `titleOverride` 등.

/deliverables
- AppBar 관련 전체 코드 (위젯, 필요한 helper 함수/클래스 포함)
- 적용 예시:
  - 기존 레이아웃(예: DefaultLayout/RootScaffold)에 이 CommonAppBar를 붙이는 샘플 코드
- 선택사항이 있는 부분(예: 뒤로가기 버튼 숨김 vs 비활성)은, 추천안을 하나 고르고 그 이유를 짧게 설명해줘.

/implementation_summary (2025-12-11)
- `lib/common/app_bar/common_app_bar.dart`에 `CommonAppBar`를 구현했다. PreferredSizeWidget이며 내부에 `_LogoSection`, `_PageTitle`, `_ThemeToggleButton`, `_UserBanner`, `_BackButton`로 분리해두었다. 모바일 레이아웃에서는 `_UserBanner`가 CircleAvatar 아이콘만 노출되도록 compact 모드를 적용했다.
- 라우트 기반 제목/표시 옵션은 `lib/routes/page_meta.dart`의 `AppPageMeta` enum으로 관리한다. 각 meta에 `showBackButton/showThemeToggle/showUserBanner/title` 정보가 들어 있고 `resolvePageMeta` 헬퍼로 현재 페이지 정보를 얻는다.
- 커스터마이징을 위해 `lib/common/app_bar/common_app_bar_options.dart`에 `CommonAppBarOptions`를 정의해 요소 표시 여부나 `titleOverride`, 추가 trailing 위젯을 주입할 수 있다.
- 테마 토글은 기존 `AppThemeToggle`(mdk_app_theme 기반)을 재사용한다. 색상/타이포/spacing은 ThemeData(ColorScheme) 값과 공통 상수(높이 72, 좌우 패딩 24, 액션 간격 16)를 사용해 하드코딩을 최소화했다.
- 사용자 배너는 `AuthController` 상태를 읽어 이름/역할/이니셜을 표시하고, PopupMenuButton을 통해 "내 정보", "로그아웃" 메뉴 골격을 제공한다. 실제 라우팅/로그아웃은 TODO로 남겨 두었다.
- 적용 예시는 `lib/ui/dashboard/dashboard_page.dart`와 `lib/ui/classroom_detail/classroom_detail_page.dart`에 반영했다. Scaffold에서 `appBar: const CommonAppBar(meta: AppPageMeta.dashboard)`처럼 사용하거나, detail 화면에서는 `CommonAppBar(meta: AppPageMeta.classroomDetail, options: CommonAppBarOptions(titleOverride: ...))` 형식으로 제목 커스터마이징을 할 수 있다.
- 추천안: 뒤로가기 버튼은 각 meta 설정에 따라 자동 제어하며, 숨김 대신 아예 버튼을 제거하는 방식을 사용했다. 이유는 빈 `IconButton`을 비활성화시키는 것보다 사용자 경험이 명확하기 때문.
