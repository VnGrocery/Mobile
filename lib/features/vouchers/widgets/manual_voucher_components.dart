import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'voucher_components.dart';

class ManualVoucherNotice extends StatelessWidget {
  const ManualVoucherNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return VoucherNotice(
      text: AppLocalizations.of(context).manualVoucherNotice,
    );
  }
}

class ManualVoucherShopPicker extends StatelessWidget {
  final String? shopId;
  final List<Shop> shops;
  final ValueChanged<String?> onChanged;

  const ManualVoucherShopPicker({
    super.key,
    required this.shopId,
    required this.shops,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DropdownButtonFormField<String>(
      initialValue: shopId,
      decoration: InputDecoration(
        labelText: l10n.manualVoucherShopLabel,
        prefixIcon: const Icon(Icons.storefront),
      ),
      items: shops
          .map(
            (shop) => DropdownMenuItem(
              value: shop.id,
              child: Text(shop.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class ManualVoucherScanActions extends StatelessWidget {
  final ValueChanged<String> onScan;

  const ManualVoucherScanActions({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            key: const ValueKey('manual_voucher.scan_qr_button'),
            onPressed: () => onScan('QR'),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.manualVoucherScanQr),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            key: const ValueKey('manual_voucher.scan_barcode_button'),
            onPressed: () => onScan(l10n.voucherBarcode),
            icon: const Icon(Icons.document_scanner),
            label: Text(l10n.manualVoucherScanBarcode),
          ),
        ),
      ],
    );
  }
}

class ManualVoucherFields extends StatelessWidget {
  final TextEditingController code;
  final TextEditingController title;
  final TextEditingController note;

  const ManualVoucherFields({
    super.key,
    required this.code,
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        TextFormField(
          key: const ValueKey('manual_voucher.code_field'),
          controller: code,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: l10n.manualVoucherCodeLabel,
            prefixIcon: const Icon(Icons.confirmation_number),
          ),
          validator: (value) {
            if ((value ?? '').trim().isEmpty) {
              return l10n.manualVoucherCodeRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          key: const ValueKey('manual_voucher.title_field'),
          controller: title,
          decoration: InputDecoration(
            labelText: l10n.manualVoucherTitleLabel,
            hintText: l10n.manualVoucherTitleHint,
            prefixIcon: const Icon(Icons.local_offer),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          key: const ValueKey('manual_voucher.note_field'),
          controller: note,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: l10n.manualVoucherNoteLabel,
            hintText: l10n.manualVoucherNoteHint,
            prefixIcon: const Icon(Icons.note),
          ),
        ),
      ],
    );
  }
}

class ManualVoucherExpiryTile extends StatelessWidget {
  final DateTime expiresAt;
  final VoidCallback onPickExpiry;

  const ManualVoucherExpiryTile({
    super.key,
    required this.expiresAt,
    required this.onPickExpiry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event),
      title: Text(l10n.manualVoucherExpiryLabel),
      subtitle: Text('${expiresAt.day}/${expiresAt.month}/${expiresAt.year}'),
      trailing: TextButton(
        onPressed: onPickExpiry,
        child: Text(l10n.manualVoucherChangeDate),
      ),
    );
  }
}

class ManualVoucherSaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const ManualVoucherSaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        key: const ValueKey('manual_voucher.save_button'),
        onPressed: onSave,
        icon: const Icon(Icons.save),
        label: Text(AppLocalizations.of(context).manualVoucherSaveToWallet),
      ),
    );
  }
}
