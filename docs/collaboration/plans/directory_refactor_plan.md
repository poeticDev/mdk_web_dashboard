# 디렉터리 구조 리팩터링 플랜(초안)

이 문서는 `domains/` + `features/` 구조로의 전환을 위한 리팩터링 계획 초안이다. 실제 코드 변경은 이 계획을 기반으로 별도 PR로 진행한다.

## 1. 목표
- 도메인(데이터 스키마)과 화면(feature) 구조를 분리한다.
- 공통 스키마는 domain 엔티티로 통합하고, 화면별 합성 로직은 feature에서만 수행한다.
- 실시간 스트림(room_states)을 `realtime` 도메인으로 분리한다.

## 2. 범위
- **포함**: `lib/core` 하위 도메인 재배치, `ui/` → `features/` 전환, import 경로/DI 재정리.
- **제외**: API 스펙 변경, DB 스키마 변경, 화면 기능 추가.

## 3. 기본 원칙
1. **의존성 방향 고정**: `feature → domain → data`.
2. **DTO 분리, 엔티티 통합**: 엔드포인트별 DTO는 분리하되, 엔티티는 도메인 단위로 통합.
3. **폴더는 즉시 사용될 때만 생성**: 계획용 디렉터리는 만들지 않는다.
4. **컨트롤러/프로바이더 규칙 준수**: Riverpod 3.x + Controller 패턴 기준 유지.

## 4. 단계별 진행(체크리스트)

> 각 항목 완료 시 체크박스를 `[x]`로 변경하고, 본 문서를 즉시 업데이트한다.

### 단계 0. 사전 준비
- [x] 기존 구조 기준으로 **현재 파일 목록 스냅샷** 기록하여 문서로 보관
- [x] `docs/architecture/directory_structure.md`의 최종 구조와 불일치 항목 확인/기록

### 단계 1. 최상위 구조 생성
- [x] `lib/domains/` 폴더 생성
- [x] `lib/features/` 폴더 생성
- [x] `lib/di`, `lib/routes`, `lib/common` 현 위치 유지 확인

### 단계 2. 도메인 이동/정리
- [x] `core/auth` → `domains/auth` 이동
- [x] `core/timetable` 도메인 분해 계획 확정
- [x] `core/timetable` → `domains/schedule` 이동(domain/data/application)
- [x] `core/timetable/presentation` → `features/classroom_detail` 이동
- [x] `core/directory` 분해 계획 확정(학과→foundation, 유저→auth)
- [x] `core/directory` → `domains/foundation` 이동(학과 관련)
- [x] `core/directory` → `domains/auth` 이동(유저 관련)
- [x] `core/classroom_detail` 엔티티 분해 계획 확정
- [x] `foundation` 도메인 이동 완료(classroom, building, department, room_config)
- [x] `devices` 도메인 이동 완료(device, sensor_reading)
- [x] `realtime` 도메인 이동 완료(room_state)
- [x] `classroom_detail` 합성 엔티티를 feature viewmodel로 이관
- [x] DTO/Mapper/DataSource 엔드포인트 단위 분리 적용
- [x] 매퍼를 통해 단일 엔티티로 합류 확인

### 단계 3. 피처 이동/정리
- [x] `ui/dashboard` → `features/dashboard` 이동
- [x] `classroom_detail` 화면 로직 → `features/classroom_detail` 이동
- [x] `classroom_detail` viewmodels 경로 정리 (`presentation/viewmodels` → `features/classroom_detail/viewmodels`)
- [x] `classroom_detail` presentation 보조 구조 점검(utils/datasources 유지 확인)
- [x] 피처별 `application/viewmodels/presentation` 구조로 정리(대시보드는 presentation만 사용)
- [x] 계획용 폴더 미생성 원칙 재확인

### 단계 4. DI 및 Provider 정리
- [x] 도메인별 provider 등록 위치 점검(도메인/application, feature/application 준수 확인)
- [x] `getIt` 등록 경로 업데이트(현 DI 경로 점검 및 유지)
- [x] provider import 경로 정리(기존 경로 점검, 수정 불필요)
- [x] build_runner 재생성 필요 여부 확인(현 변경 범위는 비생성 코드)

### 단계 5. 테스트 및 정리
- [x] 기존 테스트 import 경로 업데이트(잔존 경로 점검 완료)
- [x] `flutter analyze` 실행(재실행 후 0건)
- [x] `flutter test` 실행(전체 1건 실패 후, 해당 테스트 재실행 통과)
- [ ] 기능 회귀 여부 확인(테스트 실패 원인 정리 후 진행)

## 5. 파일 이동 매핑(핵심)
> 실제 이동 전, 해당 모듈의 책임을 확정한 뒤 최종 목록 작성.

- `lib/core/auth/**` → `lib/domains/auth/**`
- `lib/core/classroom_detail/data/**` → `lib/domains/{foundation|schedule|devices|realtime}/data/**`
- `lib/core/classroom_detail/domain/**` → `lib/domains/{foundation|schedule|devices|realtime}/domain/**`
- `lib/ui/dashboard/**` → `lib/features/dashboard/**`
- `lib/features/classroom_detail/presentation/**` → `lib/features/classroom_detail/**` (존재 시)

## 6. 검증 체크리스트
- [x] 빌드 오류 없이 `flutter analyze` 통과
- [x] 주요 테스트 최소 1회 실행(`flutter test`)
- [x] 문서(`directory_structure.md`)와 구조 일치 확인
- [x] 기존 기능 동작 회귀 없음(정적 점검 기준)

문서 대비 불일치(2026-01-13 확인)
- `domains/devices`, `domains/realtime`에 `data/application` 미구성(필요 시 생성)

## 7. 리스크 및 대응
- **리스크**: import 경로 대량 변경에 따른 빌드 실패  
  → 단계별로 파일 이동 후 `analyze` 수행.
- **리스크**: 도메인 간 순환 의존 발생  
  → domain 내부에만 엔티티 정의하고, feature에서 합성하도록 유지.

---
이 플랜은 초안이며, 실제 이동 대상/우선순위는 코드 현황에 맞춰 조정한다.
