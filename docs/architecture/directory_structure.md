# Directory Structure (Target)

이 문서는 `web_dashboard`의 **최종 구현안 기준 디렉터리 구조**를 정리한다. 기능(feature)과 데이터 스키마(domain)를 분리하고, 데이터는 domain에서 정의·관리하며 feature는 이를 합성해 화면을 구성한다.

## 1. 상위 레이아웃 요약

```
web_dashboard/
├── lib/
│   ├── common/
│   ├── di/
│   ├── routes/
│   ├── domains/
│   └── features/
├── assets/
├── docs/
├── test/
├── web/
└── 기타 설정 파일(pubspec.yaml 등)
```

## 2. lib/ 핵심 폴더

### lib/common
- 전역 재사용 리소스 집합(상수, 네트워크, 유틸, 테마 등).
- **도메인/피처와 독립적인 공용 모듈만 유지**한다.

### lib/di
- `getIt` 등록 지점.
- 서비스·리포지토리는 싱글톤, 컨트롤러는 레이지 싱글톤으로 등록한다.

### lib/routes
- 앱 라우팅 단일 소스.
- feature는 라우팅 정의에 직접 의존하지 않도록 유지한다.

## 3. domains 구조 (데이터 스키마/원천 중심)

```
lib/domains/
├── auth/
├── ops/
├── foundation/
├── realtime/
├── schedule/
├── devices/
└── contents/
```

각 도메인은 아래 기본 구조를 따른다.

```
<domain>/
  domain/
    entities/
    repositories/
  data/
    dtos/
    mappers/
    datasources/
    repositories_impl/
  application/
    controllers/
    providers/
```

### 도메인별 책임
- **auth**: 사용자/세션 도메인.
- **ops**: 감사 로그 등 조회 중심 데이터.
- **foundation**: site/building/department/classroom/room_config 등 정적 기반 데이터.
- **realtime**: room_state 등 스트림 기반 실시간 데이터.
- **schedule**: lecture/lecture_occurrence 등 시간표 도메인.
- **devices**: device/sensor_reading 등 장비·센서 데이터.
- **contents**: media/message 등 콘텐츠 관리 데이터.

## 4. features 구조 (UI/화면 중심)

```
lib/features/
├── dashboard/
└── classroom_detail/
```

각 feature는 화면 중심으로 아래 구조를 따른다.

```
<feature>/
  application/
  viewmodels/
  presentation/
    pages/
    widgets/
```

### feature 책임 예시
- **dashboard**: foundation + schedule + devices + realtime을 합성한 대시보드 화면.
- **classroom_detail**: 단일 강의실에 대한 상세 화면(장비/상태/기간별 시간표).

> 필요할 때만 feature 폴더를 추가한다. 계획용 디렉터리는 만들지 않는다.

## 5. 설계 원칙 요약
1. **도메인 통합, 화면 분리**: 동일 스키마는 domain에서 단일 엔티티로 정의하고, 화면은 feature에서 조합한다.
2. **요청은 분리, 엔티티는 공유**: 엔드포인트가 달라도 DTO/데이터소스는 분리하고, 매퍼를 통해 동일 엔티티로 합류한다.
3. **의존성 방향 고정**: `feature → domain → data` 단방향을 유지한다.
4. **실시간 분리**: 스트림 기반 데이터는 `realtime` 도메인으로 분리해 책임을 명확히 한다.
