import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ReviewIntro extends StatelessWidget {
  const ReviewIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n.reviewIntroTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 24),
          child: Text(
            l10n.reviewIntroBody,
            style: TextStyle(fontSize: 14, color: context.palette.textSecondary),
          ),
        ),
      ],
    );
  }
}

class RatingPicker extends StatelessWidget {
  final int rating;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const RatingPicker({
    super.key,
    required this.rating,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final selected = index < rating;
        return IconButton(
          iconSize: 48,
          onPressed: enabled ? () => onChanged(index + 1) : null,
          icon: Icon(
            selected ? Icons.star : Icons.star_border,
            color: selected ? AppColors.warningOrange : palette.textTertiary,
          ),
        );
      }),
    );
  }
}

class ReviewCommentField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const ReviewCommentField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: null,
      minLines: 6,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).reviewCommentHint,
      ),
    );
  }
}

class ReviewPhotoAttachment extends StatelessWidget {
  final bool attached;
  final bool enabled;
  final VoidCallback onTap;

  const ReviewPhotoAttachment({
    super.key,
    required this.attached,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: attached ? palette.positiveBg : palette.mutedSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              attached ? Icons.check_circle : Icons.add_a_photo,
              color: attached ? AppColors.primaryGreen : context.palette.textSecondary,
            ),
            Text(
              attached ? l10n.reviewPhotoAttached : l10n.reviewPhotoAdd,
              style: TextStyle(
                color: attached ? AppColors.primaryGreen : context.palette.textSecondary,
                fontSize: 12,
                fontWeight: attached ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewSubmitButton extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onSubmit;

  const ReviewSubmitButton({
    super.key,
    required this.enabled,
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: enabled ? onSubmit : null,
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                AppLocalizations.of(context).reviewSubmit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
