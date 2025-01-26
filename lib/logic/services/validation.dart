class Validation {
  /// Validate inputs

  /// Ensure grid tile is not empty
  String? validateTitle(String value) {
    if (value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  /// Ensure password is valid
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Ensure email is valid
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Email is invalid';
    } else if (!value.contains('.')) {
      return 'Email is invalid';
    }
    return null;
  }

  /// Ensure name is not empty
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }
}
