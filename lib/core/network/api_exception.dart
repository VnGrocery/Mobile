class ApiException implements Exception {
  final int statusCode;
  final String message;

  /// How long until the caller may retry, on a 429.
  ///
  /// Carried on the exception rather than re-read at each screen: "too many
  /// requests" alone leaves someone tapping the button every few seconds, and
  /// the wait is the only part of the answer they can act on.
  final int? retryAfterMinutes;

  const ApiException(this.statusCode, this.message, {this.retryAfterMinutes});

  @override
  String toString() => message;
}
