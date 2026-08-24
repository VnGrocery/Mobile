import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Asks for the sentence that will be signed along with the change.
///
/// Editing a product, hiding it, screening a comment and withdrawing your own
/// are different acts, but every one of them ends up inside a signed envelope
/// that nobody can rewrite afterwards. So every one of them is asked the same
/// way: a reason of at least five characters, or no change at all.
class ChangeReasonDialog extends StatefulWidget {
  final String title;
  final String hint;

  /// Defaults to "Lý do thay đổi". Moderation passes its own wording.
  final String? label;

  const ChangeReasonDialog({
    super.key,
    required this.title,
    required this.hint,
    this.label,
  });

  /// Returns the trimmed reason, or null when the user backs out.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String hint,
    String? label,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) =>
          ChangeReasonDialog(title: title, hint: hint, label: label),
    );
  }

  @override
  State<ChangeReasonDialog> createState() => _ChangeReasonDialogState();
}

class _ChangeReasonDialogState extends State<ChangeReasonDialog> {
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
              labelText: widget.label ?? l10n.changeReasonLabel,
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
