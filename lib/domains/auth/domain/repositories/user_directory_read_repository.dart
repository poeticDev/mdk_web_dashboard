/// ROLE
/// - 유저 디렉터리 검색 리포지토리 계약을 정의한다
///
/// RESPONSIBILITY
/// - 유저 검색 API 인터페이스를 제공한다
///
/// DEPENDS ON
/// - entity_search_query
/// - entity_search_result
library;

import 'package:web_dashboard/domains/auth/domain/entities/user_directory_entity.dart';
import 'package:web_dashboard/common/search/entity_search_query.dart';
import 'package:web_dashboard/common/search/entity_search_result.dart';

/// 유저 디렉터리 검색을 위한 도메인 리포지토리 계약.
abstract class UserDirectoryReadRepository {
  Future<EntitySearchResult<UserDirectoryEntity>> searchUsers(
    EntitySearchQuery query,
  );
}
