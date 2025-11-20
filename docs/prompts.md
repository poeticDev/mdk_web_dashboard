# Login Page Production Checklist

## 1. 기획 및 요구 정리
- [x] `docs/login_page_design.md`를 검토해 사용자 범위, UX 흐름, API 제약을 재확인한다.
- [x] 로그인 성공 시 `/dashboard`, 실패나 미인증 시 `/login` 리다이렉트 조건을 명시한다.
- [x] 세션 만료(30분)·401 응답 시 처리 메시지와 리디렉션 규칙(`/login?expired=true`)을 정의한다.

## 2. UI 스켈레톤 생성
- [x] `lib/ui/login/login_page.dart`에 상단 로고/서비스명, 중앙 카드형 폼(username, password, 버튼), 하단 버전 정보를 배치한다.
- [x] 기본/로딩/성공/실패 상태별 위젯 노출 규칙과 문구(예: "아이디 또는 비밀번호가 올바르지 않습니다.")를 구현한다.
- [x] 모든 위젯에 `const` 생성자를 적용해 불필요한 리빌드를 방지한다.

## 3. 상태 및 컨트롤러 구현
- [x] `freezed`로 `LoginFormState`(username, password, isSubmitting, errorMessage)와 `AuthState`(currentUser, isAuthenticated, isLoadingMe)를 정의한다.
- [x] Riverpod Notifier/Controller를 작성해 입력 핸들러와 `executeLogin()` 흐름을 분리하고, 상태 필드 검증을 내부에서 수행한다.
- [x] 컨트롤러를 getIt 레이지 싱글톤으로 등록하고 UI에서 provider를 구독하도록 연결한다.

## 4. API 연동 및 리포지토리
- [x] `lib/core/auth/auth_repository.dart`에 `/api/login`, `/api/me`, `/api/logout` 호출 메서드를 작성하고 `withCredentials` 설정을 검증한다.
- [x] 400/401 응답 시 사용자 메시지, 500 시 "서버에서 오류가 발생했습니다."를 반환하도록 오류 매핑을 구현한다.
- [x] 로그인 성공 시 sid 쿠키는 브라우저에 위임하고, 응답의 사용자 정보를 `AuthState`에 반영한다.

## 5. 라우팅과 가드
- [x] `lib/routes/app_router.dart`에서 `/login`, `/dashboard` 경로를 정의하고 AutoRoute/go_router 가드를 구현한다.
- [x] 인증되지 않은 접근은 `/login`, 이미 로그인된 사용자의 `/login` 접근은 `/dashboard`로 리디렉트한다.
- [x] API 401 감지 시 AuthState를 초기화하고 `/login?expired=true`로 이동시키는 흐름을 구성한다.

## 6. 테스트 & 검증
- [x] 로그인 성공, 잘못된 비밀번호, 비활성 사용자, 세션 만료, 보호 페이지 우회, 로그인 상태의 `/login` 접근 등 시나리오별 단위/위젯 테스트를 작성한다.
- [x] 테스트 명명은 AAA 패턴과 `inputX`/`mockX`/`expectedX` 변수 규칙을 따른다.
- [x] `flutter test --coverage`로 80% 이상을 유지하고, `flutter analyze`로 린트 상태를 확인한다.

## 7. Codex 자동화 프롬프트
- [ ] "로그인 페이지 설계문서를 기반으로 login_page.dart를 생성해줘." 등 문서 기반 명령을 정리해 Codex CLI에 전달한다.
- [ ] AuthState/Controller, 라우팅 가드 생성 프롬프트를 업데이트해 추후 자동 생성 시 재사용한다.
