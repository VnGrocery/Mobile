import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/session.dart';
import '../theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    final shop = AppDataHooks.instance.getShop(
      SessionManager.instance.shopId ?? MockShopIds.demo,
    );
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

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final shop = AppDataHooks.instance.saveShop(
      shopId: SessionManager.instance.shopId ?? MockShopIds.demo,
      name: _name.text.trim(),
      description: _description.text.trim(),
      address: _address.text.trim(),
    );
    SessionManager.instance.shopId = shop.id;
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu thông tin cửa hàng demo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = AppDataHooks.instance.getSellerDashboard(
      SessionManager.instance.shopId,
    );
    return Scaffold(
      backgroundColor: AppColors.screenBg,
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
          _summaryCard(dashboard),
          const SizedBox(height: 16),
          _field(_name, 'Tên cửa hàng', Icons.storefront),
          const SizedBox(height: 12),
          _field(_description, 'Mô tả', Icons.notes, maxLines: 4),
          const SizedBox(height: 12),
          _field(_address, 'Địa chỉ', Icons.location_on),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _saving ||
                      _name.text.trim().isEmpty ||
                      _address.text.trim().isEmpty
                  ? null
                  : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Đang lưu...' : 'Lưu thay đổi'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Thông tin này dùng để hiển thị trên trang cửa hàng và tem sản phẩm.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(SellerDashboard dashboard) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: palette.elevatedCard,
                child:
                    const Icon(Icons.verified, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'Hạng ${dashboard.trustGrade} - ${dashboard.shop.rating} điểm',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _metric('Sản phẩm', '${dashboard.products.length}'),
              _metric('Ghi nhận', '${dashboard.pledges.length}'),
              _metric('Cảnh báo', '${dashboard.warningCount}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class MockShopIds {
  static const demo = 's1';
}
