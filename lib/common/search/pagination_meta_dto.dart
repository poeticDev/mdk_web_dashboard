/// API에서 내려주는 meta 필드를 그대로 역직렬화하는 DTO.
class PaginationMetaDto {
  const PaginationMetaDto({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasPrev,
    required this.hasNext,
  });

  factory PaginationMetaDto.fromJson(Map<String, Object?> json) {
    return PaginationMetaDto(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      hasPrev: json['hasPrev'] as bool? ?? false,
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasPrev;
  final bool hasNext;
}

/// items + meta 구조를 한 번에 파싱하기 위한 래퍼.
class PaginatedResponseDto<T> {
  const PaginatedResponseDto({required this.items, required this.meta});

  factory PaginatedResponseDto.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, Object?> json) mapper,
  ) {
    final List<T> parsedItems = (json['items'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, Object?>>()
        .map(mapper)
        .toList();
    final Map<String, Object?> metaJson =
        json['meta'] as Map<String, Object?>? ?? <String, Object?>{};
    return PaginatedResponseDto<T>(
      items: parsedItems,
      meta: PaginationMetaDto.fromJson(metaJson),
    );
  }

  final List<T> items;
  final PaginationMetaDto meta;
}
