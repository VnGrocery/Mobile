import 'package:flutter/material.dart';

import '../data/session.dart';
import '../features/vouchers/voucher_presenter.dart';
import '../features/vouchers/widgets/voucher_wallet_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_palette.dart';

class VoucherWalletScreen extends StatefulWidget {
  const VoucherWalletScreen({super.key});

  @override
  State<VoucherWalletScreen> createState() => _VoucherWalletScreenState();
}

class _VoucherWalletScreenState extends State<VoucherWalletScreen> {
  bool _showUsed = false;

  @override
  Widget build(BuildContext context) {
    final email = SessionManager.instance.email;
    final wallet = VoucherPresenter.wallet(email);
    final visibleWallet = VoucherPresenter.visibleWallet(
      wallet,
      showUsed: _showUsed,
    );
    final usableCount = VoucherPresenter.usableCount(wallet);
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.appBackground,
      appBar: AppBar(
        title: const Text('Ví voucher'),
        actions: [
          IconButton(
            tooltip: 'Thêm thủ công',
            onPressed: _openManualVoucher,
            icon: const Icon(Icons.add_card),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VoucherSummaryCard(
            usableCount: usableCount,
            total: wallet.length,
          ),
          const SizedBox(height: 16),
          VoucherWalletToolbar(
            showUsed: _showUsed,
            onShowUsedChanged: (value) => setState(() => _showUsed = value),
          ),
          const SizedBox(height: 12),
          if (visibleWallet.isEmpty)
            const VoucherEmptyState()
          else
            for (final item in visibleWallet)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: VoucherWalletCard(
                  userVoucher: item,
                  voucher: VoucherPresenter.voucher(item.voucherId),
                  onChanged: () => setState(() {}),
                ),
              ),
        ],
      ),
    );
  }

  Future<void> _openManualVoucher() async {
    await Navigator.pushNamed(context, Routes.manualVoucher);
    if (mounted) setState(() {});
  }
}
