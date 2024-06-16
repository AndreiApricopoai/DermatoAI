class InputValidators {
  static String? emailValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    RegExp emailRegex =
        RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? nameValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 2 || value.length > 50) {
      return 'Name must be between 2 and 50 characters';
    }
    RegExp nameRegex = RegExp(r'^[a-zA-Z]+([ \-][a-zA-Z]+)*$');
    if (!nameRegex.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 7) {
      return 'Password must be at least 7 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? verificationTokenValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the verification token';
    }
    return null;
  }

  static String? feedbackContentValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Content is required';
    }
    if (value.length < 10) {
      return 'Content must be at least 10 characters';
    }
    if (value.length > 1000) {
      return 'Content must be less than 1000 characters';
    }
    return null;
  }

  static String? predictionTitleValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Title cannot be empty';
    }
    if (value.length > 100) {
      return 'Title must be between 1 and 100 characters';
    }
    return null;
  }

  static String? predictionDescriptionValidator(String? value) {
    value = value?.trim();
    if (value != null && value.length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  static String? createConversationValidator(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length > 100) {
      return 'Title must be between 1 and 100 characters';
    }
    return null;
  }

  static String? updateConversationValidator(String? value) {
    value = value?.trim();
    if (value != null && value.isEmpty) {
      return 'Title cannot be empty';
    }
    if (value != null && value.length > 100) {
      return 'Title must be between 1 and 100 characters';
    }
    return null;
  }
}
