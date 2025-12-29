import 'package:web_dashboard/core/directory/domain/entities/department_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/repositories/department_directory_repository.dart';

class FetchDepartmentsByIdsUseCase {
  const FetchDepartmentsByIdsUseCase(this._repository);

  final DepartmentDirectoryRepository _repository;

  Future<List<DepartmentDirectoryEntity>> execute(List<String> ids) {
    return _repository.fetchByIds(ids);
  }
}
