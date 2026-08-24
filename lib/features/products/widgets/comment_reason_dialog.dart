import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Asks for the sentence that will be signed along with the decision.
///
/// Withdrawing your own comment and screening someone else's are different
/// acts, but both end up inside a signed envelope, so both are asked the same
/// way: a reason of at least five characters, or no decision at all.
class CommentReasonDialog extends StatefulWidget {
  final String title;
  final String hint;

  const CommentReasonDialog({
    super.key,
    required this.title,
    required this.hint,
  });

  /// Returns the trimmed reason, or null when the user backs out.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String hint,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => CommentReasonDialog(title: title, hint: hint),
    );
  }

  @override
  State<CommentReasonDialog> createState() => _CommentReasonDialogState();
}

class _CommentReasonDialogState extends State<CommentReasonDialog> {
  static const minReason = 5;

  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ready = _reason.text.trim().length >= minReason;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _reason,
            autofocus: true,
            maxLength: 200,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.sellerCommentsReasonLabel,
              hintText: widget.hint,
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.changeReasonExplainer,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: ready
              ? () => Navigator.of(context).pop(_reason.text.trim())
              : null,
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }
}
