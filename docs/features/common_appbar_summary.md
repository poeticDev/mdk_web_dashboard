# 공통 AppBar 구현 요약

## 1. 개요
- **요구 배경**: 페이지별 중복 AppBar 코드를 제거하고, 로고/제목/테마 토글/사용자 배너를 일관된 레이아웃으로 제공.
- **참조 설계**: `docs/collaboration/plans/classroom_detail_header_plan.md` (AppBar 섹션), `docs/collaboration/checklists/common_appbar_checklist.md`
- **적용 범위**: Dashboard, Classroom Detail 등 Router 기반 페이지 상단.

## 2. 구현 산출물
| 영역 | 경로 | 설명 |
| --- | --- | --- |
| 옵션/메타 데이터 | `lib/common/app_bar/common_app_bar_options.dart`, `lib/routes/page_meta.dart` | 페이지 메타/옵션 구조 정의, title/아이콘 매핑 |
| 공통 위젯 | `lib/common/app_bar/common_app_bar.dart` | `PreferredSizeWidget` 형태의 `CommonAppBar` 및 내부 구성(로고, 타이틀, 테마 토글, 사용자 배너, 뒤로가기 버튼) |
| 사용자 배너 | `lib/common/app_bar/common_app_bar.dart` 내 `_UserBanner` | PopupMenu 포함, 향후 로그아웃/프로필 메뉴 TODO 남김 |
| 적용 예시 | `lib/ui/dashboard/dashboard_page.dart`, `lib/ui/classroom_detail/classroom_detail_page.dart` | 옵션 기반 AppBar 적용 및 override 샘플 |

## 3. 완료 상태
- 체크리스트 상 모든 구현 항목 완료(설계, 위젯, 스타일, 적용, 테스트).
- `flutter analyze` / `flutter test` 완료 시점: 2025-12-11.

## 4. 남은 개선/주의 사항
- **Header alert/status bar**: Classroom Detail Header 리팩터링 체크리스트의 남은 항목으로, CommonAppBar 영역 확장 시 추가 고려 필요.
- **사용자 메뉴 기능화**: `_UserBanner` PopupMenu에 실제 로그아웃/설정 이동 기능 연결.
- **Storybook/문서**: 디자인 팀 공유용 스크린샷/Storybook 컴포넌트가 있으면 `docs/features/`에 추가.

## 5. 재사용 가이드
1. 페이지별 Metadata를 `AppPageMeta`에 추가해 기본 제목/옵션을 정의한다.
2. 개별 화면에서 `Scaffold(appBar: CommonAppBar(options: ...))` 형태로 주입하고, 필요 시 `CommonAppBarOptions` 로 `showBackButton`, `titleOverride` 등을 설정한다.
3. 사용자 배너/테마 토글이 필요 없는 화면에서는 옵션으로 비활성화할 수 있다.

## 6. 참고 문서
- 설계/체크리스트: `docs/collaboration/checklists/common_appbar_checklist.md`
- 디자인 노트: `docs/collaboration/design_notes` (AppBar 관련 항목)
