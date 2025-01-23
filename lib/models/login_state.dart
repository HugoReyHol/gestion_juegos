class LoginState {
  bool isLoading;
  String? errorMsg;

  LoginState({this.isLoading = false, this.errorMsg});

  LoginState copyWith({bool? isLoading, String? errorMsg}) {
    this.isLoading = isLoading ?? false;
    this.errorMsg = errorMsg;

    return LoginState(isLoading: isLoading ?? false, errorMsg: errorMsg);
  }
}