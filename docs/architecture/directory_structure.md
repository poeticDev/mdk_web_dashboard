# Directory Structure Overview

이 문서는 `web_dashboard` 저장소의 현재 디렉터리 구성을 요약하고, 설계 의도와 향후 개선 방안을 정리한 것이다.

## 1. 상위 레이아웃 요약

```
web_dashboard/
├── lib/
│   ├── common/
│   ├── core/
│   ├── di/
│   ├── routes/
│   ├── theme/
│   └── ui/
├── assets/
├── docs/
├── test/
├── web/
└── 기타 설정 파일(pubspec.yaml 등)
```

## 2. 폴더별 의도와 패턴

### lib/common
- **의도:** 전역 재사용 리소스 집합.
- **constants/**: API 경로 등 공용 상수.
- **network/**: HTTP 클라이언트 및 플랫폼별 어댑터. `dio`와 adapter factory를 플랫폼별 파일(io/web)로 분리해 의존성 역전 유지.

### lib/core
- **패턴:** 정통 Clean Architecture. `auth` 피처가 `application / data / domain` 3계층으로 구성돼 서비스·리포지토리·엔티티를 구분한다.
- **확장성:** 다른 도메인도 동일 계층 구조를 복제할 수 있도록 샘플 역할.

### lib/di
- **service_locator.dart**: `getIt` 등록 지점. 서비스·리포지토리 싱글톤과 컨트롤러 레이지 싱글톤을 분리 등록하도록 설계돼 있음.

### lib/routes
- `route_paths.dart`로 경로 상수 정의 → `app_router.dart`에서 `GoRouter` 설정. 라우팅 정의가 단일 소스에 모여 있어 Screen/Feature 모듈에서 라우팅 의존성을 최소화한다.

### lib/theme
- **tokens/**: `AppColors`, `AppTypography` 등 디자인 토큰.
- **app_theme.dart**: ThemeData를 조합하는 팩토리. 새 ColorScheme, 버튼/입력 등 서브테마를 일괄 정의.
- **theme_controller.dart / widgets/theme_toggle.dart**: AdaptiveTheme + Riverpod 기반 테마 토글 제어.

### lib/ui
- 피처 기준 폴더(`login`, `dashboard`). 각 폴더는 해당 화면 구성 요소만 포함하며, 비즈니스 로직은 `core` 계층과 컨트롤러가 담당.

### test
- `lib/` 구조를 미러링한 위치에 상태/컨트롤러 테스트가 배치된다. (현재 `core/auth/application` 대응 테스트가 존재)

### docs
- 설계 문서(테마, 로그인, Flutter 규칙 등). 이번 문서(`directory_structure.md`) 역시 `docs/`에 포함해 작업자가 참조 가능.

### 기타 디렉터리
- **assets/**: 정적 리소스(환경 변수 템플릿, 테스트 리소스 등).
- **web/**: Flutter web 빌드 관련 정적 자산.

## 3. 관찰된 설계 패턴
1. **Clean Architecture 레이어링:** `core/{domain,data,application}`과 `di`가 명확히 구분돼 있어 의존성 방향이 안쪽 → 바깥으로 흐른다.
2. **플랫폼 분기 처리:** `common/network` 및 `AppTypography`에서 `kIsWeb` 기반 분기를 사용해 웹·모바일을 동시에 지원한다.
3. **테마 시스템 모듈화:** `theme/`가 토큰화 + ThemeData 생성 + AdaptiveTheme 컨트롤까지 담당, UI 코드에서는 ThemeData만 소비하도록 설계되어 있다.
4. **문서 우선 접근:** `docs/`에 기능/테마 설계 문서가 존재하며, `AGENTS.md`에서도 핵심 문서를 링크해 작업 지침을 명시한다.

## 4. 개선 제안
1. **Feature-first UI 구조 고도화:** 현재 `ui/`에 `login`, `dashboard`만 존재한다. 향후 기능이 늘어나면 `ui/<feature>/widgets`, `ui/<feature>/controllers` 식으로 세분화하거나, 전체를 `features/<feature>/{presentation,application,...}` 구조로 일원화하면 스케일링이 쉬워진다.
2. **공용 위젯/스타일 허브 추가:** `lib/common`에 `widgets/`, `styles/` 등을 도입해 버튼·폼 등 재사용 위젯을 모으면, Theme 설정과 UI 코드 간 중복 스타일을 줄일 수 있다.
3. **테스트 커버리지 확대:** `test/`가 현재 auth 컨트롤러에 집중돼 있으므로, theme controller, routes, network layer 등에 대한 단위/통합 테스트 템플릿을 추가하면 문서에서 요구하는 80% 커버리지에 근접하기 쉽다.
4. **도메인 모듈 템플릿 문서화:** `core/auth` 구조를 표준으로 삼아 README 또는 docs에 “새 도메인 추가 가이드”를 추가하면 onboarding 속도를 높일 수 있다.

필요 시 본 문서를 최신 구조와 함께 갱신해 작업자 간 컨텍스트를 공유하도록 한다.
