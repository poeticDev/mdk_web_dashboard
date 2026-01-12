# 📘 **강의실 시간표 시스템 설계 문서 (정리본 v0.2)**

**대상:** 채클(Codex CLI) 및 협업 개발자
**목표:** `syncfusion_flutter_calendar`(pub.dev) 기반 강의·시험·이벤트 시간표 UI 구현 (조회 → 수정 단계적 확장)

---

# 1. 📌 프로젝트 개요

## 1.1 목적

* `syncfusion_flutter_calendar` 패키지를 활용해 **강의실 시간표(스케줄러)** UI를 제공한다.
* 서버의 `Lecture` 엔티티 데이터를 이용하여 **주간/월간/리소스(Resource) 기준 일정 시각화**를 지원한다.

## 1.2 범위

### ✔ 1차 버전 (조회 중심)

* 강의실별 주간 시간표 조회
* 학과/시험/행사 등 LectureType 표시
* 반복 일정(`recurrenceRule`) 지원
* 일정 상세 팝업
* 한 화면에는 **단일 강의실**만 표시(멀티 강의실 동시 뷰는 범위 외)

### ✔ 2차 버전 (생성/수정/삭제)

* 일정 생성/수정/삭제 모달
* 드래그 이동 / 리사이즈로 시간 변경
* 관리자/교원 권한 기반 편집 제어

## 1.3 사용 패키지 (`syncfusion_flutter_calendar`)

* Pub: https://pub.dev/packages/syncfusion_flutter_calendar
* 위젯 구성: `SfCalendar` + `CalendarView.week/month`, `CalendarDataSource`, `TimeRegion`, `Appointment`
* 필수 import: `import 'package:syncfusion_flutter_calendar/calendar.dart';`
* 테마 반영: `SfCalendarTheme`로 `docs/reference_guides/theme_design.md` 토큰과 매핑
* 패키지 버전은 프로젝트 pubspec에서 고정(`^24.x` 예상), 차기 minor 업그레이드 시 breaking change 검토 필요

---

# 2. 🧭 사용 시나리오

## 2.1 강의실별 주간 일정 확인

* 강의실 상세 페이지 하단에 WeekView 형태의 시간표 제공
* 월~금 기준, 주말은 옵션으로 표시
* 기본 시간대: 08:00–22:00
* **현재 진행 중인 강의는 하이라이트 처리**

## 2.2 필터 조건

* 학과(departmentId), 강의자(instructorId), LectureType(LECTURE/EVENT/EXAM)
* 강의실(classroomId) 단일 선택만 지원, 멀티 강의실 동시 필터링은 계획 없음
* 모든 필터 값 및 편집 payload는 **ID 기반**으로 주고받는다. UI에서 노출하는 이름은 캐시된 사전(lookup)에서 resolve한다.

## 2.3 이벤트·시험 관리

* 시험(EXAM), 행사(EVENT)는 색상과 아이콘으로 구분
* base color(타입별) + 강의별 색상 변주(±10~15%) 적용
* 서버가 `colorHex`를 제공하는 경우 이를 우선 사용함

## 2.4 일정 생성/수정 동작

* 관리자·오퍼레이터 전용 기능
* 권한이 없는 사용자는 동일 UI를 보되, 조작 시도 시 토스트 (‘권한이 없습니다’)만 표시
* 일정 생성: 캘린더 더블클릭 또는 상단 헤더의 “일정 등록” 버튼
* 일정 수정: 일정 클릭 → 상세/수정 모달
* 시간 조정: 드래그 / 리사이즈
* 반복 일정 설정 가능
* 생성/수정 payload는 `classroomId`, `departmentId`, `instructorId` 등 모든 참조를 ID 필드로 전달하고, 프론트는 선택 UI에서 라벨만 매핑한다.

---

# 3. 🗂 데이터 & Clean Architecture 매핑

## 3.1 계층 책임 정리

`docs/architecture/directory_structure.md`에서 정의한 Clean Architecture를 준수해 다음 위치에 코드를 둔다.

| 계층 | 경로 예시 | 책임 |
| --- | --- | --- |
| Domain | `lib/domains/schedule/domain/entities/lecture_entity.dart` | 순수 엔티티, 값 객체, `LectureType` enum |
| Domain Repository Contract | `lib/domains/schedule/domain/repositories/lecture_origin_repository.dart` | 캘린더 화면이 의존하는 추상화 |
| Application (UseCase/Controller) | `lib/domains/schedule/application/usecases/get_lectures_usecase.dart`, `lib/domains/schedule/application/controllers/classroom_timetable_controller.dart` | 필터 적용, 상태 관리(Riverpod Controller) |
| Data | `lib/domains/schedule/data/datasources/lecture_origin_remote_data_source.dart`, `lecture_dto.dart` | `syncfusion_flutter_calendar`에 전달할 모델 변환, API 통신 |
| Presentation | `lib/features/classroom_detail/presentation/` | `SfCalendar`, `LectureDataSource`, 모달 |

* Controller는 `getIt`에 레이지 싱글톤으로 등록하고, Repository/Service 싱글톤 → RemoteDataSource/Dio 주입 사슬을 유지한다.
* UI 단에서는 Domain 엔티티 → Application 상태 → `LectureViewModel` → `CalendarDataSource` 순으로 불변 데이터가 흘러간다.

## 3.2 서버 엔티티 (`Lecture`)

```ts
id: string;
title: string;
externalCode?: string; // 같은 과목 묶기용 그룹 키
type: LECTURE | EVENT | EXAM;
classroom: Classroom;
department?: Department;
instructor?: User;
colorHex?: string;
startTime: Date;
endTime: Date;
recurrenceRule?: string; // iCal RRULE
notes?: string;
```

### 3.2.1 데이터 계층 DTO

* `LectureDto`는 서버 `Lecture` 엔티티의 전체 속성을 반영한다 (`id`, `title`, `version`, `externalCode?`, `type`, `classroomId`, `departmentId?`, `instructorId?`, `colorHex?`, `startTime`, `endTime`, `recurrenceRule?`, `notes?`, `createdAt`, `updatedAt`).
* DTO ↔ Domain 변환은 `LectureMapper`에서 수행하며, null 허용 필드는 `Option` 패턴이 아닌 nullable 속성으로 표현한다.
* RemoteDataSource는 `/api/v1` 하위의 `GET /classrooms/{classroomId}/timetable`, `POST /lectures`, `PATCH /lectures/{lectureId}`, `DELETE /lectures/{lectureId}`를 래핑하고 `Authorization: Bearer <token>` 헤더 및 `x-expected-version`(필요 시)을 자동으로 세팅한다.
* 다중 필터(`departmentId`, `instructorId`, `type`, `status`)는 API 레벨에서 아직 동작하지 않으므로, 구현 후 DataSource에 쿼리 파라미터 옵션을 추가할 TODO를 남긴다.

---

## 3.3 Flutter `LectureViewModel` (Presentation 전용)

```dart
class LectureViewModel {
  final String id;
  final String title;
  final LectureType type;
  final String classroomId;
  final String? departmentName;
  final String? instructorName;
  final Color color;           // 타입 기반 + 개별 변주
  final DateTime start;
  final DateTime end;
  final String? recurrenceRule;
  final String? notes;

  LectureViewModel(...);
}
```

* 생성 위치: `lib/ui/dashboard/models/lecture_view_model.dart`
* 생성 책임: 컨트롤러가 Domain 엔티티 + Theme 토큰을 조합해 ViewModel을 만든다.

---

## 3.4 Calendar DataSource Adapter

```dart
class LectureDataSource extends CalendarDataSource {
  LectureDataSource(List<LectureViewModel> lectures) {
    appointments = lectures;
  }

  @override DateTime getStartTime(int index) => appointments![index].start;
  @override DateTime getEndTime(int index) => appointments![index].end;
  @override String getSubject(int index) => appointments![index].title;
  @override String? getRecurrenceRule(int index) => appointments![index].recurrenceRule;
  @override Color getColor(int index) => appointments![index].color;
  @override List<Object>? getResourceIds(int index) =>
      [appointments![index].classroomId];
}
```

---

## 3.5 Lecture 엔티티 의미 & RRULE 규칙

### (1) Lecture = “시간표 상 하나의 **시간 슬롯**”

과목 자체가 아니라, **한 요일·한 시간대**를 구성하는 슬롯 단위이다.
예:

* 월 12:00–14:00 (Lecture #1)
* 수 14:00–16:00 (Lecture #2)

### (2) 같은 수업을 묶는 기준

* `externalCode`를 동일하게 부여하여 하나의 과목/분반을 그룹화
* 추후 필요 시 `courseId`로 구조 확장 가능

### (3) RRULE 적용 원칙

* RRULE은 iCal 규격 그대로 저장
* 하나의 Lecture는 **한 가지 시간대 패턴**만 가진다
* 서로 다른 시간대/요일 패턴은 **별도 Lecture row**로 분리
* 반복 일정 예외(보강/휴강 등)는 RecurrenceException을 기준으로 2차 설계

---

# 4. 🛰 API 설계 개요

## 4.1 조회 API (from/to 기반)

```
GET /classrooms/{classroomId}/timetable?from=...&to=...&tz=Asia/Seoul
```

### 필터

* 필수: `from`, `to`, `classroomId`
* 선택: `tz` (표시용 timezone)
* **미구현 메모**: `departmentId`, `instructorId`, `type`, `status`, recurrence 확장 파라미터(`view`, `expandRecurrence`, `recurrenceExpandLimit`)는 API가 아직 파싱만 수행하므로 실제 필터링/전개 로직이 붙는 시점에 문서를 갱신해야 한다.

### 서버 처리 기준

* `startTime`이 해당 범위에 포함되는 Lecture 반환
* 반복 일정은 DB에 저장된 `recurrenceRule`을 그대로 전달 (전개 미구현)
* CRUD 전체 계약은 `docs/architecture/timetable_api_brief.md` 및 본 문서 섹션 3.2.1을 기준으로 유지한다.

---

# 5. 📅 캘린더 UI 구성

## 5.0 전체 레이아웃 구조

강의실 상세 페이지의 하단 캘린더 섹션은 다음으로 구성된다:

1. **상단 헤더**

   * 주/월 전환
   * 날짜 네비게이션 (이전/다음, Today)
   * 일정 등록 버튼

2. **주간 캘린더 (WeekView)**

   * 메인 뷰
   * 08:00–22:00 표시

3. **월간 캘린더 (MonthView)**

   * 제목 기반 요약
   * 토글로 전환

4. **일정 생성·수정 모달**

   * 더블클릭 → 생성
   * 일정 클릭 → 상세/수정
   * ResourceView/ScheduleView는 추후 확장 안건이며 현재 스코프에서는 미사용

---

## 5.1 Syncfusion Calendar View 선택

### WeekView

* 강의실 상세 페이지의 기본 뷰
* 한 강의실 기준 일정 렌더링

### MonthView

* 강의실 월간 일정 개요
* 제목 요약 표시
* 상세 확인 시 WeekView로 연계 가능

### API 요청 타이밍

```
onViewChanged → visibleDates.first / visibleDates.last → from/to 계산 후 조회
```

---

## 5.2 UI 정책

### 색상 정책

| Type    | Base Color(AppColors) |
| ------- | --------------------- |
| LECTURE | `AppColors.primary`   |
| EVENT   | `AppColors.accentBlue`|
| EXAM    | `AppColors.warningRed`|
| CANCELED/휴강 | 기존 타입 색상의 채도 40% → 20%로 저감한 파스텔 버전 |

* **기존 팔레트 우선:** 새로운 색상이 필요한 경우 반드시 제안서를 만들고 PO 승인 후 적용한다.
* **변주 규칙:** `HSLColor.fromColor(base).withLightness(clamp(base.lightness ± 0.12))` 방식으로 밝기만 조정(±12%)한다. Saturation은 유지해 일관성을 보장한다.
* **서버 colorHex 우선 적용:** 값이 없을 때 위 규칙으로 변주, 휴강/예외 일정은 동일 Hue에서 채도만 0.2 수준으로 낮춘다.
* 예외(휴강) 일정은 UI에서 기존 타입 대비 명확히 채도가 낮은 칩으로 표현해 한눈에 구분되도록 한다.

### 일정 카드 텍스트

```
과목명
강사명
```

### 상세 팝업 정보

* 제목
* 강의실
* 학과
* 강사
* 시간
* 색상 프리셋 칩(10종)
* 메모(notes)

---

# 6. 👤 권한 정책

| Role             | 기능               |
| ---------------- | ---------------- |
| ADMIN            | 조회/수정/삭제/드래그 수정  |
| OPERATOR         | 조회/수정/삭제/드래그 수정  |
| LIMITED_OPERATOR | 지정 강의/강의실만 조회/수정 |
| VIEWER           | 조회만 가능           |

### UI 행동 차이

* VIEWER도 동일 UI는 보지만, 조작 시도 시 토스트로 차단
* 편집 기능은 UI는 노출하되 기능은 제한

---

# 7. 📎 반복 일정 처리 정책

* `recurrenceRule`은 iCal RRULE 그대로 저장
* 클라이언트는 RecurrenceRule을 CalendarDataSource에 그대로 전달
* Syncfusion Calendar가 반복 인스턴스 렌더링 처리
* 예외 일정은 2차 버전에서 RecurrenceException 기반으로 확장

---

# 8. 🌐 타임존 & 시간 정책

* 서버 DB: `timestamptz` (Asia/Seoul 기준)
* 클라이언트: 서버 전달 ISO8601 값을 그대로 사용 (`DateTime.parse`)
* 기본 표시 시간: 08:00–22:00
* 월~금 우선 / 주말 옵션 표시
* Today 버튼 제공

---

# 9. ⚙ 성능 고려사항

* `onViewChanged` 발생 시 visibleDates 범위 기반으로 from/to 재요청
* 빠른 뷰 이동은 **200ms debounce**(leading false, trailing true)로 API 호출을 묶는다.
* 동일 범위 재요청 방지: 마지막 from/to와 동일하면 네트워크 스킵.
* 일정 밀도 높을 경우 Syncfusion compact mode 활용

---

# 10. 🛠 채클(Codex CLI) 작업 지시사항

1. `LectureModel` Dart 정의
2. `LectureDataSource` 구현
3. `ClassroomTimetablePage` 생성
4. API 연동 서비스 & JSON 파싱
5. WeekView + 필터 + 상세 팝업 UI
6. ResourceView 도입 여부는 선택적 확장

# 11. ✅ 검토 요청 / 의사결정 필요 항목

1. **반응형 규격:** Breakpoint 폭, 최소 높이, 모바일/태블릿에서 WeekView를 어떤 축으로 스크롤할지 결정 필요.
2. **터치 제스처:** 터치 디바이스에서 더블탭 대신 어떤 UX(롱프레스? Floating Action Button?)를 채택할지 PO 확인 필요.
3. **신규 색상:** EVENT/EXAM 외 타입이 늘어날 경우 어떤 AppColors 토큰을 사용할지 별도 승인 필요.
4. **휴강 알림 UX:** 채도 저감 색상 외에 배너/아이콘 필요 여부.
5. **모바일 헤더 축약:** 헤더 버튼(주/월 토글, Today, 등록)을 모바일에서 어떻게 재배치할지 안건 확정 필요.
