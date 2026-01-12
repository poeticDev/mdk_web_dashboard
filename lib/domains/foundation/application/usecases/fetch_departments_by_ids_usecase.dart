import 'package:web_dashboard/domains/foundation/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';

/// 학과 ID 컬렉션을 일괄 조회하는 유스케이스.
class FetchDepartmentsByIdsUseCase {
  const FetchDepartmentsByIdsUseCase(this._repository);

  final DepartmentDirectoryRepository _repository;

  Future<List<DepartmentDirectoryEntity>> execute(List<String> ids) {
    return _repository.fetchByIds(ids);
  }
}
