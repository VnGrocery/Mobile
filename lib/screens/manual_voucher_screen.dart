import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../data/session.dart';
import '../features/vouchers/voucher_presenter.dart';
import '../features/vouchers/widgets/manual_voucher_components.dart';
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

  @override
  Widget build(BuildContext context) {
    final shops = VoucherPresenter.shops();
    _shopId ??= shops.first.id;

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Thêm voucher thủ công')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ManualVoucherNotice(),
            const SizedBox(height: 16),
            ManualVoucherShopPicker(
              shopId: _shopId,
              shops: shops,
              onChanged: (value) => setState(() => _shopId = value),
            ),
            const SizedBox(height: 14),
            ManualVoucherScanActions(onScanDemo: _scanDemo),
            const SizedBox(height: 14),
            ManualVoucherFields(code: _code, title: _title, note: _note),
            const SizedBox(height: 14),
            ManualVoucherExpiryTile(
              expiresAt: _expiresAt,
              onPickExpiry: _pickExpiry,
            ),
            const SizedBox(height: 24),
            ManualVoucherSaveButton(onSave: _save),
          ],
        ),
      ),
    );
  }

  void _scanDemo(String format) {
    setState(() {
      _codeFormat = format;
      _code.text = format == 'QR' ? 'MANUALQR20' : 'BARCODE-8938505970012';
    });
    AppFeedback.showSnackBar(context, 'Đã copy mã $format demo vào ô mã');
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
    VoucherPresenter.addManualVoucher(
      userEmail: SessionManager.instance.email,
      shopId: shopId,
      code: _code.text,
      title: _title.text,
      note: _note.text,
      codeFormat: _codeFormat,
      expiresAt: _expiresAt,
    );
    AppFeedback.showSnackBar(context, 'Đã thêm voucher thủ công vào ví');
    Navigator.pop(context, true);
  }
}
