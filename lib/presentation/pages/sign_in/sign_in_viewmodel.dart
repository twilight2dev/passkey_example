import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/source/remote/request/init_authenticate_request.dart';
import 'package:passkey_example/presentation/pages/sign_in/sign_in_state.dart';
import 'package:passkey_example/common/services/passkey_service.dart';

final signinVMProvider = StateNotifierProvider<SigninViewModel, SigninState>((ref) {
  return SigninViewModel(
    ref.watch(passkeyServiceProvider),
  );
});

class SigninViewModel extends StateNotifier<SigninState> {
  SigninViewModel(this._passkeyService) : super(SigninState());

  final PasskeyServiceProvider _passkeyService;
  final InitAuthenticateRequest _initRequest = InitAuthenticateRequest(username: "");

  void updateUserName(String? value) {
    _initRequest.username = value ?? _initRequest.username;
  }

  Future<void> login() async {
    state = state.copyWith(status: SigninStatus.loading);
    final result = await _passkeyService.authenticate(_initRequest);
    if (result) {
      state = state.copyWith(status: SigninStatus.success);
    } else {
      state = state.copyWith(status: SigninStatus.failure);
    }
  }
}
