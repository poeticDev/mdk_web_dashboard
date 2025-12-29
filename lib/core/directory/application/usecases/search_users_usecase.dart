import 'package:web_dashboard/core/directory/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';

/// 유저 검색 요청을 캡슐화하는 유스케이스.
class SearchUsersUseCase {
  const SearchUsersUseCase(this._repository);

  final UserDirectoryRepository _repository;

  Future<EntitySearchResult<UserDirectoryEntity>> execute(
    EntitySearchQuery query,
  ) {
    return _repository.searchUsers(query);
  }
}
