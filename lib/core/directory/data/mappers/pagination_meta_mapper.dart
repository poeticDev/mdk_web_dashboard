import 'package:web_dashboard/core/directory/data/dtos/pagination_meta_dto.dart';
import 'package:web_dashboard/core/directory/domain/models/pagination_meta.dart';

/// API meta DTO를 앱 내부 `PaginationMeta`로 치환하는 매퍼.
class PaginationMetaMapper {
  const PaginationMetaMapper();

  PaginationMeta toEntity(PaginationMetaDto dto) {
    return PaginationMeta(
      page: dto.page,
      limit: dto.limit,
      total: dto.total,
      totalPages: dto.totalPages,
      hasPrev: dto.hasPrev,
      hasNext: dto.hasNext,
    );
  }
}
