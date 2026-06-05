import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_qr_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_qr_state.dart';
import 'package:vngrocery/features/vouchers/widgets/voucher_components.dart';
import 'package:vngrocery/features/vouchers/widgets/voucher_qr_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class VoucherQrScreen extends StatefulWidget {
  final String userVoucherId;

  const VoucherQrScreen({super.key, required this.userVoucherId});

  @override
  State<VoucherQrScreen> createState() => _VoucherQrScreenState();
}

class _VoucherQrScreenState extends State<VoucherQrScreen> {
  late final VoucherQrCubit _voucherQrCubit;

  @override
  void initState() {
    super.initState();
    _voucherQrCubit = VoucherQrCubit(userVoucherId: widget.userVoucherId)
      ..load();
  }

  @override
  void dispose() {
    _voucherQrCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return BlocProvider.value(
      value: _voucherQrCubit,
      child: BlocBuilder<VoucherQrCubit, VoucherQrState>(
        builder: (context, state) {
          final userVoucher = state.userVoucher;
          final voucher = state.voucher;
          final shop = state.shop;
          if (userVoucher == null || voucher == null || shop == null) {
            return Scaffold(
              backgroundColor: palette.appBackground,
              appBar: AppBar(title: Text(l10n.voucherUseTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: palette.appBackground,
            appBar: AppBar(title: Text(l10n.voucherUseTitle)),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                VoucherUseHeader(
                  voucher: voucher,
                  shop: shop,
                  userVoucher: userVoucher,
                ),
                const SizedBox(height: 20),
                VoucherCodeCard(
                  userVoucher: userVoucher,
                  voucher: voucher,
                  shop: shop,
                ),
                if (voucher.isManual) ...[
                  const SizedBox(height: 14),
                  VoucherNotice(text: l10n.voucherManualUseWarning),
                ],
                const SizedBox(height: 20),
                VoucherRuleCard(voucher: voucher, shop: shop),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed:
                        state.disabled || state.confirming ? null : _markUsed,
                    icon: Icon(
                      userVoucher.isUsed ? Icons.check : Icons.point_of_sale,
                    ),
                    label: Text(
                      userVoucher.isUsed
                          ? l10n.voucherUsed
                          : l10n.voucherMarkUsed,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.storeDetail,
                    arguments: StoreDetailArgs(shop.id),
                  ),
                  child: Text(l10n.voucherViewStore),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _markUsed() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.voucherConfirmUseTitle),
        content: Text(l10n.voucherConfirmUseBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _voucherQrCubit.markUsed();
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.voucherMarkedUsed);
  }
}
