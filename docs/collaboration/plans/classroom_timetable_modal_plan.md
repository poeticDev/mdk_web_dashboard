# Classroom Timetable Modal Plan

## 구현 목표
- 강의 일정 등록/수정 모달을 단일 공통 UI 컴포넌트로 제공해 일관된 UX를 유지한다.
- 기존 `LectureEntity` 기반 데이터를 입력 폼과 양방향 바인딩하여 수정 시 자동 채움(Auto-fill)을 지원한다.
- 등록/수정 모두 같은 강의실 컨텍스트에서 실행되므로 `classroomId`는 히든 값으로 유지하고, `classroomName`은 상단 요약으로 노출한다.
- Riverpod 컨트롤러 + Repository 흐름을 그대로 사용하면서, 모달은 ViewModel ↔ Entity 변환과 폼 검증 책임을 갖는다.

## UX/폼 요구사항
| 필드 | 유형 | 등록 초기값 | 수정 초기값 | 비고 |
| --- | --- | --- | --- | --- |
| Classroom | Readonly Text | 현재 강의실 이름 | LectureEntity.classroomName | 상단 헤더 표시 |
| Title | TextField | 빈 값 | lecture.title | 필수 |
| Type | Dropdown(LectureType) | 기본값 LectureType.scheduled | lecture.type | enum 값 |
| Department | Dropdown/Search | 빈 값 | lecture.departmentId | 선택 |
| Instructor | Dropdown/Search | 빈 값 | lecture.instructorId | 선택 |
| Start Time | DateTime picker | 현재 포커스 날짜 09:00 | lecture.start | 필수 |
| End Time | DateTime picker | start + 1h | lecture.end | 필수 (start < end) |
| Color | Color picker | Resolver 기본값 | lecture.colorHex | UI에 swatch |
| Recurrence Rule | TextField | 빈 값 | lecture.recurrenceRule | RFC5545 문자열 |
| Memo | Multi-line Text | 빈 값 | lecture.notes | 선택 |

## 상호작용 흐름
1. **열기**  
   - 등록: `_openCreateDialog` 호출 시 `ClassroomTimetableModal` 위젯을 보여주고, 기본값은 현재 포커스 날짜 기준.
   - 수정: `_openDetailDialog` → `Edit` 액션에서 동일 위젯을 재사용하되, `initialLecture`를 전달.
2. **검증**  
   - `Title`, `Start`, `End`, `Type` 필수. `End`는 `Start` 이후인지 검사.
   - Recurrence Rule은 간단한 정규식 or 서버 위임. 1차 단계에서는 비워두거나 문자열만 허용.
3. **전송**  
   - 등록 시 `LectureWriteInput` 생성 → `SaveLectureUseCase`.
   - 수정 시 `UpdateLectureInput` 생성 (lectureId + version).
   - 성공하면 모달 닫고 Snackbar 성공 알림, 실패 시 에러 메시지 표시.
4. **상태 싱크**  
   - 성공 후 `ClassroomTimetableController.refresh()` 호출해 최신 데이터 반영.

## 구현 단계 체크리스트
1. **컴포넌트 설계**
   - [x] `ClassroomTimetableModal` 위젯 생성: 공통 UI 골격과 모드(enum) 정의.
   - [x] 공통 다이얼로그(AppDialog) 사용으로 앱 전반 스타일 일치.
2. **폼 상태 관리**
   - [x] `TextEditingController`, `Form` + `GlobalKey`로 필드 상태 관리.
   - [x] Color/RRule/메모 입력 UI와 DateTime picker 구성.
3. **DI/콜백 연결**
   - [x] 등록 버튼에서 `ClassroomTimetableModal.show(...)` 호출해 UI 확인.
   - [x] 모달에서 제출 시 `LectureWriteInput`/`UpdateLectureInput` 콜백 호출.
4. **컨트롤러 연동**
   - [x] 등록: `SaveLectureUseCase` 기반 `saveLecture` API 연동 및 성공 스낵바.
   - [x] 수정: 동일 save 경로 + version 전달.
   - [x] 완료 후 `loadLectures` 재호출로 상태 싱크.
5. **테스트**
   - [ ] Form validator 단위 테스트 (입력 누락/종료시간 검사).
   - [ ] Modal submit → 콜백 호출 여부 위젯 테스트.
6. **문서/추적**
   - [ ] `docs/reference_guides/login_page_design.md` 패턴 참고 여부 기록.
   - [ ] 추후 API 스펙 변경 시 본 계획 업데이트.
