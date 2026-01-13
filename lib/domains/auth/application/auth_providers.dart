/// ROLE
/// - 인증 리포지토리 provider를 노출한다
///
/// RESPONSIBILITY
/// - AuthRepository 의존성을 주입한다
///
/// DEPENDS ON
/// - get_it
/// - auth_repository
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (Ref ref) => di<AuthRepository>(),
);
