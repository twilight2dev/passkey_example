enum SignupStatus { initial, loading, failure, success }

class SignupState {
  SignupState({
    this.status = SignupStatus.initial,
  });

  final SignupStatus status;

  SignupState copyWith({
    SignupStatus? status,
  }) {
    return SignupState(
      status: status ?? this.status,
    );
  }
}
