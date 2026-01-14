/// ROLE
/// - 도메인 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 데이터 접근 인터페이스를 제공한다
///
/// DEPENDS ON
/// - department_directory_entity
/// - entity_search_query
/// - entity_search_result
library;

import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';

/// 학과 디렉터리 검색/배치 조회 계약을 정의하는 리포지토리 인터페이스.
abstract class DepartmentDirectoryReadRepository {
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  );

  Future<List<DepartmentDirectoryEntity>> fetchByIds(List<String> ids);
}
