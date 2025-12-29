import 'package:flutter/foundation.dart';

/// 검색 대상 타입을 구분하는 열거형.
enum EntitySearchType { department, user }

/// 검색 family Provider에 전달되는 파라미터 집합.
@immutable
class EntitySearchArgs {
  const EntitySearchArgs({
    required this.type,
    this.limit = 20,
    this.initialQuery,
    this.initialSelection,
  });

  final EntitySearchType type;
  final int limit;
  final String? initialQuery;
  final String? initialSelection;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is EntitySearchArgs &&
        other.type == type &&
        other.limit == limit &&
        other.initialQuery == initialQuery &&
        other.initialSelection == initialSelection;
  }

  @override
  int get hashCode =>
      Object.hash(type, limit, initialQuery, initialSelection);
}
