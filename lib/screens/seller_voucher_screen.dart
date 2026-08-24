import 'package:flutter/material.dart';

import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_empty_state.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_shop_text_field.dart';
import 'package:vngrocery/features/vouchers/widgets/voucher_meta_text.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/utils/format.dart';

/// The shop's own offers: what is running, how much of it is gone, and the
/// form that makes another.
///
/// The quantity is the point of the screen. An offer with no cap is a promise
/// the shop cannot count, so the field defaults to a number and says plainly
/// what leaving it blank means.
class SellerVoucherScreen extends StatefulWidget {
  final String shopId;

  const SellerVoucherScreen({super.key, required this.shopId});

  @override
  State<SellerVoucherScreen> createState() => _SellerVoucherScreenState();
}

class _SellerVoucherScreenState extends State<SellerVoucherScreen> {
  List<Voucher> _offers = const [];
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) {
      setState(() {
        _loading = false;
        _failed = true;
      });
      return;
    }
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final offers = await remote.shopVouchers(widget.shopId);
      if (!mounted) return;
      setState(() {
        _offers = offers;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(
          l10n.sellerVouchersTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreenInk,
        foregroundColor: Colors.white,
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: Text(l10n.voucherCreateAction),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _body(l10n),
      ),
    );
  }

  Widget _body(AppLocalizations l10n) {
    final bottom = 96 + MediaQuery.paddingOf(context).bottom;

    if (_failed || _offers.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16, 40, 16, bottom),
        children: [
          if (_failed)
            SellerEmptyState(
              icon: Icons.cloud_off,
              title: l10n.voucherFailed,
              body: l10n.commentsFailedBody,
              actionLabel: l10n.homeRetryAction,
              onAction: _load,
            )
          else
            SellerEmptyState(
              icon: Icons.local_activity_outlined,
              title: l10n.sellerVouchersEmptyTitle,
              body: l10n.sellerVouchersEmptyBody,
              actionLabel: l10n.voucherCreateAction,
              onAction: _openCreate,
            ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemCount: _offers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _OfferRow(offer: _offers[index]),
    );
  }

  Future<void> _openCreate() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CreateVoucherSheet(shopId: widget.shopId),
    );
    if (created == true) await _load();
  }
}

class _OfferRow extends StatelessWidget {
  final Voucher offer;

  const _OfferRow({required this.offer});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final discount = offer.isPercent
        ? l10n.homeOfferPercent(offer.discountValue)
        : l10n.homeOfferAmount(formatVnd(offer.discountValue));
    final expired = !DateTime.now().isBefore(offer.expiresAt);

    return Container(
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                discount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: palette.greenInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            offer.code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // What the shop most wants to know: how much of the offer is gone.
          Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 14,
                color: palette.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                offer.limited
                    ? l10n.sellerVouchersClaimedOf(
                        offer.claimedCount,
                        offer.totalQuantity,
                      )
                    : l10n.sellerVouchersClaimedFree(offer.claimedCount),
                style: TextStyle(fontSize: 12, color: palette.textSecondary),
              ),
            ],
          ),
          if (offer.limited) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: offer.totalQuantity == 0
                    ? 0
                    : offer.claimedCount / offer.totalQuantity,
                minHeight: 6,
                // mutedSurface is the card colour, so an untouched offer used
                // to render as a blank gap. Tint the track from the fill
                // instead, so 0/N still reads as an empty bar.
                backgroundColor: palette.greenInk.withValues(alpha: 0.18),
                valueColor: AlwaysStoppedAnimation(palette.greenInk),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 2,
            children: [
              if (offer.minSpend > 0)
                VoucherMetaText(
                  l10n.homeOfferMinSpend(formatVnd(offer.minSpend)),
                ),
              VoucherMetaText(
                l10n.homeOfferExpiry(formatShortDate('${offer.expiresAt}')),
              ),
              // States the shop can act on, said plainly rather than implied
              // by a greyed-out row.
              if (expired) VoucherMetaText(l10n.voucherSoldOut, warn: true),
              if (!expired && offer.soldOut)
                VoucherMetaText(l10n.voucherSoldOut, warn: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateVoucherSheet extends StatefulWidget {
  final String shopId;

  const _CreateVoucherSheet({required this.shopId});

  @override
  State<_CreateVoucherSheet> createState() => _CreateVoucherSheetState();
}

class _CreateVoucherSheetState extends State<_CreateVoucherSheet> {
  final _code = TextEditingController();
  final _title = TextEditingController();
  final _discount = TextEditingController();
  final _minSpend = TextEditingController();
  final _quantity = TextEditingController(text: '50');

  bool _isPercent = true;
  bool _saving = false;
  DateTime _expiresAt = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _discount.dispose();
    _minSpend.dispose();
    _quantity.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_saving) return false;
    if (_code.text.trim().isEmpty || _title.text.trim().isEmpty) return false;
    final discount = SellerProductPresenter.parsePrice(_discount.text);
    if (discount <= 0) return false;
    // A percentage over 100 is not a discount, it is a refund.
    if (_isPercent && discount > 100) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.voucherCreateTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SellerShopTextField(
              controller: _title,
              label: l10n.voucherFieldTitle,
              icon: Icons.label_outline,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SellerShopTextField(
              controller: _code,
              label: l10n.voucherFieldCode,
              icon: Icons.qr_code_2,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SellerShopTextField(
              controller: _discount,
              label: l10n.voucherFieldDiscount,
              icon: Icons.percent,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isPercent,
              onChanged: (value) => setState(() => _isPercent = value),
              title: Text(
                l10n.voucherFieldPercent,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            SellerShopTextField(
              controller: _minSpend,
              label: l10n.voucherFieldMinSpend,
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SellerShopTextField(
              controller: _quantity,
              label: l10n.voucherFieldQuantity,
              icon: Icons.confirmation_number_outlined,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.voucherFieldQuantityHint,
              style: TextStyle(
                fontSize: 12,
                color: context.palette.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.event_outlined,
                color: context.palette.greenInk,
              ),
              title: Text(
                l10n.voucherFieldExpiry,
                style: const TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                formatShortDate('$_expiresAt'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: TextButton(
                onPressed: _pickExpiry,
                child: Text(l10n.voucherPickExpiry),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _canSave ? _save : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.voucherCreateAction),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt,
      // Today is already too late for an offer to be worth anything.
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final remote = AppRepositories.instance.products.remote;
    if (remote == null) return;
    setState(() => _saving = true);
    try {
      await remote.createVoucher(
        shopId: widget.shopId,
        code: _code.text.trim().toUpperCase(),
        title: _title.text.trim(),
        discountValue: SellerProductPresenter.parsePrice(_discount.text),
        isPercent: _isPercent,
        minSpend: SellerProductPresenter.parsePrice(_minSpend.text),
        // Blank means uncapped, which is what the hint under the field says.
        totalQuantity: SellerProductPresenter.parsePrice(_quantity.text),
        expiresAt: _expiresAt,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      // The server rejects a duplicate code with 400; saying so beats a
      // generic failure the seller cannot act on.
      final taken = error is ApiException && error.statusCode == 400;
      AppFeedback.showSnackBar(
        context,
        taken ? l10n.voucherCodeTaken : l10n.voucherCreateFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    Navigator.pop(context, true);
    AppFeedback.showSnackBar(context, l10n.voucherCreated);
  }
}
