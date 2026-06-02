import 'package:email_validator/email_validator.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // Phone validation (just format, no real check)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Remove non-digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 9) {
      return 'Phone number must be at least 9 digits';
    }
    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }
    return null;
  }

  // Date validation (DD/MM/YYYY format)
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    final regex = RegExp(r'^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[012])/\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Date must be in DD/MM/YYYY format';
    }

    try {
      final parts = value.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      if (date.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      final age = DateTime.now().year - year;
      if (age < 13) {
        return 'You must be at least 13 years old';
      }
    } catch (e) {
      return 'Invalid date';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }
    return null;
  }

  // Confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
