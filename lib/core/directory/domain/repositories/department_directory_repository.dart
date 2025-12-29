import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';

abstract class DepartmentDirectoryRepository {
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  );

  Future<List<DepartmentDirectoryEntity>> fetchByIds(List<String> ids);
}
