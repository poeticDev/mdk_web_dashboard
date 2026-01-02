# Timetable Occurrence Migration Plan

## 목표
- 기존 Lecture 기반 조회/표시 로직을 서버의 Occurrence API 기반으로 전환한다.
- 강의 등록/수정 UI에서 발생한 변경이 서버 Occurrence/Lecture 정책과 일관되도록 한다.
- 수정/삭제 모달에서 “단일/이후 전체/마스터 전체(override 포함 여부)” 옵션을 제공한다.
- RRULE 입력은 Weekly Preset(UI 옵션)으로 단순화하되, 서버 RRULE 정책을 준수한다.

## 범위
1. Occurrence 조회 및 캘린더 표시
2. Occurrence/lecture 생성·수정·삭제 흐름 UX
3. RRULE → Occurrence 동기화 전략
4. 테스트 & 문서 업데이트

## 단계별 체크리스트

### 1. Occurrence 데이터 소스 전환
- [x] `LectureOccurrenceDto`/mapper 정의 및 domain entity 도입
- [x] `GET /lectures/occurrences` 호출용 Repository + UseCase 구현
- [x] `SfCalendar` DataSource는 동일 인터페이스를 유지하되 공급되는 ViewModel을 occurrence 기반으로 변경
- [x] `ClassroomTimetableState`/Controller를 occurrence 목록 중심으로 교체
- [x] 조회 기간 로직(`loadMore`)을 occurrence API에 맞게 재구현

### 2. 상세/수정/삭제 옵션 설계
- [ ] Occurrence 탭 시 “단일 수정/이후 전체/마스터 수정” 옵션 UI/모달 구성
- [ ] 서버 API 매핑:
  - 단일 occurrence → `PATCH /lectures/occurrences/:id` (시간 수정), `POST /lectures/occurrences/:id/cancel`, `DELETE /lectures/occurrences/:id`
  - 이후 occurrence → 서버가 제공하는 `applyToFollowing` 옵션을 활용해 동일 엔드포인트로 범위 수정/삭제
  - 마스터 수정 → `PATCH /lectures/:id` + `applyToOverrides` 옵션으로 override 포함 여부 제어
- [ ] override 포함/제외 스위치 UI 및 API 파라미터 설계
- [ ] optimistic locking(version) 처리 흐름 정리 (occurrence vs lecture)

### 3. 강의 생성/수정 RRULE 처리
- [ ] 신규 생성 시 LectureCreate → 서버가 occurrence 생성하도록 유지, UI에서는 occurrence 리스트 재조회
- [ ] 수정 시 Weekly 옵션(Until/Count)에서 생성한 RRULE을 전달하고, occurrence 변경이 즉시 반영되는지 확인
- [ ] RRULE 파싱하여 모달 편집 폼에 역주입(현재 구현 개선)
- [ ] 서버 RRULE 정책 문서(timetable.rrule-policy/presets)에 맞춰 입력 유효성 검증

### 4. 상태/테스트/문서
- [ ] Controller/State에 occurrence/lecture 동시 보관 구조 검토(Riverpod provider 분리 여부)
- [ ] 단위/통합 테스트:
  - Occurrence fetch/usecase
  - DataSource loadMore & tap 동작
  - Modal 옵션별 API 호출 검증(Mock)
- [ ] 문서 업데이트:
  - `docs/architecture/classroom_timetable_modal_plan.md` 연동 절차
  - 새 플로우(Occurrence 기반)의 README/개발 가이드 작성

## 질문/오픈 이슈
1. “이후 occurrence 전체 수정/삭제” API 스펙: 서버가 제공하는 `applyToFollowing` 옵션 세부 사용법(단일/다중 엔드포인트별)을 확인하고 UI/로직에 반영.
2. override 포함 여부를 서버가 어떤 파라미터로 받는지(occurrence mutation API 참고).
3. occurrence와 lecture version 관계: occurrence 단위 수정에 버전이 있는지, Lecture 버전만으로 optimistic locking을 처리하는지 명확히 파악.
4. RRULE Preset 이외의 고급 옵션 요구 여부(추가 UX 스펙 확인 필요).
