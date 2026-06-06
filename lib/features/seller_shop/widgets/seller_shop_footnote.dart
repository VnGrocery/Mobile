import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

class SellerShopFootnote extends StatelessWidget {
  const SellerShopFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).sellerShopFootnote,
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
    );
  }
}
