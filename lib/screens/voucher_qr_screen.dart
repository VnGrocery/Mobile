import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/data_hooks.dart';
import '../data/models.dart';
import '../features/vouchers/voucher_presenter.dart';
import '../features/vouchers/widgets/voucher_components.dart';
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
    final disabled = VoucherPresenter.isDisabled(userVoucher, voucher);

    return Scaffold(
      backgroundColor: palette.appBackground,
      appBar: AppBar(title: const Text('Dùng voucher')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _VoucherHeader(
            voucher: voucher,
            shop: shop,
            userVoucher: userVoucher,
          ),
          const SizedBox(height: 20),
          _VoucherCodeCard(
            userVoucher: userVoucher,
            voucher: voucher,
            shop: shop,
          ),
          if (voucher.isManual) ...[
            const SizedBox(height: 14),
            const VoucherNotice(
              text:
                  'Thông tin voucher này do bạn tự nhập và chưa được cửa hàng xác thực. Hãy kiểm tra lại điều kiện tại quầy trước khi sử dụng.',
            ),
          ],
          const SizedBox(height: 20),
          _VoucherRuleCard(voucher: voucher, shop: shop),
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
    AppFeedback.showSnackBar(context, 'Đã sử dụng voucher');
  }
}

class _VoucherHeader extends StatelessWidget {
  final Voucher voucher;
  final Shop shop;
  final UserVoucher userVoucher;

  const _VoucherHeader({
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

class _VoucherCodeCard extends StatelessWidget {
  final UserVoucher userVoucher;
  final Voucher voucher;
  final Shop shop;

  const _VoucherCodeCard({
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

class _VoucherRuleCard extends StatelessWidget {
  final Voucher voucher;
  final Shop shop;

  const _VoucherRuleCard({
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
