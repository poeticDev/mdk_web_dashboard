# Common AppBar Implementation Checklist

## 1. 설계 정리
- [x] docs/appbar_design.md 요구사항 요약 및 옵션(표시 요소 등) 결정.
  - 표시 요소: 뒤로가기 버튼, 페이지 제목, 테마 토글(AppThemeToggle), 사용자 배너(이름/역할/아바타) 고정.
  - 옵션: `showBackButton`, `showThemeToggle`, `showUserBanner`, `titleOverride` 등으로 확장성 확보 예정.
  - 로고는 `assets/img/logo.png`, 높이 약 64~72, 좌측 로고+제목, 우측 토글+배너 레이아웃.

## 2. 인프라 준비
- [x] 페이지 메타/제목 매핑 구조 정의(`lib/routes/page_meta.dart`에 `AppPageMeta` + helper 추가).
- [x] AppBar 옵션 데이터 클래스(`lib/common/app_bar/common_app_bar_options.dart`) 설계 완료.

## 3. 위젯 구현
- [x] `CommonAppBar` (`PreferredSizeWidget`) 작성(`lib/common/app_bar/common_app_bar.dart`).
- [x] 내부 컴포넌트 `_LogoSection`, `_PageTitle`, `_ThemeToggleButton`, `_UserBanner`, `_BackButton` 구현.
- [x] 사용자 배너 클릭 시 PopupMenuButton으로 기본 메뉴 구조 추가(로그아웃 TODO).

## 4. 스타일 & 토큰 적용
- [x] mdk_app_theme ThemeData/ColorScheme 기반으로 배경·divider 등 적용.
- [x] 타이틀 ellipsis 지정, AppBar 높이 72 고정.

## 5. 적용 예시
- [x] DashboardPage / ClassroomDetailPage에 CommonAppBar 적용, title override 및 옵션 사용 예시 추가.

## 6. 검증 & 문서
- [x] `flutter analyze` / `flutter test` 실행 (2025-12-11, 명령 완료).
- [x] docs/appbar_design.md에 구현 요약/사용 예시 추가.
