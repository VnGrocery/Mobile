import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'voucher_components.dart';

class ManualVoucherNotice extends StatelessWidget {
  const ManualVoucherNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const VoucherNotice(
      text:
          'Voucher thủ công là thông tin do bạn tự nhập để lưu trữ và sử dụng tại quầy. Nội dung này chưa được cửa hàng xác thực, bạn tự chịu trách nhiệm về điều kiện sử dụng.',
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
    return DropdownButtonFormField<String>(
      initialValue: shopId,
      decoration: const InputDecoration(
        labelText: 'Cửa hàng áp dụng',
        prefixIcon: Icon(Icons.storefront),
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
  final ValueChanged<String> onScanDemo;

  const ManualVoucherScanActions({super.key, required this.onScanDemo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onScanDemo('QR'),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Quét QR'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onScanDemo('Mã vạch'),
            icon: const Icon(Icons.document_scanner),
            label: const Text('Quét mã vạch'),
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
    return Column(
      children: [
        TextFormField(
          controller: code,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Mã voucher',
            prefixIcon: Icon(Icons.confirmation_number),
          ),
          validator: (value) {
            if ((value ?? '').trim().isEmpty) return 'Nhập mã voucher';
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: title,
          decoration: const InputDecoration(
            labelText: 'Tên gợi nhớ',
            hintText: 'VD: Giảm 20% mua thịt cuối tuần',
            prefixIcon: Icon(Icons.local_offer),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: note,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Ghi chú của bạn',
            hintText: 'Điều kiện sử dụng, nguồn nhận mã, lưu ý tại quầy...',
            prefixIcon: Icon(Icons.note),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event),
      title: const Text('Hạn dùng'),
      subtitle: Text('${expiresAt.day}/${expiresAt.month}/${expiresAt.year}'),
      trailing: TextButton(
        onPressed: onPickExpiry,
        child: const Text('Đổi ngày'),
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
        onPressed: onSave,
        icon: const Icon(Icons.save),
        label: const Text('Lưu vào ví'),
      ),
    );
  }
}
