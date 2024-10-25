class SignupEmailPasswordFailure {
  final String message;

  const SignupEmailPasswordFailure(
      [this.message = "An Unknown error occured."]);

  factory SignupEmailPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupEmailPasswordFailure(
            'Please enter a stronger password.');

      case 'invalid-email':
        return const SignupEmailPasswordFailure('Email is not valid.');

      case 'email-already-in-use':
        return const SignupEmailPasswordFailure('The email already exists.');

      case 'operation-not-allowed':
        return const SignupEmailPasswordFailure(
            'Operation is not allowed. Please contact support.');

      case 'user-disabled':
        return const SignupEmailPasswordFailure(
            'This user has been disabled. Please contact support.');

      default:
        return const SignupEmailPasswordFailure();
    }
  }
}
