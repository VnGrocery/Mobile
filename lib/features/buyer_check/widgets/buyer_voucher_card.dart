import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'buyer_voucher_header.dart';
import 'buyer_voucher_input_row.dart';
import 'buyer_voucher_result_content.dart';

class VoucherCheckCard extends StatelessWidget {
  final TextEditingController controller;
  final Product product;
  final Shop shop;
  final VoucherCheckResult? result;
  final VoidCallback onCheck;
  final ValueChanged<Voucher> onSaveVoucher;
  final VoidCallback onOpenWallet;

  const VoucherCheckCard({
    super.key,
    required this.controller,
    required this.product,
    required this.shop,
    required this.result,
    required this.onCheck,
    required this.onSaveVoucher,
    required this.onOpenWallet,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final voucherResult = result;
    final valid = voucherResult?.valid ?? false;
    final resultColor = valid
        ? AppColors.primaryGreen
        : AppColors.warningOrange;

    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VoucherCheckHeader(product: product, shop: shop),
            const SizedBox(height: 14),
            VoucherCheckInputRow(controller: controller, onCheck: onCheck),
            if (voucherResult != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: valid ? palette.positiveBg : palette.warningBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: VoucherCheckResultContent(
                  result: voucherResult,
                  color: resultColor,
                  onSaveVoucher: onSaveVoucher,
                  onOpenWallet: onOpenWallet,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
