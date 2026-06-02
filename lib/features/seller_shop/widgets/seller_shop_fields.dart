import 'package:flutter/material.dart';

import 'seller_shop_text_field.dart';

class SellerShopFields extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController description;
  final TextEditingController address;
  final ValueChanged<String> onChanged;

  const SellerShopFields({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SellerShopTextField(
          controller: name,
          label: 'Tên cửa hàng',
          icon: Icons.storefront,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: description,
          label: 'Mô tả',
          icon: Icons.notes,
          maxLines: 4,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: address,
          label: 'Địa chỉ',
          icon: Icons.location_on,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
