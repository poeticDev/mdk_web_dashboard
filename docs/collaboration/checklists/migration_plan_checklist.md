# Web Dashboard Migration Plan Checklist

> 목적: `web_dashboard` 앱을 `mdk_app_theme` 패키지 기반으로 전환하면서, 단계별로 의존성/코드/문서/검증을 수행한다. 각 단계 완료 시 체크하고 근거를 기록한다.

## 1. 의존성 연결
- [ ] `web_dashboard` 브랜치(`feat/theme-package`) 생성 확인.
- [x] `pubspec.yaml`에 `mdk_app_theme`를 git dependency로 추가하고 `flutter pub get` 실행. (2025-12-11 적용 완료)
- [x] 기존 Pretendard/Paperlogy 폰트 자산 제거: `assets/font/` 디렉터리 및 `flutter.fonts` 항목 삭제로 패키지 폰트만 사용. (2025-12-11)

## 2. 부트스트랩 준비
- [x] `main.dart`에서 `ThemeRegistry.instance.ensureDefaults()` 호출 및 기본 adapter/controller 사용 결정(현재 기본 구현 유지). (lib/main.dart)
- [x] `ProviderScope` 구성을 점검하고 추가 override 없이도 Riverpod DI와 호환되는지 확인 완료.
- [x] AdaptiveTheme 초기화 코드를 예제 스타일로 업데이트하여 `initialThemeMode`를 주입. (lib/main.dart)

## 3. 컨트롤러 & 상태 교체
- [x] 기존 ThemeController 구현 삭제 후 `lib/common/theme/theme_controller_provider.dart`에서 패키지 ThemeController를 Provider로 노출.
- [x] UI에서 ThemeToggle 소비 방식을 `AppThemeToggle`로 재구성하여 패키지 Provider 사용. (lib/features/dashboard/presentation/pages/dashboard_page.dart, lib/features/classroom_detail/presentation/**)
- [ ] `ThemeControllerState`/Notifier 기반 상태 검증은 추후 필요 시 도입.

## 4. 위젯 & 토큰 교체
- [x] `AppTheme`, `ThemeToggle` import를 패키지 경로로 통일. (lib/main.dart, 공통 위젯)
- [x] 기존 색상/폰트/위젯 파일 삭제(`lib/theme/**`).
- [ ] 브랜드 선택 UI에 ThemeBrand 확장 적용 여부 검토(현재는 기본 브랜드만 사용 중).

## 5. 테스트 및 검증
- [x] `flutter test` 통과 확인, AdaptiveTheme 관련 위젯 테스트에서 SharedPreferences mock 추가. (test/widget_test.dart)
- [ ] UI smoke test(실기기) 진행 필요.
- [ ] CI 스크립트 업데이트 미완.

## 6. 문서 & 체크리스트 업데이트
- [ ] `web_dashboard/docs/theme_package_checklist.md`와 이 문서를 동기화(완료 항목/근거 기록).
- [ ] README/CHANGELOG에 패키지 전환 내용을 추가하고, Breaking change 여부를 명시.
- [ ] 최종 smoke test 결과와 잔여 개선 포인트를 `mdk_app_theme/docs/improvement_checklist.md`에 피드백.
