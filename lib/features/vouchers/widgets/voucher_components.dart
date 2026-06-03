import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class VoucherMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const VoucherMeta({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherPill extends StatelessWidget {
  final String label;
  final Color color;

  const VoucherPill({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

class ManualVoucherBadge extends StatelessWidget {
  const ManualVoucherBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoucherPill(
      label: 'Tự nhập',
      color: AppColors.warningOrange,
    );
  }
}

class VoucherNotice extends StatelessWidget {
  final String text;
  final IconData icon;

  const VoucherNotice({
    super.key,
    required this.text,
    this.icon = Icons.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.palette.warningBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warningOrange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(height: 1.35)),
          ),
        ],
      ),
    );
  }
}

class VoucherRuleRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const VoucherRuleRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class BarcodePreview extends StatelessWidget {
  final String code;

  const BarcodePreview({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final bars = [8, 3, 5, 9, 4, 7, 2, 6, 10, 4, 8, 3, 6, 5, 9];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 118,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final width in bars) ...[
                Container(width: width / 2, color: Colors.black),
                const SizedBox(width: 3),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          code,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
