import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/source/remote/api_client.dart';
import 'package:passkey_example/data/source/remote/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService(ref.watch(apiV1ClientProvider).dio));
