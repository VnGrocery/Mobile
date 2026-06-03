import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/features/vouchers/voucher_presenter.dart';
import 'voucher_components.dart';

class VoucherUseHeader extends StatelessWidget {
  final Voucher voucher;
  final Shop shop;
  final UserVoucher userVoucher;

  const VoucherUseHeader({
    super.key,
    required this.voucher,
    required this.shop,
    required this.userVoucher,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.positiveBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            voucher.title,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(shop.name, style: TextStyle(color: palette.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.info, size: 17, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                VoucherPresenter.detailStatus(userVoucher, voucher),
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (voucher.isManual) ...[
                const SizedBox(width: 8),
                const ManualVoucherBadge(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class VoucherCodeCard extends StatelessWidget {
  final UserVoucher userVoucher;
  final Voucher voucher;
  final Shop shop;

  const VoucherCodeCard({
    super.key,
    required this.userVoucher,
    required this.voucher,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final payload = VoucherPresenter.qrPayload(
      userVoucher: userVoucher,
      voucher: voucher,
      shop: shop,
    );
    final barcodeMode = voucher.codeFormat == 'Mã vạch';

    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 220,
              height: 220,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: palette.border),
              ),
              child: barcodeMode
                  ? BarcodePreview(code: voucher.code)
                  : const FittedBox(
                      child: Icon(Icons.qr_code_2, color: Colors.black),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              voucher.code,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              payload,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherRuleCard extends StatelessWidget {
  final Voucher voucher;
  final Shop shop;

  const VoucherRuleCard({
    super.key,
    required this.voucher,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Điều kiện sử dụng',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          VoucherRuleRow(
            icon: Icons.storefront,
            text: 'Chỉ áp dụng tại ${shop.name}',
          ),
          VoucherRuleRow(
            icon: Icons.local_offer,
            text: VoucherPresenter.ruleDiscountLabel(voucher),
          ),
          if (!voucher.isManual)
            VoucherRuleRow(
              icon: Icons.receipt_long,
              text: 'Đơn từ ${formatVnd(voucher.minSpend)}',
            ),
          VoucherRuleRow(
            icon: Icons.event,
            text: VoucherPresenter.expiryLabel(voucher),
          ),
          if (voucher.isManual && voucher.note.isNotEmpty)
            VoucherRuleRow(icon: Icons.note, text: voucher.note),
        ],
      ),
    );
  }
}
