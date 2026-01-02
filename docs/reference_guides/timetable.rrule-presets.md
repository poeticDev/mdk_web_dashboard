# Depricated: 본 문서는 Depricated 되었음.
# Timetable RRULE Presets v1 (Syncfusion 호환)
## 핵심 원칙(중요)
1) RRULE은 "Syncfusion이 문서로 지원한다고 명시한 속성"만 사용한다.
   - FREQ, INTERVAL, COUNT, UNTIL, BYDAY, BYMONTHDAY, BYMONTH, BYSETPOS :contentReference[oaicite:2]{index=2}
2) WEEKLY는 BYDAY를 반드시 포함한다. (BYDAY 없으면 Syncfusion에서 Invalid weekly recurrence rule 에러 케이스 존재) :contentReference[oaicite:3]{index=3}
3) UNTIL은 서버 저장 표준을 1개로 정한다:
   - Canonical(권장): YYYYMMDDTHHMMSSZ (UTC + Z)
   - 입력 호환: YYYYMMDD(날짜만)도 수용 가능(일부 Syncfusion 예제/KB에서 사용) :contentReference[oaicite:4]{index=4}
4) "종료 조건"은 COUNT 또는 UNTIL 중 하나만 허용(둘 다 금지).
5) BYSETPOS 음수(-1/-2) 허용 (Syncfusion이 기능/예제로 다룸) :contentReference[oaicite:5]{index=5}

---

## v1 허용 프리셋 목록 (UI에서 제공할 옵션)

### A. 매일 반복 (DAILY)
- A1) 매 N일마다
  - RRULE: FREQ=DAILY;INTERVAL={n};(COUNT|UNTIL)
  - 예: FREQ=DAILY;INTERVAL=1;COUNT=10 :contentReference[oaicite:6]{index=6}

> 주의: Syncfusion 문서에는 BYDAY는 "daily에 적용되지 않는다"고 적혀있음 → DAILY에는 BYDAY를 넣지 않는다. :contentReference[oaicite:7]{index=7}

### B. 매주 반복 (WEEKLY)  ✅ (BYDAY 필수)
- B1) 매 N주마다, 특정 요일(들)
  - RRULE: FREQ=WEEKLY;INTERVAL={n};BYDAY={MO,TU,...};(COUNT|UNTIL)
  - 예: FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE;COUNT=10 :contentReference[oaicite:8]{index=8}
  - 예(UNTIL 날짜만 입력 호환): FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WED,FRI;UNTIL=20201225 :contentReference[oaicite:9]{index=9}

### C. 매월 반복 (MONTHLY) - "날짜 고정"
- C1) 매 N개월마다, 매월 {d}일
  - RRULE: FREQ=MONTHLY;INTERVAL={n};BYMONTHDAY={1..31 or -1};(COUNT|UNTIL)
  - 예: FREQ=MONTHLY;BYMONTHDAY=3;INTERVAL=1;COUNT=10 :contentReference[oaicite:10]{index=10}
  - 예(말일): FREQ=MONTHLY;BYMONTHDAY=-1;INTERVAL=1;COUNT=10 :contentReference[oaicite:11]{index=11}

> v1 제약(권장): BYMONTHDAY는 "단일 값"만 허용.
  (BYMONTHDAY=1,2,3 같은 복수는 Syncfusion 쪽에서 기대대로 안 될 수 있어서 v1에선 금지 추천)

### D. 매월 반복 (MONTHLY) - "n번째 요일"
- D1) 매 N개월마다, 매월 {k}번째 {weekday}
  - RRULE: FREQ=MONTHLY;INTERVAL={n};BYDAY={MO..SU};BYSETPOS={1..4,-1,-2};(COUNT|UNTIL)
  - 예: FREQ=MONTHLY;BYDAY=MO;BYSETPOS=2;UNTIL=20200810T183000Z :contentReference[oaicite:12]{index=12}
  - 예(마지막/끝에서 두번째 주): BYSETPOS=-1 또는 -2 허용 :contentReference[oaicite:13]{index=13}

### E. 매년 반복 (YEARLY)
- E1) 매 N년마다, 특정 월/일
  - RRULE: FREQ=YEARLY;INTERVAL={n};BYMONTH={1..12};BYMONTHDAY={1..31};(COUNT|UNTIL)
  - 예: FREQ=YEARLY;BYMONTHDAY=16;BYMONTH=6;INTERVAL=1;COUNT=10 :contentReference[oaicite:14]{index=14}

---

## 서버 저장/검증 정책(v1)
- 허용 키: FREQ, INTERVAL, COUNT, UNTIL, BYDAY, BYMONTHDAY, BYMONTH, BYSETPOS만.
- FREQ별 필수/금지:
  - DAILY: BYDAY/BYMONTHDAY/BYMONTH/BYSETPOS 금지
  - WEEKLY: BYDAY 필수, BYMONTHDAY/BYMONTH/BYSETPOS 금지
  - MONTHLY(날짜고정): BYMONTHDAY 필수, BYDAY/BYSETPOS 금지
  - MONTHLY(n번째 요일): BYDAY+BYSETPOS 필수, BYMONTHDAY 금지
  - YEARLY: BYMONTH+BYMONTHDAY 필수
- 종료 조건: COUNT xor UNTIL (둘 중 하나 또는 둘 다 없음=무기한 허용 여부는 제품 정책으로 결정)
- UNTIL 포맷:
  - 입력 수용: YYYYMMDD 또는 YYYYMMDDTHHMMSSZ :contentReference[oaicite:15]{index=15}
  - 저장 표준(권장): 항상 YYYYMMDDTHHMMSSZ 로 정규화

---

## 웹앱 구현 권장(중요)
- RRULE 생성은 가능한 한 Syncfusion의 SfCalendar.generateRRule(RecurrenceProperties 기반)로 만들고,
  서버에는 생성된 문자열을 그대로 저장한다. :contentReference[oaicite:16]{index=16}
- RRULE 파싱은 SfCalendar.parseRRule로 UI 폼에 역매핑한다. :contentReference[oaicite:17]{index=17}
