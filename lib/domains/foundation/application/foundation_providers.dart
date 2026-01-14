/// ROLE
/// - provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 의존성을 주입한다
///
/// DEPENDS ON
/// - flutter_riverpod
/// - fetch_departments_by_ids_usecase
/// - search_departments_usecase
/// - department_directory_read_repository
/// - service_locator
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/foundation/application/usecases/fetch_departments_by_ids_usecase.dart';
import 'package:web_dashboard/domains/foundation/application/usecases/search_departments_usecase.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_read_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// 학과 디렉터리 관련 리포지토리/유스케이스 Provider 모음.
final Provider<DepartmentDirectoryReadRepository>
    departmentDirectoryReadRepositoryProvider =
    Provider<DepartmentDirectoryReadRepository>(
  (Ref ref) => di<DepartmentDirectoryReadRepository>(),
);

/// 학과 검색 유스케이스 Provider.
final Provider<SearchDepartmentsUseCase> searchDepartmentsUseCaseProvider =
    Provider<SearchDepartmentsUseCase>(
  (Ref ref) => SearchDepartmentsUseCase(
    ref.watch(departmentDirectoryReadRepositoryProvider),
  ),
);

/// 학과 ID 배치 조회 유스케이스 Provider.
final Provider<FetchDepartmentsByIdsUseCase>
    fetchDepartmentsByIdsUseCaseProvider =
    Provider<FetchDepartmentsByIdsUseCase>(
  (Ref ref) => FetchDepartmentsByIdsUseCase(
    ref.watch(departmentDirectoryReadRepositoryProvider),
  ),
);
