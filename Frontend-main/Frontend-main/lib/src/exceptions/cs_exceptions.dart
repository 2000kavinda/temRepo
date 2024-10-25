class CSExceptions implements Exception {
  final String message;

  const CSExceptions([this.message = 'An unknown exception occured.']);

  factory CSExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const CSExceptions('Email already exists.');
      case 'invalid-email':
        return const CSExceptions('Email is not valid or badly formatted.');
      case 'weak-password':
        return const CSExceptions('Please enter a strong password.');
      case 'user-disabled':
        return const CSExceptions(
            'This user has been disabled. Please contact support for help.');
      case 'user-not-found':
        return const CSExceptions('Invalid Details. Please create an account.');
      case 'wrong-password':
        return const CSExceptions('Incorrect password. Please try again.');
      case 'too-many-requests':
        return const CSExceptions(
            'Too many requests. Service temporarily blocked.');
      case 'invalid-argument':
        return const CSExceptions(
            'An invalid argument was provided to an Authentication method.');
      case 'invalid-password':
        return const CSExceptions('Invalid password. Please try again.');
      case 'invalid-phone-number':
        return const CSExceptions('Phone number is invalid.');
      case 'operation-not-allowed':
        return const CSExceptions(
            'The provided sign in provider is disabled for your Firebase project.');
      case 'session-cookie-expired':
        return const CSExceptions(
            'The provided Firebase session cookie is expired.');
      case 'uid-already-exits':
        return const CSExceptions('UID is already in use by an existing user.');
      default:
        return const CSExceptions('Email already exists.');
    }
  }
}
