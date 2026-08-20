import 'package:flutter/material.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class SellerDashboardHeader extends StatelessWidget {
  final String shopName;

  const SellerDashboardHeader({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shopName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.sellerModeSubtitle,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
