import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/data_hooks.dart';
import '../data/models.dart';
import '../data/session.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../utils/format.dart';

class BuyerCheckResultScreen extends StatefulWidget {
  const BuyerCheckResultScreen({super.key});

  @override
  State<BuyerCheckResultScreen> createState() => _BuyerCheckResultScreenState();
}

class _BuyerCheckResultScreenState extends State<BuyerCheckResultScreen> {
  final _voucher = TextEditingController(text: 'FRESH20');
  VoucherCheckResult? _voucherResult;

  @override
  void dispose() {
    _voucher.dispose();
    super.dispose();
  }

  void _checkVoucher(Product product) {
    FocusScope.of(context).unfocus();
    final result = AppDataHooks.instance.checkVoucher(
      code: _voucher.text,
      shopId: product.shopId,
      orderValue: product.price,
    );
    setState(() => _voucherResult = result);
  }

  void _saveVoucherToWallet(Voucher voucher) {
    AppDataHooks.instance.saveVoucherToWallet(
      userEmail: SessionManager.instance.email,
      voucherId: voucher.id,
    );
    AppFeedback.showSnackBar(context, 'Đã lưu voucher vào ví');
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final result = data.getLastBuyerCheck();
    final product = data.getProduct('p1');
    final shop = data.getShop(product.shopId);
    final fair = result.locationStatus == 'near';
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Kết quả kiểm tra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.elevatedCard,
                border: Border.all(color: AppColors.warningOrange, width: 8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${result.actualScore}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Text(
                    'Điểm đánh giá',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: fair ? palette.positiveBg : palette.warningBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    fair ? Icons.gps_fixed : Icons.gps_off,
                    size: 16,
                    color:
                        fair ? AppColors.trustGreen : AppColors.warningOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fair ? 'Ghi nhận tại quầy' : 'Cần thêm lượt xác nhận',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          fair ? AppColors.trustGreen : AppColors.warningOrange,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
              child: Text(
                fair
                    ? 'Bạn đang ở gần cửa hàng. Ghi nhận này được tính vào dữ liệu gần đây.'
                    : 'Bạn không ở gần cửa hàng. Ghi nhận này chỉ dùng để tham khảo.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            _verdictCard(result, palette),
            const SizedBox(height: 16),
            _voucherCard(product, shop, palette),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  final shopId = SessionManager.instance.shopId ?? shop.id;
                  Navigator.pushNamed(
                    context,
                    Routes.storeDetail,
                    arguments: shopId,
                  );
                },
                child: const Text(
                  'Xem cửa hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Chụp lại',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verdictCard(BuyerCheckResult result, AppPalette palette) {
    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'So với dữ liệu gần nhất',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.warningOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kết quả: ${result.verdict}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Kết quả dựa trên ảnh bạn gửi và thông tin đã ghi nhận.',
                style: TextStyle(fontSize: 14, color: palette.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _voucherCard(Product product, Shop shop, AppPalette palette) {
    final voucherResult = _voucherResult;
    final valid = voucherResult?.valid ?? false;
    final resultColor =
        valid ? AppColors.primaryGreen : AppColors.warningOrange;

    return Card(
      color: palette.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Kiểm tra voucher',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  formatVnd(product.price),
                  style: const TextStyle(
                    color: AppColors.priceRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${product.name} - ${shop.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _voucher,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Mã voucher',
                      hintText: 'VD: FRESH20',
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                    onSubmitted: (_) => _checkVoucher(product),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () => _checkVoucher(product),
                    child: const Text('Kiểm tra'),
                  ),
                ),
              ],
            ),
            if (voucherResult != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: valid ? palette.positiveBg : palette.warningBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          valid ? Icons.check_circle : Icons.info,
                          color: resultColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            voucherResult.message,
                            style: TextStyle(
                              color: resultColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (valid) ...[
                      const SizedBox(height: 8),
                      _priceLine(
                        'Giảm',
                        '-${formatVnd(voucherResult.discountAmount)}',
                        AppColors.primaryGreen,
                      ),
                      _priceLine(
                        'Còn lại',
                        formatVnd(voucherResult.finalPrice),
                        AppColors.priceRed,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _saveVoucherToWallet(voucherResult.voucher!),
                              icon: const Icon(Icons.wallet),
                              label: const Text('Lưu vào ví'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                Routes.voucherWallet,
                              ),
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Mở ví'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _priceLine(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
