import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SellerShopTextField(
          controller: name,
          label: l10n.sellerShopNameLabel,
          icon: Icons.storefront,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: description,
          label: l10n.sellerShopDescriptionLabel,
          icon: Icons.notes,
          maxLines: 4,
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
        SellerShopTextField(
          controller: address,
          label: l10n.sellerShopAddressLabel,
          icon: Icons.location_on,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
