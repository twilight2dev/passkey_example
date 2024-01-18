import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/repository/auth_repository.dart';
import 'package:passkey_example/data/source/remote/services/services.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref: ref, authService: ref.watch(authServiceProvider)),
);
