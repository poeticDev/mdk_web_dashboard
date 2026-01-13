# Dart Library 주석 규칙

> ROLE / RESPONSIBILITY / DEPENDS ON 구조를 사용하여
> 라이브러리의 설계 의도를 명확하게 문서화한다.

---

## 🎯 목적

* 파일 단위 책임 명확화
* 협업 시 빠른 이해
* 의존성 구조 가시화
* 코드 리뷰 기준 제공

---

## 📌 기본 규칙

1. **모든 핵심 로직 파일에는 library 주석을 작성한다.**
2. 구조는 반드시 아래 3개 섹션을 따른다.

   * ROLE
   * RESPONSIBILITY
   * DEPENDS ON
3. 각 섹션은 대문자로 표기한다.
4. ROLE은 반드시 **1줄 요약**으로 작성한다.
5. RESPONSIBILITY는 **최대 3~4개**까지만 작성한다.
6. DEPENDS ON에는 **상위 레이어 의존을 금지**한다.

---

## 🧩 표준 템플릿

```dart
/// ROLE
/// - 이 라이브러리가 하는 일 한 줄 요약
///
/// RESPONSIBILITY
/// - 책임 1
/// - 책임 2
/// - 책임 3
///
/// DEPENDS ON
/// - 의존 모듈 / 패키지 / 레이어
library your_library_name;
```

---

## ✅ 실전 예시

### 예시 1: 실시간 상태 관리

```dart
/// ROLE
/// - 강의실 실시간 상태를 관리하는 상태 허브
///
/// RESPONSIBILITY
/// - MQTT 이벤트 수신
/// - 장비 상태 캐싱
/// - 대시보드 갱신 트리거
///
/// DEPENDS ON
/// - mqtt_client
/// - classroom_repository
/// - time_utils
library classroom_realtime_hub;
```

---

### 예시 2: 인증 유틸

```dart
/// ROLE
/// - 사용자 인증 관련 공통 유틸
///
/// RESPONSIBILITY
/// - 로그인 처리
/// - 토큰 갱신
/// - 권한 검증
///
/// DEPENDS ON
/// - dio
/// - secure_storage
library auth_utils;
```

---

## 🚦 코드 리뷰 기준

* ROLE이 모호하면 ❌
* RESPONSIBILITY가 5개 이상이면 ❌ (파일 분리 검토)
* DEPENDS ON에 상위 레이어 있으면 ❌
* 실제 코드와 주석이 다르면 ❌

---

## 💡 운영 팁

* 파일 책임 변경 시 주석도 함께 수정
* 신규 파일 생성 시 템플릿 먼저 작성
* 아키텍처 논의 시 주석 기준으로 토론

---

## ✨ 확장 포맷 (선택)

```dart
/// ROLE
/// - 
///
/// RESPONSIBILITY
/// - 
///
/// DEPENDS ON
/// - 
///
/// EMITS
/// - 발생 이벤트
///
/// CONSUMES
/// - 수신 이벤트
library your_library_name;
```

(리액티브 / 이벤트 기반 구조에서 사용)