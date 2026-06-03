import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/ui/app_feedback.dart';
import '../features/account/controllers/session_cubit.dart';
import '../features/vouchers/controllers/manual_voucher_cubit.dart';
import '../features/vouchers/controllers/manual_voucher_state.dart';
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
  late final ManualVoucherCubit _manualVoucherCubit;

  @override
  void initState() {
    super.initState();
    _manualVoucherCubit = ManualVoucherCubit()..load();
  }

  @override
  void dispose() {
    _manualVoucherCubit.close();
    _code.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _manualVoucherCubit,
      child: BlocBuilder<ManualVoucherCubit, ManualVoucherState>(
        builder: (context, state) {
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
                    shopId: state.shopId,
                    shops: state.shops,
                    onChanged: _manualVoucherCubit.selectShop,
                  ),
                  const SizedBox(height: 14),
                  ManualVoucherScanActions(onScanDemo: _scanDemo),
                  const SizedBox(height: 14),
                  ManualVoucherFields(code: _code, title: _title, note: _note),
                  const SizedBox(height: 14),
                  ManualVoucherExpiryTile(
                    expiresAt: state.expiresAt,
                    onPickExpiry: _pickExpiry,
                  ),
                  const SizedBox(height: 24),
                  ManualVoucherSaveButton(onSave: _save),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _scanDemo(String format) {
    _code.text = _manualVoucherCubit.scanDemo(format);
    AppFeedback.showSnackBar(context, 'Đã copy mã $format demo vào ô mã');
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _manualVoucherCubit.state.expiresAt,
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    );
    if (picked == null) return;
    _manualVoucherCubit.setExpiry(picked);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final saved = _manualVoucherCubit.save(
      userEmail: context.read<SessionCubit>().state.email,
      code: _code.text,
      title: _title.text,
      note: _note.text,
    );
    if (saved == null) return;
    AppFeedback.showSnackBar(context, 'Đã thêm voucher thủ công vào ví');
    Navigator.pop(context, true);
  }
}
