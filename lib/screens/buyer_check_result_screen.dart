import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/models.dart';
import '../data/session.dart';
import '../features/buyer_check/buyer_check_presenter.dart';
import '../features/buyer_check/widgets/buyer_check_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_palette.dart';

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

  @override
  Widget build(BuildContext context) {
    final result = BuyerCheckPresenter.lastResult();
    final product = BuyerCheckPresenter.demoProduct();
    final shop = BuyerCheckPresenter.shop(product.shopId);

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Kết quả kiểm tra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            BuyerScoreSummary(result: result),
            const SizedBox(height: 32),
            BuyerVerdictCard(result: result),
            const SizedBox(height: 16),
            VoucherCheckCard(
              controller: _voucher,
              product: product,
              shop: shop,
              result: _voucherResult,
              onCheck: () => _checkVoucher(product),
              onSaveVoucher: _saveVoucherToWallet,
              onOpenWallet: () => Navigator.pushNamed(
                context,
                Routes.voucherWallet,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () => _openStore(shop),
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

  void _checkVoucher(Product product) {
    FocusScope.of(context).unfocus();
    final result = BuyerCheckPresenter.checkVoucher(
      code: _voucher.text,
      product: product,
    );
    setState(() => _voucherResult = result);
  }

  void _saveVoucherToWallet(Voucher voucher) {
    BuyerCheckPresenter.saveVoucherToWallet(
      userEmail: SessionManager.instance.email,
      voucherId: voucher.id,
    );
    AppFeedback.showSnackBar(context, 'Đã lưu voucher vào ví');
  }

  void _openStore(Shop shop) {
    final shopId = SessionManager.instance.shopId ?? shop.id;
    Navigator.pushNamed(context, Routes.storeDetail, arguments: shopId);
  }
}
