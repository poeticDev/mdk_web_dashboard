import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';

/// 유저 디렉터리 검색을 위한 도메인 리포지토리 계약.
abstract class UserDirectoryRepository {
  Future<EntitySearchResult<UserDirectoryEntity>> searchUsers(
    EntitySearchQuery query,
  );
}
