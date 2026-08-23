import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/buyer_check/widgets/buyer_compare_card.dart';
import 'package:vngrocery/features/buyer_check/controllers/buyer_check_cubit.dart';
import 'package:vngrocery/features/buyer_check/controllers/buyer_check_state.dart';
import 'package:vngrocery/features/buyer_check/widgets/buyer_check_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class BuyerCheckResultScreen extends StatefulWidget {
  const BuyerCheckResultScreen({super.key});

  @override
  State<BuyerCheckResultScreen> createState() => _BuyerCheckResultScreenState();
}

class _BuyerCheckResultScreenState extends State<BuyerCheckResultScreen> {
  final _voucher = TextEditingController(text: 'FRESH20');
  late final BuyerCheckCubit _buyerCheckCubit;

  @override
  void initState() {
    super.initState();
    _buyerCheckCubit = BuyerCheckCubit()..loadDemoResult();
  }

  @override
  void dispose() {
    _buyerCheckCubit.close();
    _voucher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _buyerCheckCubit,
      child: BlocBuilder<BuyerCheckCubit, BuyerCheckState>(
        builder: (context, state) {
          final result = state.result;
          final product = state.product;
          final shop = state.shop;
          if (result == null || product == null || shop == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: Text(l10n.buyerCheckResultTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            key: const ValueKey('buyer_check_result.screen'),
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: Text(l10n.buyerCheckResultTitle)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  BuyerScoreSummary(result: result),
                  const SizedBox(height: 32),
                  BuyerVerdictCard(result: result),
                  const SizedBox(height: 16),
                  BuyerCompareCard(result: result),
                  const SizedBox(height: 16),
                  VoucherCheckCard(
                    controller: _voucher,
                    product: product,
                    shop: shop,
                    result: state.voucherResult,
                    onCheck: _checkVoucher,
                    onSaveVoucher: _saveVoucherToWallet,
                    onOpenWallet: () =>
                        Navigator.pushNamed(context, Routes.voucherWallet),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => _openStore(shop),
                      child: Text(
                        l10n.buyerCheckViewStore,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.buyerCheckRetake,
                      style: TextStyle(color: context.palette.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkVoucher() async {
    FocusScope.of(context).unfocus();
    await _buyerCheckCubit.checkVoucherRemote(_voucher.text);
  }

  Future<void> _saveVoucherToWallet(Voucher voucher) async {
    await _buyerCheckCubit.saveVoucherToWalletRemote(
      userEmail: context.read<SessionCubit>().state.email,
      voucher: voucher,
    );
    if (!mounted) return;
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).buyerCheckVoucherSaved,
    );
  }

  void _openStore(Shop shop) {
    final shopId = context.read<SessionCubit>().state.shopId ?? shop.id;
    Navigator.pushNamed(
      context,
      Routes.storeDetail,
      arguments: StoreDetailArgs(shopId),
    );
  }
}
