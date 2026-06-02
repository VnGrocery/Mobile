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
    final disabled = userVoucher.isUsed || expired || !voucher.isActive;

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Dùng voucher')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _voucherHeader(voucher, shop, userVoucher, expired, palette),
          const SizedBox(height: 20),
          _qrCard(userVoucher, voucher, shop, palette),
          if (voucher.isManual) ...[
            const SizedBox(height: 14),
            _manualNotice(palette),
          ],
          const SizedBox(height: 20),
          _ruleCard(voucher, shop, palette),
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: disabled || _confirming ? null : _markUsed,
              icon:
                  Icon(userVoucher.isUsed ? Icons.check : Icons.point_of_sale),
              label: Text(
                userVoucher.isUsed ? 'Voucher đã dùng' : 'Đánh dấu đã dùng',
              ),
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
    final status = userVoucher.isUsed
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
              if (voucher.isManual) ...[
                const SizedBox(width: 8),
                const Text(
                  'Tự nhập',
                  style: TextStyle(
                    color: AppColors.warningOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
    final payload = voucher.isManual
        ? voucher.code
        : 'VNGROCERY:${userVoucher.id}:${voucher.code}:${shop.id}';
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
                  ? _BarcodePreview(code: voucher.code)
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

  Widget _manualNotice(AppPalette palette) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.warningBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: AppColors.warningOrange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Thông tin voucher này do bạn tự nhập và chưa được cửa hàng xác thực. Hãy kiểm tra lại điều kiện tại quầy trước khi sử dụng.',
              style: TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleCard(Voucher voucher, Shop shop, AppPalette palette) {
    final discount = voucher.isManual
        ? 'Theo thông tin bạn tự nhập'
        : (voucher.isPercent
            ? 'Giảm ${voucher.discountValue}%'
            : 'Giảm ${formatVnd(voucher.discountValue)}');
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
          if (!voucher.isManual)
            _rule(Icons.receipt_long, 'Đơn từ ${formatVnd(voucher.minSpend)}'),
          _rule(
            Icons.event,
            'Hạn dùng ${voucher.expiresAt.day}/${voucher.expiresAt.month}/${voucher.expiresAt.year}',
          ),
          if (voucher.isManual && voucher.note.isNotEmpty)
            _rule(Icons.note, voucher.note),
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

class _BarcodePreview extends StatelessWidget {
  final String code;

  const _BarcodePreview({required this.code});

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
