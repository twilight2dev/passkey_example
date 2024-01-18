enum SigninStatus { initial, loading, failure, success }

class SigninState {
  SigninState({
    this.status = SigninStatus.initial,
  });

  final SigninStatus status;

  SigninState copyWith({
    SigninStatus? status,
  }) {
    return SigninState(
      status: status ?? this.status,
    );
  }
}
