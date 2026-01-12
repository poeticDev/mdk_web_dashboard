# Create the markdown file content again
content = """# 로그인 페이지 설계 문서 (초안)

## 1. 문서 개요
이 문서는 **관제 웹앱(Flutter Web)에서 사용할 로그인 페이지(UI + 로직 + 상태관리)**의 구조를 정의한다.  
서버는 NestJS 기반이며, 세션 기반 인증(sid 쿠키)을 사용한다.

Codex CLI는 이 문서를 기반으로 다음 항목들을 자동 생성할 수 있어야 한다:
- 로그인 UI 코드
- Auth 상태관리 코드
- API 연동 코드
- 라우팅 및 Guard 코드

---

## 2. 시스템 및 맥락 요약

### 2.1 전체 아키텍처
- Frontend: Flutter Web
- Backend: NestJS + PostgreSQL
- 인증 방식: **서버 세션 기반 인증**
    - `/api/login` → sid 쿠키 발급
    - `/api/me` → 현재 로그인 사용자 조회
    - `/api/logout` → 세션 종료

### 2.2 로그인 후 이동 화면
- `/dashboard`

---

## 3. 로그인 기능 요구사항

### 3.1 사용자 범위
- MDK 사내 직원
- 캠퍼스 교직원, 교수
- 추후 학생/조교 계정 확장 가능성 고려

### 3.2 기능적 요구사항
- username + password 로그인
- 성공 → sid 쿠키 발급 → 메인 페이지로 리다이렉트
- 실패 → 에러 메시지 표시
- 이미 로그인된 상태에서 `/login` 접근 시 자동 리다이렉트

### 3.3 비기능 요구사항
- 로그인 요청 중 로딩 표시
- 30분 미사용 시 세션 자동 만료
- 오류 발생 시 적절한 사용자 메시지 제공

---

## 4. UX / 화면 구성

### 4.1 기본 화면 구조
- 상단: 학교 로고와 서비스명
- 중앙: 카드형 로그인 패널
    - username 필드
    - password 필드
    - 로그인 버튼
- 하단: 버전 정보 또는 저작권 표시

### 4.2 상태별 UI
- 기본 상태: 입력 가능
- 요청 중: 버튼 비활성화 + 로딩 중 인디케이터
- 성공: 부드러운 화면 전환
- 실패: 입력값 유지 + 오류 메시지

### 4.3 표시 문구
- 로그인 실패: “아이디 또는 비밀번호가 올바르지 않습니다.”
- 세션 만료: “세션이 만료되었습니다. 다시 로그인해주세요.”
- 네트워크 장애: “서버와 통신할 수 없습니다.”

---

## 5. 상태 및 데이터 모델 설계

### 5.1 LoginFormState
- username: string
- password: string
- isSubmitting: boolean
- errorMessage: string?

### 5.2 AuthState
- currentUser: (id, username, roles) | null
- isAuthenticated: boolean
- isLoadingMe: boolean

### 5.3 상태관리 방식
- Riverpod 사용
    - 로그인 페이지는 단일 usecase provider
    - 전역 AuthState provider 존재

### 5.4 쿠키/세션 처리
- sid 쿠키는 브라우저에서 자동 저장
- 프론트는 sid를 직접 조작하지 않음
- 모든 API 요청 시 `withCredentials: true` 필요 여부 프로젝트 설정에 따라 결정

---

## 6. API 연동 설계

### 6.1 로그인 API
- POST `/api/login`
- Request:
    - `{ "username": "...", "password": "..." }`
- Response:
    - `{ "message": "login successful", "user": { "id": ..., "username": ... } }`
    - Set-Cookie: sid=…

### 6.2 사용자 조회 API
- GET `/api/me`
- 정상 → 사용자 정보
- 401 → 세션 만료 또는 로그인 필요

### 6.3 로그아웃 API
- POST `/api/logout`
- 동작: 세션 삭제 후 200 OK

### 6.4 에러 처리 정책
- 400/401: 로그인 실패 메시지 표시
- 500: “서버에서 오류가 발생했습니다.”

---

## 7. 라우팅 및 접근 제어

### 7.1 라우팅 규칙
- `/login` → 로그인 페이지
- `/dashboard` → 메인 관제 화면

### 7.2 접근 제어
- 로그인되어 있지 않은 상태에서 보호 페이지 접근 → `/login`으로 이동
- 로그인된 상태에서 `/login` 접근 → `/dashboard` 리다이렉트

### 7.3 세션 만료 처리
- 어떤 API에서라도 401이 발생하면:
    - AuthState 초기화
    - `/login?expired=true` 이동

---

## 8. 보안 및 정책

- password 필드는 auto-fill 허용 또는 비허용 여부 설정 필요
- sid 쿠키는 HttpOnly + SameSite=Lax 기준
- 로그인 요청 시 HTTPS 전제 (운영 환경)
- 로그인 시도 횟수 제한 (서버 정책에 따름)

---

## 9. 테스트 시나리오

- 정상 로그인
- 잘못된 비밀번호
- 비활성 사용자(isActive=false)
- 세션 만료 후 요청
- 로그인 없이 보호 페이지 접근
- 로그인 상태에서 로그인 페이지 접근

---

## 10. Codex CLI 연동 가이드

### 10.1 Codex가 이 문서로 해야 할 일
- 로그인 화면 UI 생성
- Auth State/Notifier 생성 (Riverpod)
- API 연동 코드 생성
- 라우팅/가드 생성

### 10.2 파일 구조 예시
- `lib/ui/login/login_page.dart`
- `lib/ui/login/login_viewmodel.dart`
- `lib/domains/auth/auth_repository.dart`
- `lib/domains/auth/auth_state.dart`
- `lib/routes/app_router.dart`

### 10.3 Codex에게 전달할 프롬프트 예시
- “로그인 페이지 설계문서를 기반으로 login_page.dart를 생성해줘.”
- “AuthState 및 AuthController 생성해줘.”
- “/login과 /dashboard 라우트에 대한 가드 로직 만들어줘.”
  """
