# Repository Guidelines

## Project Structure & Modules
- `lib/common/`: 공유 위젯, 테마, 유틸 모듈의 단일 진입점. 공용 로직은 extension/utility로 재사용.
- `lib/main.dart`: 앱 진입점. 라우트와 DI 부트를 여기서 연결.
- `test/`: 기능별로 `lib/` 구조를 미러링한 단위·위젯 테스트.
- `assets/env/`: 환경 설정 파일. 민감 정보는 샘플만 커밋.
- `web/`: 웹 셸 및 정적 자산. `build/`는 생성 산출물로 수정/커밋 금지.

## Build, Test, and Development
- `flutter pub get`: 의존성 동기화 및 잠금 파일 갱신.
- `flutter run -d chrome`: 웹 대시보드 로컬 실행(Hot Reload 지원).
- `flutter build web --release`: 배포용 웹 번들 생성.
- `flutter analyze`: `analysis_options.yaml` 기반 린트 검사.
- `dart run build_runner build --delete-conflicting-outputs`: Riverpod/코드 생성물 재생성.
- `flutter test` / `flutter test --coverage`: 단위·위젯 테스트 실행 및 커버리지 수집.

## Coding Style & Naming
- 언어: Dart 2.x, 들여쓰기 2칸. 모든 변수·파라미터·반환 타입 명시, `const` 생성자 우선.
- 파일: `snake_case.dart`; 클래스: PascalCase; 멤버/함수: camelCase; 불리언: 동사형(`isLoading`).
- 매직 넘버 사용 금지 → 의미 있는 `const`로 추출.
- 단일 export 원칙(파일당 하나의 `export`).
- 린트/포맷: `dart format .` 후 `flutter analyze` 체크.

## Testing Guidelines
- 패턴: AAA(Arrange-Act-Assert) 및 명확한 변수명(`inputX`, `mockX`, `expectedX`).
- 커버리지 목표: 핵심 모듈 80%+ (`flutter test --coverage`).
- 공개 컨트롤러·서비스·주요 위젯마다 대응 테스트 작성. Riverpod 상태는 헬퍼를 활용해 검증.

## Commit & PR Practices
- 커밋 프리픽스: `Feat: ...`, `Fix: ...` 등 단일 책임으로 작성.
- PR 템플릿: 변경 요약, 관련 이슈 링크, UI 변경 시 스크린샷/GIF, 실행한 명령 체크(`flutter analyze`, `flutter test`), 데이터 스키마 영향 여부 명시.

## Architecture & State
- 클린 아키텍처: 컨트롤러·서비스·리포지토리·엔티티 분리, 프레임워크 의존 최소화.
- DI: `getIt` 싱글톤(서비스/리포지토리) + 레이지 싱글톤(컨트롤러).
- 상태관리: Riverpod + Controller, UI는 컨트롤러가 노출하는 불변 상태만 구독.
- 라우팅: AutoRoute/`go_router` 테이블 단일 소스 관리, 페이지 간 데이터는 `extra` 사용.

## Security & Config
- 비밀 키/토큰은 `.env` 로컬 관리 후 `assets/env/`에 샘플만 커밋.
- 빌드 산출물(`build/`)과 로컬 캐시는 커밋하지 않는다.

## 커뮤니케이션 원칙
- 사용자 지원 시 한국어로 응답하며, 누락된 정보는 먼저 질의해 요구사항을 명확히 한다.