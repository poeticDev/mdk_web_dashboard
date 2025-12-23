# DI 경계 가이드 (GetIt + Riverpod)

## 목적
- 현재 프로젝트는 GetIt과 Riverpod을 병행 사용 중이므로, 의존성 출처가 혼재되지 않도록 역할을 명확히 분리한다.
- 테스트/유지보수 전략을 단순화해 팀 내 합의된 규칙을 문서화한다.

## 역할 분리
- **GetIt (lib/di/service_locator.dart)**
  - 공통 infra 초기화 및 싱글턴 보관.
  - 예) Dio, HttpClient, Storage, Logger, RemoteDataSource, Mapper 등.
- **Riverpod Provider**
  - 앱/도메인 레이어에서 필요한 의존성(Repository, UseCase, Controller/State)을 조립해 제공한다.
  - Provider 내부에서만 `di<T>()` 접근을 허용하고, 실제 기능 레이어(UseCase, Controller)는 반드시 Provider를 통해 주입받는다.

## Repository 생성 규칙
- Repository는 Riverpod Provider에서 생성한다.
- RemoteDataSource/Mapper는 GetIt에서 주입받아 Provider에서 조립한다.
- 동일 Repository를 GetIt에도 등록하고 Provider에서도 새로 생성하는 이중 등록은 금지한다.

## Provider 작성 규칙
- `timetable_providers.dart`와 같은 composition 파일에서만 `di<T>()` 호출을 허용한다.
- Controller/UseCase 내부에서는 `ref.watch(repoProvider)` 등 Provider 의존성만 사용한다.

## 테스트 전략
- 기본적으로 Provider override를 사용해 Mock/Stub을 주입한다.
- GetIt reset/re-register를 테스트에서 병행하지 않는다.
- 필요 시 infra 레벨(Dio 등)을 override하려면, 해당 Provider를 전역 override하는 방식으로 일관되게 처리한다.

## 권장 적용 순서
1. **규칙 준수**: 기존 코드에 즉시 영향을 주지 않고도, 새/수정 코드가 위 규칙을 따르도록 코드리뷰 기준을 마련한다.
2. **Repository 이동**: 점진적으로 Repository 생성 위치를 Riverpod Provider로 옮기고, GetIt에는 infra만 남긴다.

## 참고
- 기존 기능은 즉시 리팩토링하지 않아도 된다. 다만 새로운 코드부터는 본 가이드를 준수하고, 리스크가 낮은 부분부터 순차적으로 정리한다.
