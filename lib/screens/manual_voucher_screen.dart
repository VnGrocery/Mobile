import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/screens/qr_scan_screen.dart';
import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/manual_voucher_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/manual_voucher_state.dart';
import 'package:vngrocery/features/vouchers/widgets/manual_voucher_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

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
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: Text(l10n.manualVoucherTitle)),
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
                  ManualVoucherScanActions(onScan: _scanCode),
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

  /// Reads the code off the voucher instead of inventing one: this used to
  /// drop a hardcoded "MANUALQR20" into the field.
  Future<void> _scanCode(String format) async {
    final l10n = AppLocalizations.of(context);
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScanScreen(raw: true)),
    );
    if (scanned == null || scanned.trim().isEmpty || !mounted) return;
    _code.text = scanned.trim();
    _manualVoucherCubit.setCodeFormat(format);
    AppFeedback.showSnackBar(context, l10n.manualVoucherCodeScanned(format));
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final saved = await _manualVoucherCubit.saveRemote(
      userEmail: context.read<SessionCubit>().state.email,
      code: _code.text,
      title: _title.text,
      note: _note.text,
    );
    if (saved == null || !mounted) return;
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).manualVoucherSaved,
    );
    Navigator.pop(context, true);
  }
}
