// ignore_for_file: sdk_version_since

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/repository/base/base_repository.dart';
import 'package:passkey_example/data/repository/base/repo_result.dart';
import 'package:passkey_example/data/source/remote/request/complete_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/complete_register_request.dart';
import 'package:passkey_example/data/source/remote/request/init_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/init_register_request.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_register_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_register_response.dart';
import 'package:passkey_example/data/source/remote/services/auth_service.dart';

class AuthRepository extends BaseRepository {
  @override
  final Ref ref;
  final AuthService authService;

  AuthRepository({required this.authService, required this.ref});

  Future<RepoResult<InitRegisterResponseData?>> initRegister(InitRegisterRequest param) async {
    return safeCallApi(authService.initRegister(param), autoHandleError: false);
  }

  Future<RepoResult<CompleteRegisterResponseData?>> completeRegister(CompleteRegisterRequest param) async {
    return safeCallApi(authService.completeRegister(param), autoHandleError: false);
  }

  Future<RepoResult<InitAuthenticateResponseData?>> initAuthenticate(InitAuthenticateRequest param) async {
    return safeCallApi(authService.initAuthenticate(param), autoHandleError: false);
  }

  Future<RepoResult<CompleteAuthenticateResponseData?>> completeAuthenticate(CompleteAuthenticateRequest param) async {
    return safeCallApi(authService.completeAuthenticate(param), autoHandleError: false);
  }
}
