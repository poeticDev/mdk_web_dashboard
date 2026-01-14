/// ROLE
/// - 유저 검색 유즈케이스를 구현한다
///
/// RESPONSIBILITY
/// - 검색 요청을 리포지토리에 위임한다
///
/// DEPENDS ON
/// - user_directory_read_repository
/// - entity_search_query
library;

import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/user_directory_read_repository.dart';

/// 유저 검색 요청을 캡슐화하는 유스케이스.
class SearchUsersUseCase {
  const SearchUsersUseCase(this._repository);

  final UserDirectoryReadRepository _repository;

  Future<EntitySearchResult<UserDirectoryEntity>> execute(
    EntitySearchQuery query,
  ) {
    return _repository.searchUsers(query);
  }
}
