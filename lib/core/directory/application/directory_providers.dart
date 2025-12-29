import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/directory/application/usecases/fetch_departments_by_ids_usecase.dart';
import 'package:web_dashboard/core/directory/application/usecases/search_departments_usecase.dart';
import 'package:web_dashboard/core/directory/application/usecases/search_users_usecase.dart';
import 'package:web_dashboard/core/directory/domain/repositories/department_directory_repository.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

final Provider<DepartmentDirectoryRepository>
    departmentDirectoryRepositoryProvider =
    Provider<DepartmentDirectoryRepository>(
  (Ref ref) => di<DepartmentDirectoryRepository>(),
);

final Provider<UserDirectoryRepository> userDirectoryRepositoryProvider =
    Provider<UserDirectoryRepository>(
  (Ref ref) => di<UserDirectoryRepository>(),
);

final Provider<SearchDepartmentsUseCase> searchDepartmentsUseCaseProvider =
    Provider<SearchDepartmentsUseCase>(
  (Ref ref) => SearchDepartmentsUseCase(
    ref.watch(departmentDirectoryRepositoryProvider),
  ),
);

final Provider<FetchDepartmentsByIdsUseCase>
    fetchDepartmentsByIdsUseCaseProvider =
    Provider<FetchDepartmentsByIdsUseCase>(
  (Ref ref) => FetchDepartmentsByIdsUseCase(
    ref.watch(departmentDirectoryRepositoryProvider),
  ),
);

final Provider<SearchUsersUseCase> searchUsersUseCaseProvider =
    Provider<SearchUsersUseCase>(
  (Ref ref) => SearchUsersUseCase(
    ref.watch(userDirectoryRepositoryProvider),
  ),
);
