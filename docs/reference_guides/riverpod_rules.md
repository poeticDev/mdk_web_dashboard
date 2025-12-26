# Riverpod 3.0 참고용 코딩 규칙

> 이 문서는 **Riverpod 3.0 기준으로 코드 생성/리팩토링**할 때 따라야 할 규칙을 정리한 것이다.
> 특별히 지시하지 않는 한, 항상 **최신 Riverpod 3.x**를 가정하고 코드를 작성하라. ([riverpod.dev][1])

### 🔎 Riverpod 3.0 퀵 체크리스트

1. **새 상태 로직 = `Notifier` / `AsyncNotifier` / `StreamNotifier` + 대응 Provider.**
2. **`AutoDispose` / `Family`는 Provider 선언 단계에서 `.autoDispose` / `.family` 체이닝으로 처리**하고, Notifier 클래스는 기본 클래스를 상속한다.
3. **Typed Ref (`XxxRef`)는 사용하지 말고 `Ref` 하나로 통일.**
4. **기존 `StateNotifierProvider`/`ChangeNotifierProvider`는 유지 가능하지만, 신규 비즈니스 로직에는 쓰지 않는다.**
5. **비동기 에러/재시도는 Riverpod 내장 동작을 활용하고, 수동 재시도 로직을 중복 작성하지 않는다.**
6. **테스트 시 `ProviderContainer` + override/observer 헬퍼를 적극 사용**하고, `listen`을 통해 비동기 상태를 기다린다.

---

## 0. 전역 원칙

1. **기본 전제**

   * Riverpod 버전 **3.0 이상**인 경우 본 규칙을 따른다.
   * 가능한 한 **새 API(Notifer / AsyncNotifier / StreamNotifier)** 를 사용하고,
     `StateNotifierProvider`, `ChangeNotifierProvider` 등은 **새 코드에서 직접 쓰지 않는다.** ([riverpod.dev][2])

2. **레거시 API 사용 기준**

   * 프로젝트에 이미 `StateNotifierProvider`/`ChangeNotifierProvider` 기반 코드가 많고,
     그리고 `import 'package:flutter_riverpod/legacy.dart';` 를 쓰고 있다면,
     **기존 스타일을 유지한 채로 필요한 최소 수정만 한다.** ([riverpod.dev][2])
   * 새로 만드는 비즈니스 로직용 상태는 **`Notifier` / `AsyncNotifier` / `StreamNotifier` + 대응 Provider** 를 기본으로 선택한다.

3. **코드 생성 vs 수동 구현**

   * 리포지토리에 `riverpod_annotation`, `riverpod_generator`, `build_runner` 가 이미 세팅되어 있으면:

     * 새 코드에서는 **annotation 기반 (`@riverpod`)을 우선 고려**한다. ([riverpod.dev][1])
   * 그렇지 않다면:

     * **수동으로 `Notifier`/`AsyncNotifier` 클래스를 만들고 `NotifierProvider`/`AsyncNotifierProvider` 를 선언**한다.

4. **문서 참조**

   * Riverpod 3.0 관련 기본 레퍼런스:

     * 공식 “What’s new in Riverpod 3.0” ([riverpod.dev][1])
     * 공식 “Migrating from 2.0 to 3.0” ([riverpod.dev][2])

---

## 1. Provider 타입 선택 가이드

### 1-1. 단순 값/설정

* **`Provider<T>`**

  * 계산 비용이 낮고, 비동기/변경이 거의 없는 값.
  * 예: 색상 팔레트, 상수 설정, 간단한 파생 값.

* **`StateProvider<T>`**

  * 매우 단순한 “로컬 상태” 수준 (예: 선택된 탭 인덱스, 필터 값).
  * Riverpod 3에서 `StateProvider` 는 **레거시로 분류되지만** 여전히 사용 가능하며,
    이미 프로젝트에서 많이 쓰고 있으면 계속 사용해도 된다. 단, 새 비즈니스 로직은 가능하면 `Notifier` 계열로. ([riverpod.dev][2])

### 1-2. 비즈니스 로직/도메인 상태

* **동기 상태 머신 / 비즈니스 로직**

  * `class XxxNotifier extends Notifier<State>`
  * `final xxxNotifierProvider = NotifierProvider<XxxNotifier, State>(XxxNotifier.new);`
* **비동기 비즈니스 로직 (HTTP, DB, IoT 등)**

  * `class XxxNotifier extends AsyncNotifier<State>`
  * `final xxxNotifierProvider = AsyncNotifierProvider<XxxNotifier, State>(XxxNotifier.new);`

> 규칙:
>
> * **중요한 비즈니스 로직 / 복잡한 상태**는 웬만하면 전부 `Notifier` / `AsyncNotifier` / `StreamNotifier` 기반으로 구현한다. ([Medium][3])

### 1-3. AutoDispose / Family

* **AutoDispose**

  * 더 이상 `AutoDisposeNotifier` 같은 타입은 **사용하지 않는다.**
  * 대신 Provider 선언에서 `.autoDispose` 를 사용하고, 클래스는 그냥 `Notifier`/`AsyncNotifier` 를 상속. ([riverpod.dev][4])

  ```dart
  // 올바른 3.0 스타일
  final counterProvider = NotifierProvider.autoDispose<CounterNotifier, int>(
    CounterNotifier.new,
  );

  class CounterNotifier extends Notifier<int> {
    @override
    int build() => 0;

    void increment() => state++;
  }
  ```

* **Family**

  * `FamilyNotifier` / `FamilyAsyncNotifier` 등은 삭제되었다.
    대신:

    1. `Notifier`/`AsyncNotifier` 에 **생성자 인자**로 값을 받는다.
    2. Provider는 `NotifierProvider.family` / `AsyncNotifierProvider.family` 를 사용한다. ([riverpod.dev][2])

  ```dart
  final userDetailProvider =
      AsyncNotifierProvider.family<UserDetailNotifier, User, int>(
    UserDetailNotifier.new,
  );

  class UserDetailNotifier extends AsyncNotifier<User> {
    // family 인자를 생성자로 받는다.
    UserDetailNotifier(this.userId);

    final int userId;

    @override
    Future<User> build() async {
      // userId 사용
    }
  }
  ```

---

## 2. Ref / Notifier / AsyncValue 관련 변경점 반영 규칙

### 2-1. Ref 타입 단순화

* 3.0에서는 `Ref` 의 **제네릭이 제거**되었고,
  `ProviderRef`, `FutureProviderRef` 등 서브클래스도 제거되었다. ([riverpod.dev][2])

* 코드 생성 시:

  * 이전: `Future<int> value(ValueRef ref)`
  * 이제: `Future<int> value(Ref ref)` 또는 `@riverpod class Value extends _$Value`

* 규칙:

  * **새 코드에서는 `Ref` 한 종류만 사용**하고, `XxxRef` 타입을 새로 만들지 않는다.
  * 예전 스타일 코드가 있다면, 점진적 리팩토링 시 `Ref` 하나로 통일.

### 2-2. AutoDispose 인터페이스 삭제

* `AutoDisposeProvider`, `AutoDisposeNotifier`, `AutoDisposeRef` 등은 **인터페이스로 존재하지 않는다.**
  대신, AutoDispose 여부는 Provider 선언 시 `.autoDispose` / 옵션으로 지정. ([riverpod.dev][4])

* 마이그레이션 시에는 단순히 **`AutoDispose` 문자열 제거**가 권장된다고 명시되어 있다. (클래스 상속 기준) ([riverpod.dev][5])

### 2-3. Notifier 내부 상태 관리

* Riverpod 3에서는 Notifier 라이프사이클 관련 논의가 있었고,
  문서와 이슈에서 **가능한 한 상태를 `state` 안에 모으는 것이 권장**된다. ([GitHub][6])

* 규칙:

  1. **도메인 상태는 모두 `state` 에 들어가도록 설계**한다.

     * 타이머, StopWatch, 컨트롤 객체 등도 필요하다면 모델로 감싸서 `state` 에 포함.
  2. 정말 인스턴스 필드가 필요하다면:

     * “UI에 노출되지 않는 내부 헬퍼” 수준에만 사용하고,
       재생성(리빌드) 되더라도 큰 문제가 없게 설계한다.

---

## 3. 자동 재시도, 오류 처리, 일시정지 동작

### 3-1. Automatic Retry

* 3.0에서는 비동기 Provider가 실패하면 **기본으로 자동 재시도(지수 백오프)** 를 한다. ([riverpod.dev][2])

* 전역 비활성화:

  ```dart
  void main() {
    runApp(
      ProviderScope(
        retry: (retryCount, error) => null, // 전역 재시도 끔
        child: MyApp(),
      ),
    );
  }
  ```

* 특정 Provider에서만 재시도 비활성화 또는 커스터마이즈:

  ```dart
  final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(
    TodoListNotifier.new,
    retry: (retryCount, error) => null, // 이 Provider만 재시도 끔
  );
  ```

* 작성 규칙:

  * **같은 기능의 “수동 재시도 로직(while / retry 횟수 관리)”을 새로 만들지 말고, 우선 built-in retry를 활용**한다.
  * 요구사항 상 “한 번만 시도하고 실패해야 하는 API”라면 해당 Provider에 `retry: (count, error) => null` 을 명시한다.

### 3-2. Provider 실패 시 예외 타입

* 3.0에서는 Provider가 실패할 경우, **직접 에러를 던지는 대신 `ProviderException` 으로 래핑되어 던져진다.** ([riverpod.dev][2])

* 기존에 `NotFoundException` 같은 구체 타입을 `try/catch` 로 잡던 코드가 있다면:

  ```dart
  try {
    await ref.read(myProvider.future);
  } on ProviderException catch (e) {
    if (e.exception is NotFoundException) {
      // 여기서 처리
    }
  }
  ```

* 하지만 대부분의 경우, UI에서는 여전히 `AsyncValue.error` 를 통해 에러 타입을 확인할 수 있고, 이 경우 **마이그레이션 불필요**. ([riverpod.dev][2])

* 작성 규칙:

  * **코드 생성 시 직접 `try/catch` 로 Provider를 감싸야 한다면**
    `ProviderException` 기준으로 잡고, 내부 `exception` 타입을 분기한다.
  * UI에서 에러 핸들링을 구현할 때는 여전히 `AsyncValue` 패턴(`when`, `switch` 패턴 매칭)을 권장한다.

### 3-3. 화면 밖 Provider 일시정지

* 3.0에서는 “화면에서 벗어난 Consumer” 의 Provider는 **기본적으로 일시정지(pause)** 된다. ([riverpod.dev][2])

* 특정 위젯 트리에서 이 동작을 끄고 싶다면 `TickerMode` 로 감싼다.

* 작성 규칙:

  * 일반적인 코드는 이 동작을 건드릴 필요가 없다.
  * 애니메이션/타이머/스트림이 **화면과 무관하게 계속 돌아야 한다면**,
    사용자가 명시적으로 말하지 않는 이상 마음대로 `TickerMode` 를 추가하지 않는다.
    (필요할 때만 예시를 제안하는 수준으로.)

---

## 4. AutoDispose, Family 마이그레이션 템플릿

### 4-1. AutoDisposeNotifier → Notifier

**Before (2.x 스타일)**

```dart
final counterProvider =
    AutoDisposeNotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class CounterNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}
```

**After (3.x 기준)**

```dart
final counterProvider =
    NotifierProvider.autoDispose<CounterNotifier, int>(CounterNotifier.new);

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}
```

> 작성 규칙:
>
> * 이런 구조를 발견하면 **자동으로 위와 같이 변환**한다.
> * 새 코드를 생성할 때는 처음부터 `Notifier`/`AsyncNotifier` 만 사용한다. ([riverpod.dev][4])

### 4-2. FamilyNotifier → Notifier + 생성자

**Before**

```dart
final provider =
    NotifierProvider.family<CounterNotifier, int, String>(CounterNotifier.new);

class CounterNotifier extends FamilyNotifier<int, String> {
  @override
  int build(String arg) {
    // ...
    return 0;
  }
}
```

**After**

```dart
final provider =
    NotifierProvider.family<CounterNotifier, int, String>(CounterNotifier.new);

class CounterNotifier extends Notifier<int> {
  CounterNotifier(this.arg);

  final String arg;

  @override
  int build() {
    // arg 사용
    return 0;
  }
}
```

> 이 변환 패턴은 공식 마이그레이션 가이드에서 제시하는 방식이다. ([riverpod.dev][2])

---

## 5. Consumer / Widget 쪽 코드 스타일

### 5-1. 기본 Widget 패턴

* Flutter 위젯에서는 **기본적으로 `ConsumerWidget` / `ConsumerStatefulWidget` + `WidgetRef` 조합**을 사용한다.

```dart
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterProvider);

    return Text('$state');
  }
}
```

### 5-2. AsyncValue 패턴 매칭

* Riverpod 3 문서에서는 **`switch` + 패턴 매칭**을 추천한다. ([riverpod.dev][7])

```dart
final asyncUser = ref.watch(userDetailProvider(userId));

return switch (asyncUser) {
  AsyncData(:final value) => UserView(user: value),
  AsyncError(:final error) => ErrorView(error: error),
  _ => const LoadingView(),
};
```

> 작성 규칙:
>
> * `AsyncValue.when(...)` 도 여전히 사용 가능하지만,
>   Dart 3 패턴 매칭을 사용할 수 있으면 **switch 패턴 스타일을 우선 제안**한다.

---

## 6. 테스트 유틸 / 관찰자

### 6-1. 테스트

* Riverpod 3에서는 테스트용 헬퍼가 추가/개선되었다. ([riverpod.dev][1])

  * `ProviderContainer.test`
  * `WidgetTester.container`
  * `NotifierProvider.overrideWithBuild`
  * `FutureProvider.overrideWithValue`, `StreamProvider.overrideWithValue`

> 작성 규칙:
>
> * 테스트 코드를 생성할 때는 **이 유틸을 활용한 예시를 제안**할 수 있다.
> * 특히 `overrideWithBuild` 로 Notifier의 `build()` 만 바꿔치기하는 패턴을 추천.

### 6-2. ProviderObserver 변경

* 3.0에서 `ProviderObserver` 의 메서드 시그니처가 바뀌어,
  `ProviderObserverContext` 라는 객체가 추가로 전달된다. ([riverpod.dev][2])

* 마이그레이션 예:

  * 이전: `didAddProvider(ProviderBase provider, Object? value, ProviderContainer container)`
  * 이후: `didAddProvider(ProviderObserverContext context, Object? value)`

> 작성 규칙:
>
> * 프로젝트에 커스텀 `ProviderObserver` 가 있다면,
>   **새 메서드 시그니처로 재작성**해준다.

---

## 7. 마지막 요약

1. **항상 Riverpod 3 기준으로 코드를 생성**한다.
2. 새 비즈니스 상태는 기본적으로 **`Notifier` / `AsyncNotifier` / `StreamNotifier`** 를 사용한다.
3. `AutoDisposeNotifier`, `FamilyNotifier` 등 **2.x 전용 타입은 사용하지 않는다.**

   * 대신 Provider 쪽 `.autoDispose`, Notifier 쪽 생성자 인자를 사용한다.
4. 레거시 `StateNotifierProvider`/`ChangeNotifierProvider` 는
   * 이미 존재하면 그대로 두고,
   * 새 코드는 가능하면 Notifier 계열로 만든다.
5. 비동기 오류/재시도는 3.0의 **자동 재시도 + `ProviderException`** 모델을 따른다.
6. **`Ref` 는 한 종류만 사용**하고, Typed Ref 는 만들지 않는다.
7. 가능한 경우 **Dart 3 패턴 매칭** (`switch (asyncValue) { ... }`) 으로 AsyncValue를 처리한다.


[1]: https://riverpod.dev/docs/whats_new "What's new in Riverpod 3.0 | Riverpod"
[2]: https://riverpod.dev/docs/3.0_migration "Migrating from 2.0 to 3.0 | Riverpod"
[3]: https://medium.com/%40ishuprabhakar/riverpod-3-0-1c0e247bfb2f?utm_source=chatgpt.com "Riverpod 3.0 - by Ishu Prabhakar"
[4]: https://riverpod.dev/docs/whats_new?utm_source=chatgpt.com "What's new in Riverpod 3.0"
[5]: https://riverpod.dev/docs/3.0_migration?utm_source=chatgpt.com "Migrating from 2.0 to 3.0"
[6]: https://github.com/rrousselGit/riverpod/issues/4310?utm_source=chatgpt.com "Issue #4310 · rrousselGit/riverpod"
[7]: https://riverpod.dev/?utm_source=chatgpt.com "Riverpod"
