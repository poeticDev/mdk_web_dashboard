# 로그인 이후 랜딩/자동 라우팅 설계

본 문서는 로그인 직후 진입하는 랜딩 스플래시 페이지를 통해
강의실 목록을 선조회하고 자동 라우팅하는 흐름을 정의한다.

## 목표

- 로그인 직후 **1회**만 강의실 개수 판단
- 강의실이 1개면 상세 화면으로 즉시 이동
- 대시보드를 건너뛰고 상세를 기본 진입으로 구성
- 랜딩 페이지에서 진행 상태를 시각적으로 표시

## 요구사항 정리

- 기준: 전체 강의실 목록
- 시점: 로그인 성공 직후 첫 진입
- 라우팅:
  - 1개 → `classroom_detail`
  - 2개 이상 → `dashboard`
  - 0개 → `dashboard` (빈 상태는 대시보드에서 처리)
- 사용자 개입 없음
- 진행 상태 메시지 표시

## 라우팅 구조

- 신규 라우트: `/landing` (`RouteNames.landing`)
- 로그인 이후 리다이렉트 목적지:
  - `/login` → `/landing`
  - `/landing` → `dashboard` 또는 `classroom_detail`

## 데이터 플로우

1. `LandingPage` 진입
2. `LandingController`가 `AuthUser`에서 foundation selection 결정
   - 우선순위는 **관리자가 바꿀 수 있도록 구성**한다.
   - 기본값: `departmentId` → `siteId`
   - 메모: 관리자 페이지 구현 시 우선순위 설정을 포함한다.
3. `FoundationClassroomsReadRepository.fetchClassrooms(...)`
4. 결과 개수에 따라 라우팅 결정

## 상태 모델(초안)

`LandingState`
- `step`: `checkingSession | loadingClassrooms | decidingRoute | error`
- `message`: 진행 상태 텍스트
- `errorMessage`: 오류 표시 메시지
- `nextRoute`: 라우팅 결과(내부용)

## UI/UX 정책

- 중앙 로딩 인디케이터 + 단계별 메시지 표시
- 에러 시 재시도 버튼 제공
- 중복 라우팅 방지 (1회만 이동)

## 예외 처리

- foundation selection 실패 → 오류 표시 + 재시도
- API 실패 → 오류 표시 + 재시도
- 0개 반환 → 대시보드 이동

## 작업 체크리스트

- [ ] 1. 라우팅 정의 추가
  - [ ] `RoutePaths`/`RouteNames`에 `landing` 추가
  - [ ] `GoRouter`에 `/landing` 라우트 등록
  - [ ] `/login` 로그인 성공 리다이렉트 목적지를 `/landing`으로 변경
- [ ] 2. Landing 상태 모델 정의 (`LandingState`)
  - [ ] 진행 단계 enum 정의(`checkingSession | loadingClassrooms | decidingRoute | error`)
  - [ ] 진행 메시지/에러 메시지 필드 설계
  - [ ] 라우팅 결과를 보관할 필드 추가
- [ ] 3. Landing 컨트롤러 구현
  - [ ] `AuthUser`에서 foundation selection 결정 (우선순위: `departmentId` → `siteId`)
  - [ ] `FoundationClassroomsReadRepository.fetchClassrooms(...)` 호출
  - [ ] 결과 count 기준으로 라우팅 결정 로직 구현
  - [ ] 예외 처리(선택 실패/네트워크 오류) 및 상태 갱신
- [ ] 4. Landing 페이지 UI 구현
  - [ ] 중앙 로딩 인디케이터 배치
  - [ ] 단계별 진행 메시지 표시
  - [ ] 에러 상태 시 재시도 버튼 제공
- [ ] 5. 자동 라우팅 1회 실행 보장
  - [ ] 중복 이동 방지 플래그 추가
  - [ ] 라우팅 완료 후 상태 정리
- [ ] 6. 실패/0개 케이스 처리
  - [ ] 0개 반환 시 대시보드 이동 정책 적용
  - [ ] 에러 발생 시 재시도/로그인 복귀 정책 명시
- [ ] 7. 검증 포인트 기록
  - [ ] 로그인 직후 landing 진입 확인
  - [ ] 강의실 1개일 때 상세 자동 이동 확인
  - [ ] 2개 이상일 때 대시보드 진입 확인
  - [ ] 오류/재시도 동작 확인
- [ ] 8. 문서/체크리스트 업데이트
  - [ ] 완료 단계 체크 표시
  - [ ] 변경된 정책/흐름 반영
