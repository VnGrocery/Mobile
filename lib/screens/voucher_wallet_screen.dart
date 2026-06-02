import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../data/session.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../utils/format.dart';

class VoucherWalletScreen extends StatefulWidget {
  const VoucherWalletScreen({super.key});

  @override
  State<VoucherWalletScreen> createState() => _VoucherWalletScreenState();
}

class _VoucherWalletScreenState extends State<VoucherWalletScreen> {
  bool _showUsed = false;

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final email = SessionManager.instance.email;
    final wallet = data.getUserVouchers(email);
    final visibleWallet =
        wallet.where((item) => _showUsed || !item.used).toList();
    final usableCount = wallet.where((item) => !item.used).length;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(title: const Text('Ví voucher')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _summaryCard(usableCount, wallet.length, palette),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Voucher của bạn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              FilterChip(
                selected: _showUsed,
                showCheckmark: false,
                label: const Text('Hiện đã dùng'),
                onSelected: (value) => setState(() => _showUsed = value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (visibleWallet.isEmpty)
            _emptyState(palette)
          else
            ...visibleWallet.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _voucherCard(item, data.getVoucher(item.voucherId)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryCard(int usableCount, int total, AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.positiveBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.wallet, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$usableCount voucher có thể dùng',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'Tổng cộng $total voucher trong ví',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Chưa có voucher phù hợp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Quét sản phẩm hoặc nhập mã để lưu voucher vào ví.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _voucherCard(UserVoucher userVoucher, Voucher voucher) {
    final data = AppDataHooks.instance;
    final shop = data.getShop(voucher.shopId);
    final palette = context.palette;
    final expired = DateTime.now().isAfter(voucher.expiresAt);
    final disabled = userVoucher.used || expired || !voucher.active;
    final discount = voucher.isPercent
        ? 'Giảm ${voucher.discountValue}%'
        : 'Giảm ${formatVnd(voucher.discountValue)}';

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
                  arguments: userVoucher.id,
                );
                if (mounted) setState(() {});
              },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        disabled ? palette.mutedSurface : palette.positiveBg,
                    child: Icon(
                      userVoucher.used ? Icons.check : Icons.local_offer,
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
                  _statusBadge(userVoucher, expired),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _meta(Icons.sell, discount),
                  const SizedBox(width: 10),
                  _meta(
                      Icons.receipt_long, 'Từ ${formatVnd(voucher.minSpend)}'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
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
                  Text(
                    'HSD ${voucher.expiresAt.day}/${voucher.expiresAt.month}/${voucher.expiresAt.year}',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(UserVoucher userVoucher, bool expired) {
    final label = userVoucher.used
        ? 'Đã dùng'
        : expired
            ? 'Hết hạn'
            : 'Có thể dùng';
    final color =
        userVoucher.used || expired ? Colors.grey : AppColors.primaryGreen;
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

  Widget _meta(IconData icon, String label) {
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
