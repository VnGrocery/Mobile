import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../utils/format.dart';

class VoucherQrScreen extends StatefulWidget {
  final String userVoucherId;

  const VoucherQrScreen({super.key, required this.userVoucherId});

  @override
  State<VoucherQrScreen> createState() => _VoucherQrScreenState();
}

class _VoucherQrScreenState extends State<VoucherQrScreen> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final userVoucher = data.getUserVoucher(widget.userVoucherId);
    final voucher = data.getVoucher(userVoucher.voucherId);
    final shop = data.getShop(voucher.shopId);
    final palette = context.palette;
    final expired = DateTime.now().isAfter(voucher.expiresAt);
    final disabled = userVoucher.used || expired || !voucher.active;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(title: const Text('Dùng voucher')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _voucherHeader(voucher, shop, userVoucher, expired, palette),
          const SizedBox(height: 20),
          _qrCard(userVoucher, voucher, shop, palette),
          const SizedBox(height: 20),
          _ruleCard(voucher, shop, palette),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: disabled || _confirming ? null : _markUsed,
              icon: Icon(userVoucher.used ? Icons.check : Icons.point_of_sale),
              label: Text(
                  userVoucher.used ? 'Voucher đã dùng' : 'Đánh dấu đã dùng'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(
              context,
              Routes.storeDetail,
              arguments: shop.id,
            ),
            child: const Text('Xem cửa hàng áp dụng'),
          ),
        ],
      ),
    );
  }

  Future<void> _markUsed() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận dùng voucher'),
        content: const Text(
          'Voucher chỉ dùng được 1 lần. Sau khi xác nhận, voucher sẽ chuyển sang trạng thái đã dùng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _confirming = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    AppDataHooks.instance.useUserVoucher(widget.userVoucherId);
    if (!mounted) return;
    setState(() => _confirming = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sử dụng voucher')),
    );
  }

  Widget _voucherHeader(
    Voucher voucher,
    Shop shop,
    UserVoucher userVoucher,
    bool expired,
    AppPalette palette,
  ) {
    final status = userVoucher.used
        ? 'Đã dùng'
        : expired
            ? 'Hết hạn'
            : 'Sẵn sàng sử dụng';
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
                status,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qrCard(
    UserVoucher userVoucher,
    Voucher voucher,
    Shop shop,
    AppPalette palette,
  ) {
    final payload = 'VNGROCERY:${userVoucher.id}:${voucher.code}:${shop.id}';
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
              child: const FittedBox(
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

  Widget _ruleCard(Voucher voucher, Shop shop, AppPalette palette) {
    final discount = voucher.isPercent
        ? 'Giảm ${voucher.discountValue}%'
        : 'Giảm ${formatVnd(voucher.discountValue)}';
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
          _rule(Icons.storefront, 'Chỉ áp dụng tại ${shop.name}'),
          _rule(Icons.local_offer, discount),
          _rule(Icons.receipt_long, 'Đơn từ ${formatVnd(voucher.minSpend)}'),
          _rule(
            Icons.event,
            'Hạn dùng ${voucher.expiresAt.day}/${voucher.expiresAt.month}/${voucher.expiresAt.year}',
          ),
        ],
      ),
    );
  }

  Widget _rule(IconData icon, String text) {
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
