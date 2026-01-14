/// ROLE
/// - Foundation 기준 강의실 목록 요청 DTO를 정의한다
///
/// RESPONSIBILITY
/// - 요청 경로 파라미터를 모델링한다
///
/// DEPENDS ON
/// - 없음
library;

class FoundationClassroomsRequest {
  const FoundationClassroomsRequest({
    required this.foundationType,
    required this.foundationId,
  });

  final String foundationType;
  final String foundationId;
}
