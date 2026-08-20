class QrLabelState {
  final String pledgeId;
  final String clipboardText;

  /// The bundleToken the QR encodes. Empty when the seller opened the label
  /// without a fresh commit in this session, in which case there is nothing to
  /// print.
  final String bundleToken;

  final String bundleId;

  const QrLabelState({
    required this.pledgeId,
    required this.clipboardText,
    this.bundleToken = '',
    this.bundleId = '',
  });

  bool get hasToken => bundleToken.isNotEmpty;
}
