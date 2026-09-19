class QrLabelState {
  final String pledgeId;

  /// The bundleToken the QR encodes. Empty when the seller opened the label
  /// without a fresh commit in this session, in which case there is nothing to
  /// print.
  final String bundleToken;

  final String bundleId;

  const QrLabelState({
    required this.pledgeId,
    this.bundleToken = '',
    this.bundleId = '',
  });

  bool get hasToken => bundleToken.isNotEmpty;

  /// Whether there is a label worth exporting.
  ///
  /// Keyed on the lot code, not the token: the printed label carries the code,
  /// and a pledge keeps its code long after its token has expired.
  bool get canPrint => bundleId.isNotEmpty;
}
