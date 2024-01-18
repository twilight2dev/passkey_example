import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passkey_example/data/source/remote/request/init_register_request.dart';
import 'package:passkey_example/presentation/pages/sign_up/sign_up_state.dart';
import 'package:passkey_example/common/services/passkey_service.dart';

final signupVMProvider = StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  return SignupViewModel(
    ref.watch(passkeyServiceProvider),
  );
});

class SignupViewModel extends StateNotifier<SignupState> {
  SignupViewModel(this._passkeyService) : super(SignupState());

  final PasskeyServiceProvider _passkeyService;
  final InitRegisterRequest _initRequest = InitRegisterRequest(username: "");

  void updateUserName(String? value) {
    _initRequest.username = value ?? _initRequest.username;
  }

  Future<void> signUp() async {
    state = state.copyWith(status: SignupStatus.loading);
    final result = await _passkeyService.register(_initRequest);
    if (result) {
      state = state.copyWith(status: SignupStatus.success);
    } else {
      state = state.copyWith(status: SignupStatus.failure);
    }
  }
}
