import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

class ClassroomDetailParams {
  const ClassroomDetailParams({required this.classroomId});

  final String classroomId;
}

final Provider<ClassroomDetailParams> classroomDetailParamsProvider =
    Provider<ClassroomDetailParams>(
  (Ref ref) => throw UnimplementedError('ClassroomDetailParams must be overridden'),
);

final Provider<ClassroomDetailRepository> classroomDetailRepositoryProvider =
    Provider<ClassroomDetailRepository>(
  (Ref ref) => di<ClassroomDetailRepository>(),
);
