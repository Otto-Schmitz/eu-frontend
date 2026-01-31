/// User-friendly error messages. No raw API errors exposed.
library;

/// Maps API errors to friendly messages for the user.
class ApiErrorMapper {
  ApiErrorMapper._();

  static String fromException(Object e) {
    final str = e.toString().toLowerCase();
    if (str.contains('401') || str.contains('session expired')) {
      return 'Session expired. Please sign in again.';
    }
    if (str.contains('400') || str.contains('invalid')) {
      return 'Invalid request. Please check your input.';
    }
    if (str.contains('403') || str.contains('forbidden')) {
      return 'Access denied.';
    }
    if (str.contains('404') || str.contains('not found')) {
      return 'Not found.';
    }
    if (str.contains('409') || str.contains('already exists')) {
      return 'An account with this email already exists.';
    }
    if (str.contains('422') || str.contains('validation')) {
      return 'Please check your input and try again.';
    }
    if (str.contains('500') || str.contains('server')) {
      return 'Server error. Please try again later.';
    }
    if (str.contains('socket') ||
        str.contains('connection') ||
        str.contains('network') ||
        str.contains('timeout')) {
      return 'Unable to connect. Please check your network.';
    }
    return 'Something went wrong. Please try again.';
  }

  static String fromStatusCode(int? code) {
    switch (code) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Session expired. Please sign in again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Not found.';
      case 409:
        return 'This resource already exists.';
      case 422:
        return 'Please check your input and try again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
