import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/session.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class ManualVoucherScreen extends StatefulWidget {
  const ManualVoucherScreen({super.key});

  @override
  State<ManualVoucherScreen> createState() => _ManualVoucherScreenState();
}

class _ManualVoucherScreenState extends State<ManualVoucherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _title = TextEditingController();
  final _note = TextEditingController();
  String _codeFormat = 'QR';
  String? _shopId;
  DateTime _expiresAt = DateTime(2026, 6, 30, 23, 59);

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  void _scanDemo(String format) {
    setState(() {
      _codeFormat = format;
      _code.text = format == 'QR' ? 'MANUALQR20' : 'BARCODE-8938505970012';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã copy mã $format demo vào ô mã')),
    );
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt,
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    );
    if (picked == null) return;
    setState(() {
      _expiresAt = DateTime(picked.year, picked.month, picked.day, 23, 59);
    });
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final shopId = _shopId;
    if (shopId == null) return;
    AppDataHooks.instance.addManualVoucherToWallet(
      userEmail: SessionManager.instance.email,
      shopId: shopId,
      code: _code.text,
      title: _title.text,
      note: _note.text,
      codeFormat: _codeFormat,
      expiresAt: _expiresAt,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm voucher thủ công vào ví')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final shops = data.getShops();
    _shopId ??= shops.first.id;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Thêm voucher thủ công')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _notice(palette),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _shopId,
              decoration: const InputDecoration(
                labelText: 'Cửa hàng áp dụng',
                prefixIcon: Icon(Icons.storefront),
              ),
              items: shops
                  .map(
                    (shop) => DropdownMenuItem(
                      value: shop.id,
                      child: Text(shop.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _shopId = value),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _scanDemo('QR'),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Quét QR'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _scanDemo('Mã vạch'),
                    icon: const Icon(Icons.document_scanner),
                    label: const Text('Quét mã vạch'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Mã voucher',
                prefixIcon: Icon(Icons.confirmation_number),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) return 'Nhập mã voucher';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Tên gợi nhớ',
                hintText: 'VD: Giảm 20% mua thịt cuối tuần',
                prefixIcon: Icon(Icons.local_offer),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _note,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ghi chú của bạn',
                hintText: 'Điều kiện sử dụng, nguồn nhận mã, lưu ý tại quầy...',
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Hạn dùng'),
              subtitle: Text(
                '${_expiresAt.day}/${_expiresAt.month}/${_expiresAt.year}',
              ),
              trailing: TextButton(
                onPressed: _pickExpiry,
                child: const Text('Đổi ngày'),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Lưu vào ví'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notice(AppPalette palette) {
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
              'Voucher thủ công là thông tin do bạn tự nhập để lưu trữ và sử dụng tại quầy. Nội dung này chưa được cửa hàng xác thực, bạn tự chịu trách nhiệm về điều kiện sử dụng.',
              style: TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
