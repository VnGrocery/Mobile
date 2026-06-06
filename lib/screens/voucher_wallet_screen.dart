import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_wallet_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/voucher_wallet_state.dart';
import 'package:vngrocery/features/vouchers/widgets/voucher_wallet_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class VoucherWalletScreen extends StatefulWidget {
  const VoucherWalletScreen({super.key});

  @override
  State<VoucherWalletScreen> createState() => _VoucherWalletScreenState();
}

class _VoucherWalletScreenState extends State<VoucherWalletScreen> {
  late final VoucherWalletCubit _walletCubit;

  @override
  void initState() {
    super.initState();
    _walletCubit = VoucherWalletCubit(
      userEmail: context.read<SessionCubit>().state.email,
    )..load();
  }

  @override
  void dispose() {
    _walletCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;

    return BlocProvider.value(
      value: _walletCubit,
      child: Scaffold(
        backgroundColor: palette.appBackground,
        appBar: AppBar(
          title: Text(l10n.voucherWalletTitle),
          actions: [
            IconButton(
              key: const ValueKey('voucher_wallet.add_manual_button'),
              tooltip: l10n.voucherWalletAddManualTooltip,
              onPressed: _openManualVoucher,
              icon: const Icon(Icons.add_card),
            ),
          ],
        ),
        body: BlocBuilder<VoucherWalletCubit, VoucherWalletState>(
          builder: (context, state) {
            final visibleWallet = state.visibleWallet;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VoucherSummaryCard(
                  usableCount: state.usableCount,
                  total: state.wallet.length,
                ),
                const SizedBox(height: 16),
                VoucherWalletToolbar(
                  showUsed: state.showUsed,
                  onShowUsedChanged: _walletCubit.setShowUsed,
                ),
                const SizedBox(height: 12),
                if (visibleWallet.isEmpty)
                  const VoucherEmptyState()
                else
                  for (final item in visibleWallet)
                    if (state.voucherOrNull(item.voucherId) case final voucher?)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VoucherWalletCard(
                          userVoucher: item,
                          voucher: voucher,
                          shop: state.shopOrNull(voucher.shopId),
                          onChanged: _walletCubit.load,
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openManualVoucher() async {
    await Navigator.pushNamed(context, Routes.manualVoucher);
    if (mounted) _walletCubit.load();
  }
}
