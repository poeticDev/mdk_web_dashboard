/// ROLE
/// - 유저 디렉터리 provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - UserDirectoryReadRepository provider를 제공한다
/// - 유저 검색 유즈케이스 provider를 제공한다
///
/// DEPENDS ON
/// - get_it
/// - user_directory_read_repository
/// - search_users_usecase
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/auth/application/usecases/search_users_usecase.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/user_directory_read_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// 유저 디렉터리 검색 전용 Provider 모음.
final Provider<UserDirectoryReadRepository> userDirectoryReadRepositoryProvider =
    Provider<UserDirectoryReadRepository>(
  (Ref ref) => di<UserDirectoryReadRepository>(),
);

/// 유저 검색 유스케이스 Provider.
final Provider<SearchUsersUseCase> searchUsersUseCaseProvider =
    Provider<SearchUsersUseCase>(
  (Ref ref) => SearchUsersUseCase(
    ref.watch(userDirectoryReadRepositoryProvider),
  ),
);
