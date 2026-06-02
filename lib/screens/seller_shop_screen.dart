import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/session.dart';
import '../features/seller_shop/seller_shop_presenter.dart';
import '../features/seller_shop/widgets/seller_shop_components.dart';
import '../theme/app_palette.dart';

class SellerShopScreen extends StatefulWidget {
  final double bottomContentInset;

  const SellerShopScreen({super.key, this.bottomContentInset = 0});

  @override
  State<SellerShopScreen> createState() => _SellerShopScreenState();
}

class _SellerShopScreenState extends State<SellerShopScreen> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _address;
  bool _saving = false;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && _address.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final shop = SellerShopPresenter.shop(SessionManager.instance.shopId);
    _name = TextEditingController(text: shop.name);
    _description = TextEditingController(text: shop.description);
    _address = TextEditingController(text: shop.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = SellerShopPresenter.dashboard(
      SessionManager.instance.shopId,
    );
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Thông tin cửa hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(16, 16, 16, 16 + widget.bottomContentInset),
        children: [
          SellerShopSummaryCard(dashboard: dashboard),
          const SizedBox(height: 16),
          SellerShopFields(
            name: _name,
            description: _description,
            address: _address,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          SellerShopSaveButton(
            saving: _saving,
            enabled: _canSave,
            onSave: _save,
          ),
          const SizedBox(height: 16),
          const SellerShopFootnote(),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final shop = SellerShopPresenter.saveShop(
      shopId: SessionManager.instance.shopId,
      name: _name.text,
      description: _description.text,
      address: _address.text,
    );
    SessionManager.instance.shopId = shop.id;
    if (!mounted) return;
    setState(() => _saving = false);
    AppFeedback.showSnackBar(context, 'Đã lưu thông tin cửa hàng demo');
  }
}
