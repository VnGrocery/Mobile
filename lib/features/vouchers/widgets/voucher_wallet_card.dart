import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/vouchers/voucher_presenter.dart';
import 'voucher_components.dart';

class VoucherWalletCard extends StatelessWidget {
  final UserVoucher userVoucher;
  final Voucher voucher;
  final VoidCallback onChanged;

  const VoucherWalletCard({
    super.key,
    required this.userVoucher,
    required this.voucher,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final shop = VoucherPresenter.shop(voucher.shopId);
    final palette = context.palette;
    final expired = VoucherPresenter.isExpired(voucher);
    final disabled = VoucherPresenter.isDisabled(userVoucher, voucher);
    final statusColor =
        userVoucher.isUsed || expired ? Colors.grey : AppColors.primaryGreen;

    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled
            ? null
            : () async {
                await Navigator.pushNamed(
                  context,
                  Routes.voucherQr,
                  arguments: VoucherQrArgs(userVoucher.id),
                );
                onChanged();
              },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VoucherWalletHeader(
                userVoucher: userVoucher,
                voucher: voucher,
                shop: shop,
                disabled: disabled,
                statusColor: statusColor,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  VoucherMeta(
                    icon:
                        voucher.isManual ? Icons.document_scanner : Icons.sell,
                    label: VoucherPresenter.discountLabel(voucher),
                  ),
                  const SizedBox(width: 10),
                  VoucherMeta(
                    icon: Icons.receipt_long,
                    label: VoucherPresenter.spendLabel(voucher),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              VoucherWalletCodeRow(voucher: voucher),
              if (voucher.isManual && voucher.note.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  voucher.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class VoucherWalletHeader extends StatelessWidget {
  final UserVoucher userVoucher;
  final Voucher voucher;
  final Shop shop;
  final bool disabled;
  final Color statusColor;

  const VoucherWalletHeader({
    super.key,
    required this.userVoucher,
    required this.voucher,
    required this.shop,
    required this.disabled,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: disabled ? palette.mutedSurface : palette.positiveBg,
          child: Icon(
            userVoucher.isUsed ? Icons.check : Icons.local_offer,
            color: disabled ? Colors.grey : AppColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                voucher.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                shop.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        VoucherPill(
          label: VoucherPresenter.statusLabel(userVoucher, voucher),
          color: statusColor,
        ),
      ],
    );
  }
}

class VoucherWalletCodeRow extends StatelessWidget {
  final Voucher voucher;

  const VoucherWalletCodeRow({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Mã: ${voucher.code}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
        voucher.isManual
            ? const ManualVoucherBadge()
            : Text(
                VoucherPresenter.expiryLabel(voucher),
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 12,
                ),
              ),
      ],
    );
  }
}
