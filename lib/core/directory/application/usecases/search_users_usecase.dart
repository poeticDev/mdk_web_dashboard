import 'package:web_dashboard/core/directory/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_query.dart';
import 'package:web_dashboard/core/directory/domain/models/entity_search_result.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';

class SearchUsersUseCase {
  const SearchUsersUseCase(this._repository);

  final UserDirectoryRepository _repository;

  Future<EntitySearchResult<UserDirectoryEntity>> execute(
    EntitySearchQuery query,
  ) {
    return _repository.searchUsers(query);
  }
}
