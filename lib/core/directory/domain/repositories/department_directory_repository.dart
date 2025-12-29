import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';

/// 학과 디렉터리 검색/배치 조회 계약을 정의하는 리포지토리 인터페이스.
abstract class DepartmentDirectoryRepository {
  Future<EntitySearchResult<DepartmentDirectoryEntity>> searchDepartments(
    EntitySearchQuery query,
  );

  Future<List<DepartmentDirectoryEntity>> fetchByIds(List<String> ids);
}
