import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/foundation/application/usecases/fetch_departments_by_ids_usecase.dart';
import 'package:web_dashboard/domains/foundation/application/usecases/search_departments_usecase.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// 학과 디렉터리 관련 리포지토리/유스케이스 Provider 모음.
final Provider<DepartmentDirectoryRepository>
    departmentDirectoryRepositoryProvider =
    Provider<DepartmentDirectoryRepository>(
  (Ref ref) => di<DepartmentDirectoryRepository>(),
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
