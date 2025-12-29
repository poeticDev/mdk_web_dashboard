import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/directory/application/usecases/fetch_departments_by_ids_usecase.dart';
import 'package:web_dashboard/core/directory/application/usecases/search_departments_usecase.dart';
import 'package:web_dashboard/core/directory/application/usecases/search_users_usecase.dart';
import 'package:web_dashboard/core/directory/domain/repositories/department_directory_repository.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// 학과 디렉터리 리포지토리 인스턴스를 노출하는 Provider.
final Provider<DepartmentDirectoryRepository>
    departmentDirectoryRepositoryProvider =
    Provider<DepartmentDirectoryRepository>(
  (Ref ref) => di<DepartmentDirectoryRepository>(),
);

/// 유저 디렉터리 리포지토리를 노출하는 Provider.
final Provider<UserDirectoryRepository> userDirectoryRepositoryProvider =
    Provider<UserDirectoryRepository>(
  (Ref ref) => di<UserDirectoryRepository>(),
);

/// 학과 검색 유스케이스 Provider.
final Provider<SearchDepartmentsUseCase> searchDepartmentsUseCaseProvider =
    Provider<SearchDepartmentsUseCase>(
  (Ref ref) => SearchDepartmentsUseCase(
    ref.watch(departmentDirectoryRepositoryProvider),
  ),
);

/// 학과 ID 배치 조회 유스케이스 Provider.
final Provider<FetchDepartmentsByIdsUseCase>
    fetchDepartmentsByIdsUseCaseProvider =
    Provider<FetchDepartmentsByIdsUseCase>(
  (Ref ref) => FetchDepartmentsByIdsUseCase(
    ref.watch(departmentDirectoryRepositoryProvider),
  ),
);

/// 유저 검색 유스케이스 Provider.
final Provider<SearchUsersUseCase> searchUsersUseCaseProvider =
    Provider<SearchUsersUseCase>(
  (Ref ref) => SearchUsersUseCase(
    ref.watch(userDirectoryRepositoryProvider),
  ),
);
