# Timetable Implementation Tasks

## Task 1. Syncfusion Calendar 준비
**Description:** 캘린더 기능의 기반이 될 `syncfusion_flutter_calendar` 패키지를 프로젝트에 통합하고, 테마 연동 구조를 확인한다.

- [x] pubspec에 `syncfusion_flutter_calendar`와 `syncfusion_localizations` 의존성 추가
- [x] `flutter pub get` 실행 및 라이선스 고지 확인
- [x] `SfCalendarTheme`를 `AppTheme`/`AppColors` 토큰과 연결하는 샘플 위젯 작성

**Definition of Done**
- 튜토리얼용 `SfCalendar` 위젯이 로컬에서 빌드되고, 프로젝트 테마 색상이 적용된다. ✅

## Task 2. 도메인 모델 수립
**Description:** Clean Architecture 기준으로 강의 일정 도메인 엔티티와 값 객체를 정의한다.

- [x] `LectureType`, `LectureStatus` enum 정의
- [x] `LectureEntity`(필수 필드+nullable 필드 명시) 작성
- [x] `LectureRepository` 인터페이스 시그니처 확정 (`fetchLectures`, `createLecture` 등)

**Definition of Done**
- `lib/core/timetable/domain/**` 경로에 엔티티와 계약이 생성되고 린트 통과. ✅

## Task 3. 데이터 계층 구현
**Description:** API DTO 및 RemoteDataSource를 작성해 서버와 통신한다.

- [x] `LectureDto`와 JSON 직렬화 로직 구현
- [x] `LectureRemoteDataSource`에서 GET/POST/PUT/DELETE 메서드 작성
- [x] DTO ↔ Domain 변환 Mapper 작성 및 단위 테스트 추가

**Definition of Done**
- RemoteDataSource 단위 테스트가 성공하고, 모든 메서드가 stub 서버에서 기대 JSON을 송수신한다. ✅

## Task 4. Repository & UseCase 작성
**Description:** Data 계층을 Domain 계약에 연결하고, Application 계층에서 사용할 UseCase를 만든다.

- [ ] `LectureRepositoryImpl`에서 Domain 계약 구현
- [ ] `GetLecturesUseCase`, `SaveLectureUseCase`, `DeleteLectureUseCase` 등 작성
- [ ] 비즈니스 규칙(시간 겹침, status 처리)을 UseCase 레벨에서 캡슐화

**Definition of Done**
- UseCase 단위 테스트가 성공하고, Repository가 RemoteDataSource를 정확히 호출한다.

## Task 5. Controller & 상태 모델링
**Description:** Riverpod 기반 Controller와 불변 상태를 정의해 UI와 UseCase를 연결한다.

- [ ] `ClassroomTimetableController`와 `ClassroomTimetableState`(freezed) 작성
- [ ] 필터(lectureType, departmentId, instructorId, classroomId) 입력 메서드 구현
- [ ] `isLoading`, `lectures`, `selectedDateRange` 등 상태 필드 정의

**Definition of Done**
- Controller에 대한 단위 테스트가 필터 입력 및 데이터 로딩 시나리오를 모두 통과한다.

## Task 6. ViewModel & CalendarDataSource
**Description:** Controller 상태를 캘린더에 필요한 ViewModel로 변환하고 DataSource를 작성한다.

- [ ] `LectureViewModel` 생성 (색상, 라벨, ID 포함)
- [ ] `LectureColorResolver`에서 AppColors + HSL 변주 로직 구현
- [ ] `LectureDataSource extends CalendarDataSource` 작성

**Definition of Done**
- `LectureDataSource`가 테스트에서 올바른 start/end/subject/color 값을 반환한다.

## Task 7. UI 레이아웃 구축
**Description:** 강의실 상세 페이지 하단에 헤더, WeekView, MonthView를 배치한다.

- [ ] 상단 헤더(주/월 토글, 날짜 네비게이션, 일정 등록 버튼) 위젯 작성
- [ ] `SfCalendar` WeekView/MonthView 구성 및 컨트롤러 상태 바인딩
- [ ] Today 버튼과 현재 진행 중 강의 하이라이트 구현

**Definition of Done**
- 데스크톱 브라우저에서 주/월 전환과 날짜 이동이 정상 동작하며, Controller 상태 변화가 즉시 반영된다.

## Task 8. 일정 CRUD 인터랙션
**Description:** 모달/폼을 통해 일정 생성·수정·삭제를 수행하고 권한별 제어를 추가한다.

- [ ] 일정 더블클릭 → 생성 모달 호출, 일정 클릭 → 상세/수정 모달 구현
- [ ] `admin/operator/limited_operator/viewer` 별 허용 기능 분기
- [ ] 휴강(status = CANCELED) 표시(채도 낮춤) 및 토스트 메시지 처리

**Definition of Done**
- CRUD 플로우 통합 테스트(모달 입력 → Repository 호출 → 상태 갱신)가 성공하고, Role 별 UI 차단이 확인된다.

## Task 9. API 연동 및 성능 최적화
**Description:** onViewChanged 디바운스, from/to 캐싱, 타임존/시간 규칙을 구현한다.

- [ ] `onViewChanged` 핸들러에서 visibleDates 기반 쿼리 생성 및 200ms 디바운스 추가
- [ ] 마지막 from/to 캐시하여 동일 범위 재요청 방지
- [ ] Asia/Seoul 타임존 기준 DateTime 파싱 유틸 작성

**Definition of Done**
- 실제 API 연결 시 빠른 스크롤에도 요청 수가 제한되고, 일정이 올바른 시간대에 표시된다.

## Task 10. 문서 및 QA 정리
**Description:** 신규 기능을 문서화하고 QA 시나리오를 작성한다.

- [ ] `docs/collaboration/design_notes/calendar_design.md` 상태/진행률 반영
- [ ] `README` 혹은 기능별 MD에 실행/테스트 방법 추가
- [ ] QA 체크리스트(필터 조합, 반복 일정, 휴강 표시) 작성

**Definition of Done**
- 문서가 최신 상태로 PR에 포함되고, QA 체크리스트가 공유된다.

## Backlog / 추후 결정 필요
- 반응형 breakpoint, 모바일/태블릿 제스처 UX
- 휴강 추가 UI 요소(아이콘, 배너 등)
- 신규 색상 토큰 도입 여부
- 모바일 헤더 축약/버튼 재배치 안건
