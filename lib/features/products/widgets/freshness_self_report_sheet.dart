import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/screens/camera_capture_screen.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// The defect classes a buyer can pick from.
///
/// Deliberately short and in the buyer's own terms. The value sent to the
/// server is the key, so adding an AI vocabulary later does not have to rename
/// what people have already filed.
const _categories = <String, String Function(AppLocalizations)>{
  'fresh': _freshLabel,
  'bruised': _bruisedLabel,
  'wilted': _wiltedLabel,
  'spoiled': _spoiledLabel,
};

String _freshLabel(AppLocalizations l10n) => l10n.freshnessCategoryFresh;
String _bruisedLabel(AppLocalizations l10n) => l10n.freshnessCategoryBruised;
String _wiltedLabel(AppLocalizations l10n) => l10n.freshnessCategoryWilted;
String _spoiledLabel(AppLocalizations l10n) => l10n.freshnessCategorySpoiled;

/// Lets a buyer score the produce they were actually handed.
///
/// The server files this as `reviewStatus: self_reported`, and the sheet says
/// so in as many words. Nothing checks the number, so putting it next to the
/// pledge score without that label would let an opinion pass for proof.
///
/// The photo is not optional. It is the only part of the report anything can
/// be checked against later, and Mode 1 exists so an AI pass can re-score it.
class FreshnessSelfReportSheet extends StatefulWidget {
  final String shopId;
  final String productId;
  final Uint8List photo;

  const FreshnessSelfReportSheet({
    super.key,
    required this.shopId,
    required this.productId,
    required this.photo,
  });

  /// Takes the photo, then collects the score. Returns true when a report was
  /// filed; false if the buyer backed out of either step.
  static Future<bool> show(
    BuildContext context, {
    required String shopId,
    required String productId,
  }) async {
    final l10n = AppLocalizations.of(context);
    final photo = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) =>
            CameraCaptureScreen(hint: l10n.freshnessReportPhotoHint),
      ),
    );
    if (photo == null || !context.mounted) return false;

    final filed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FreshnessSelfReportSheet(
        shopId: shopId,
        productId: productId,
        photo: photo,
      ),
    );
    return filed ?? false;
  }

  @override
  State<FreshnessSelfReportSheet> createState() =>
      _FreshnessSelfReportSheetState();
}

class _FreshnessSelfReportSheetState extends State<FreshnessSelfReportSheet> {
  final _comment = TextEditingController();

  /// Starts mid-scale rather than at 10. A slider parked on the best score
  /// collects a best score from everyone who taps submit without thinking.
  double _score = 5;
  String _category = _categories.keys.first;
  bool _sending = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final remote = AppRepositories.instance.products.remote;
    final l10n = AppLocalizations.of(context);
    if (remote == null) {
      AppFeedback.showSnackBar(
        context,
        l10n.freshnessReportErrorGeneric,
        icon: Icons.error_outline,
      );
      return;
    }

    setState(() => _sending = true);
    try {
      // Upload first: the report has to point at bytes the server already
      // holds, so a hash computed here would name an image nobody can fetch.
      final stored = await remote.uploadImageDetails(widget.photo);
      await remote.createFreshnessReport(
        shopId: widget.shopId,
        productId: widget.productId,
        score: _score,
        category: _category,
        imageHash: stored['imageHash']?.toString() ?? '',
        imageCid: stored['imageCid']?.toString() ?? '',
        comment: _comment.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      AppFeedback.showSnackBar(
        context,
        _errorMessage(error, l10n),
        icon: Icons.error_outline,
      );
    }
  }

  /// Mirrors the scanner's handling: the server sends how long the wait is, and
  /// a guessed number would be worse than the generic line.
  static String _errorMessage(Object error, AppLocalizations l10n) {
    if (error is! ApiException) return l10n.freshnessReportErrorNetwork;
    if (error.statusCode == 429) {
      final minutes = error.retryAfterMinutes;
      return minutes == null
          ? l10n.freshnessReportErrorGeneric
          : l10n.freshnessReportErrorRateLimited(minutes);
    }
    return l10n.freshnessReportErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      // Scrolls because the photo, chips and comment field together are taller
      // than what is left on a short phone once the keyboard is up.
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.freshnessReportTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.freshnessReportSelfReportedNote,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                widget.photo,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final entry in _categories.entries)
                  ChoiceChip(
                    label: Text(entry.value(l10n)),
                    selected: _category == entry.key,
                    onSelected: _sending
                        ? null
                        : (_) => setState(() => _category = entry.key),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  _score.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _score,
                    max: 10,
                    // Half points. Tenths would invite a precision the eye
                    // cannot deliver.
                    divisions: 20,
                    label: _score.toStringAsFixed(1),
                    onChanged: _sending
                        ? null
                        : (value) => setState(() => _score = value),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _comment,
              enabled: !_sending,
              maxLines: 3,
              maxLength: 300,
              decoration: InputDecoration(
                labelText: l10n.freshnessReportCommentLabel,
                hintText: l10n.freshnessReportCommentHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('freshness_report.submit_button'),
                onPressed: _sending ? null : _submit,
                child: Text(
                  _sending
                      ? l10n.freshnessReportSending
                      : l10n.freshnessReportSubmit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
