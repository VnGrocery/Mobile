import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../data/session.dart';
import '../features/vouchers/voucher_presenter.dart';
import '../features/vouchers/widgets/voucher_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
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
    final data = AppDataHooks.instance;
    final email = SessionManager.instance.email;
    final wallet = data.getUserVouchers(email);
    final visibleWallet =
        wallet.where((item) => _showUsed || !item.isUsed).toList();
    final usableCount = wallet.where((item) => !item.isUsed).length;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.appBackground,
      appBar: AppBar(
        title: const Text('Ví voucher'),
        actions: [
          IconButton(
            tooltip: 'Thêm thủ công',
            onPressed: () async {
              await Navigator.pushNamed(context, Routes.manualVoucher);
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.add_card),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _VoucherSummaryCard(
            usableCount: usableCount,
            total: wallet.length,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Voucher của bạn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              FilterChip(
                selected: _showUsed,
                showCheckmark: false,
                label: const Text('Hiện đã dùng'),
                onSelected: (value) => setState(() => _showUsed = value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (visibleWallet.isEmpty)
            const _VoucherEmptyState()
          else
            ...visibleWallet.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VoucherWalletCard(
                  userVoucher: item,
                  voucher: data.getVoucher(item.voucherId),
                  onChanged: () => setState(() {}),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VoucherSummaryCard extends StatelessWidget {
  final int usableCount;
  final int total;

  const _VoucherSummaryCard({
    required this.usableCount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.positiveBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.wallet, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$usableCount voucher có thể dùng',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'Tổng cộng $total voucher trong ví',
                  style: TextStyle(color: palette.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherEmptyState extends StatelessWidget {
  const _VoucherEmptyState();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Chưa có voucher phù hợp',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Quét sản phẩm, nhập mã hoặc thêm thủ công để lưu voucher vào ví.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _VoucherWalletCard extends StatelessWidget {
  final UserVoucher userVoucher;
  final Voucher voucher;
  final VoidCallback onChanged;

  const _VoucherWalletCard({
    required this.userVoucher,
    required this.voucher,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final shop = data.getShop(voucher.shopId);
    final palette = context.palette;
    final expired = VoucherPresenter.isExpired(voucher);
    final disabled = VoucherPresenter.isDisabled(userVoucher, voucher);
    final statusColor =
        userVoucher.isUsed || expired ? Colors.grey : AppColors.primaryGreen;

    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled
            ? null
            : () async {
                await Navigator.pushNamed(
                  context,
                  Routes.voucherQr,
                  arguments: userVoucher.id,
                );
                onChanged();
              },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        disabled ? palette.mutedSurface : palette.positiveBg,
                    child: Icon(
                      userVoucher.isUsed ? Icons.check : Icons.local_offer,
                      color: disabled ? Colors.grey : AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          shop.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VoucherPill(
                    label: VoucherPresenter.statusLabel(userVoucher, voucher),
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  VoucherMeta(
                    icon:
                        voucher.isManual ? Icons.document_scanner : Icons.sell,
                    label: VoucherPresenter.discountLabel(voucher),
                  ),
                  const SizedBox(width: 10),
                  VoucherMeta(
                    icon: Icons.receipt_long,
                    label: VoucherPresenter.spendLabel(voucher),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mã: ${voucher.code}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  voucher.isManual
                      ? const ManualVoucherBadge()
                      : Text(
                          VoucherPresenter.expiryLabel(voucher),
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
              if (voucher.isManual && voucher.note.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  voucher.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
