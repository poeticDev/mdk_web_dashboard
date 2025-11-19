# Login Page Requirements Summary

## User Scope & Context
- 대상: MDK 사내 직원, 캠퍼스 교직원·교수. 추후 학생/조교 확장 고려.
- 프론트: Flutter Web. 백엔드: NestJS(PostgreSQL) + 세션 기반 인증(sid 쿠키).
- 인증 흐름: `/api/login`(POST) → sid 쿠키 발급, `/api/me`(GET) → 현재 사용자 조회, `/api/logout`(POST) → 세션 삭제.

## Redirect & Navigation Rules
- 로그인 성공 → `/dashboard`로 이동.
- 인증되지 않은 사용자가 보호 페이지 접근 → `/login`으로 이동.
- 이미 로그인된 사용자가 `/login` 접근 → `/dashboard` 리다이렉트.
- 세션 만료 또는 401 응답 시 AuthState 초기화 후 `/login?expired=true`로 이동.

## UX & Messaging
- 로딩 중: 로그인 버튼 비활성화 + 인디케이터 표시.
- 오류 메시지: 로그인 실패 "아이디 또는 비밀번호가 올바르지 않습니다.", 세션 만료 "세션이 만료되었습니다. 다시 로그인해주세요.", 네트워크 장애 "서버와 통신할 수 없습니다.", 서버 오류 "서버에서 오류가 발생했습니다.".
- 성공 시 부드러운 화면 전환, 오류 시 입력값 유지.

## 상태 모델 확인
- `LoginFormState`: `username`, `password`, `isSubmitting`, `errorMessage`.
- `AuthState`: `currentUser(id, username, roles) | null`, `isAuthenticated`, `isLoadingMe`.
- 상태 관리는 Riverpod Notifier + getIt 컨트롤러 주입.

## 세션/보안 요구
- 세션 타임아웃 30분. sid 쿠키 HttpOnly + SameSite=Lax, 프론트는 쿠키 직접 조작하지 않음.
- 모든 API 호출은 프로젝트 설정에 따라 `withCredentials: true` 확인.

## Implementation Notes
- UI: 상단 로고, 중앙 카드형 폼(아이디/비밀번호/버튼), 하단 버전 정보.
- Guard: AutoRoute/go_router 기반 보호 라우트 구성.
- 테스트: 정상 로그인, 잘못된 비밀번호, 비활성 사용자, 세션 만료, 보호 페이지 접근, 로그인 상태 접근 등 케이스 포함.
