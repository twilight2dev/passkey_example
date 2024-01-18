import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/repository/auth_repository.dart';
import 'package:passkey_example/data/repository/repository.dart';
import 'package:passkey_example/data/source/remote/request/complete_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/complete_register_request.dart';
import 'package:passkey_example/data/source/remote/request/init_authenticate_request.dart';
import 'package:passkey_example/data/source/remote/request/init_register_request.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/complete_register_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_authenticate_response.dart';
import 'package:passkey_example/data/source/remote/response/auth/init_register_response.dart';
import 'package:passkeys/authenticator.dart';

final passkeyServiceProvider = Provider<PasskeyServiceProvider>((ref) {
  return PasskeyServiceProvider(
    ref.watch(authRepositoryProvider),
  );
});

class PasskeyErrorType {
  
}

class PasskeyServiceProvider {
  PasskeyServiceProvider(this._authRepository);

  final AuthRepository _authRepository;
  final PasskeyAuthenticator _passkeyAuthenticator = PasskeyAuthenticator();

  /// *********************************************************************************
  ///                               Register
  /// *********************************************************************************

  Future<bool> register(InitRegisterRequest initRegisterRequest) async {
    final initRegisterResponse = await _initRegister(initRegisterRequest);
    if (initRegisterResponse != null) {
      try {
        final registerPasskeyRequest = initRegisterResponse.toRegisterPasskeyRequest();
        final registerPasskeyResponse = await _passkeyAuthenticator.register(registerPasskeyRequest);

        final completeRegisterRequest = CompleteRegisterRequest.fromRegisterPasskeyResponse(registerPasskeyResponse);
        final completeRegisterResponse = await _completeRegister(completeRegisterRequest);
        if (completeRegisterResponse != null) {
          return true;
        }
      } catch (e) {
        //
      }
    }
    return false;
  }

  Future<InitRegisterResponseData?> _initRegister(InitRegisterRequest request) async {
    InitRegisterResponseData? initRegisterResponse;
    final result = await _authRepository.initRegister(request);
    await result.when(
      success: (data) async => initRegisterResponse = data,
      failure: (error) => initRegisterResponse = null,
    );
    return initRegisterResponse;
  }

  Future<CompleteRegisterResponseData?> _completeRegister(CompleteRegisterRequest request) async {
    CompleteRegisterResponseData? completeRegisterResponse;
    final result = await _authRepository.completeRegister(request);
    await result.when(
      success: (data) async => completeRegisterResponse = data,
      failure: (error) => completeRegisterResponse = null,
    );
    return completeRegisterResponse;
  }

  /// *********************************************************************************
  ///                               Authenticate
  /// *********************************************************************************
  Future<bool> authenticate(InitAuthenticateRequest initAuthenticateRequest) async {
    final initAuthenticateResponseData = await _initAuthenticate(initAuthenticateRequest);
    if (initAuthenticateResponseData != null) {
      try {
        final authenticatePasskeyRequest = initAuthenticateResponseData.toAuthenticatePasskeyRequest();
        final authenticatePasskeyResponse = await _passkeyAuthenticator.authenticate(authenticatePasskeyRequest);

        final completeAuthenticateRequest =
            CompleteAuthenticateRequest.fromAuthenticatePasskeyResponse(authenticatePasskeyResponse);
        final completeAuthenticateResponse = await _completeAuthenticate(completeAuthenticateRequest);
        if (completeAuthenticateResponse != null) {
          return true;
        }
      } catch (e) {
        //
      }
    }
    return false;
  }

  Future<InitAuthenticateResponseData?> _initAuthenticate(InitAuthenticateRequest request) async {
    InitAuthenticateResponseData? initAuthenticateResponseData;
    final result = await _authRepository.initAuthenticate(request);
    await result.when(
      success: (data) async => initAuthenticateResponseData = data,
      failure: (error) => initAuthenticateResponseData = null,
    );
    return initAuthenticateResponseData;
  }

  Future<CompleteAuthenticateResponseData?> _completeAuthenticate(CompleteAuthenticateRequest request) async {
    CompleteAuthenticateResponseData? completeAuthenticateResponseData;
    final result = await _authRepository.completeAuthenticate(request);
    await result.when(
      success: (data) async => completeAuthenticateResponseData = data,
      failure: (error) => completeAuthenticateResponseData = null,
    );
    return completeAuthenticateResponseData;
  }
}
