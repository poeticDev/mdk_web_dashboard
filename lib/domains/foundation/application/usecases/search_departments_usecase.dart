/// ROLE
/// - 유즈케이스를 제공한다
///
/// RESPONSIBILITY
/// - 도메인 요청을 실행한다
///
/// DEPENDS ON
/// - department_directory_entity
/// - entity_search_query
/// - entity_search_result
/// - department_directory_repository
library;

import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';

/// 학과 검색 리포지토리를 감싸 UI 계층에 제공하는 유스케이스.
class SearchDepartmentsUseCase {
  const SearchDepartmentsUseCase(this._repository);

  final DepartmentDirectoryRepository _repository;

  Future<EntitySearchResult<DepartmentDirectoryEntity>> execute(
    EntitySearchQuery query,
  ) {
    return _repository.searchDepartments(query);
  }
}
