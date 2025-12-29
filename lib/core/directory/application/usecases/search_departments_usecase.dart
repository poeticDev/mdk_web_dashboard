import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';
import 'package:web_dashboard/core/directory/domain/repositories/department_directory_repository.dart';

class SearchDepartmentsUseCase {
  const SearchDepartmentsUseCase(this._repository);

  final DepartmentDirectoryRepository _repository;

  Future<EntitySearchResult<DepartmentDirectoryEntity>> execute(
    EntitySearchQuery query,
  ) {
    return _repository.searchDepartments(query);
  }
}
