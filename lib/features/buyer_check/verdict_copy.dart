import 'package:vngrocery/l10n/app_localizations.dart';

/// Turns the server's verdict codes into Vietnamese.
///
/// The codes are `trusted`, `warning`, `high_risk` and `no_pledge`. They used
/// to be printed raw - "Kết quả: no_pledge" - which is server vocabulary
/// leaking onto a screen a shopper reads at a stall. An unknown code says
/// "chưa rõ" rather than showing itself.
class VerdictCopy {
  const VerdictCopy._();

  static String label(AppLocalizations l10n, String verdict) =>
      switch (verdict.trim()) {
        'trusted' => l10n.verdictTrusted,
        'warning' => l10n.verdictWarning,
        'high_risk' => l10n.verdictHighRisk,
        'no_pledge' => l10n.verdictNoPledge,
        _ => l10n.verdictUnknown,
      };
}
