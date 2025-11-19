# Repository Guidelines v1.0

## 프로젝트 구조 및 모듈 구성
- 공용 위젯·테마·유틸은 `lib/common/`에 두고, 진입점은 `lib/main.dart`에 유지한다.
- 테스트는 `test/`에 기능 단위로 미러링하고, 환경 설정은 `assets/env/`, 웹 셸은 `web/`에 둔다.
- `build/`는 생성 산출물 폴더로 버전 관리에서 제외하며 직접 수정하지 않는다.

## 빌드·테스트·개발 명령어
- `flutter pub get` — 의존성 및 잠금 파일 동기화.
- `flutter run -d chrome` — 웹 대시보드 로컬 실행(Hot Reload 지원).
- `flutter build web --release` — 배포용 웹 번들 생성.
- `flutter analyze` — `analysis_options.yaml` 기반 린트 검사.
- `dart run build_runner build --delete-conflicting-outputs` — Riverpod/코드 생성 산출물 재생성.
- `flutter test` / `flutter test --coverage` — 단위·위젯 테스트 실행 및 커버리지 수집.

## 코딩 스타일 및 네이밍 규칙
- Dart 기본 스타일과 2칸 들여쓰기, 모든 변수·파라미터·반환 타입 명시를 준수한다.
- 파일은 `snake_case.dart`, 클래스는 PascalCase, 멤버·함수는 camelCase로 작성하고 불리언은 동사형(`isLoading`)을 사용한다.
- 매직 넘버는 상수로 치환하고, 불변 위젯에는 `const` 생성자를 우선 적용한다.
- `dart format .`과 `flutter analyze` 후 변경 사항을 커밋하며, 린트 규칙 변경은 팀 합의 후 진행한다.

## 테스트 지침
- 각 공개 컨트롤러·서비스·주요 위젯에 대응하는 `*_test.dart`를 작성한다.
- 테스트는 Arrange-Act-Assert 패턴과 명확한 변수명(`inputX`, `mockX` 등)을 사용한다.
- Riverpod 상태 검증에는 `flutter_test`와 Riverpod 테스트 도우미를 활용한다.
- PR 전 `flutter test --coverage`로 커버리지 확인(핵심 모듈 80% 이상 목표).

## 커밋 및 PR 가이드
- `Feat:`, `Fix:` 중심의 접두사를 사용하여 동일한 스타일을 유지한다(예: `Fix: media 초기화 순서 조정`).
- 커밋은 단일 책임에 집중하고, 필요 시 설명을 본문에 덧붙여 맥락을 명확히 한다.
- PR 템플릿: 변경 요약, 관련 이슈 링크, UI 변경 시 스크린샷/GIF, 실행한 명령 체크(`flutter analyze`, `flutter test`), 데이터 스키마 영향 여부를 포함한다.

## 아키텍처 원칙
- Riverpod 컨트롤러와 `get_it`을 통해 의존성을 주입한다.
- UI는 컨트롤러가 노출하는 불변 상태만 구독하고, 네비게이션은 `go_router` 경로 테이블을 단일 소스에서 관리하며 `extra`를 통해 파라미터를 전달한다.
- 공용 로직은 extension과 공용 유틸 모듈로 재사용성을 확보하고, 엔티티·리포지토리는 프레임워크 의존성을 최소화한다.

## 커뮤니케이션 원칙
- 사용자 지원 시 한국어로 응답하며, 누락된 정보는 먼저 질의해 요구사항을 명확히 한다.


## MCP 설치 지침
- 작업 전 현재 OS와 쉘/WSL 여부를 확인하고, 모를 경우 사용자에게 반드시 질문한다.
- MCP 설치는 공식 문서를 확인한 뒤 환경에 맞는 절차만 따른다.
- 설치 후 `($env:RUST_LOG="codex=debug"; codex "/mcp")`로 로그를 확인해 정상 동작을 검증한다.
- API 키가 필요한 경우 예시 키로 기본 설정 후 실제 키 입력이 필요함을 사용자에게 안내한다.
- 설치에 사용한 명령·환경 변수는 `~/.codex/config.toml`의 `[mcp_servers.*]` 섹션에 기록한다.

```toml
# ~/.codex/config.toml
[mcp_servers.brightData]
command = "npx"
args = ["-y", "@brightdata/mcp"]
env = { API_TOKEN = "bd_your_api_key_here" }

[mcp_servers.playwright]
command = "npx"
args = ["@playwright/mcp@latest"]
```