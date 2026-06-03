import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';

class AppSheetHandle extends StatelessWidget {
  const AppSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: context.palette.border,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
