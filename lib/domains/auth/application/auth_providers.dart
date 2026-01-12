import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (Ref ref) => di<AuthRepository>(),
);
