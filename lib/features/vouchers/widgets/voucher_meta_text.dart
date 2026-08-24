import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';

/// The 11px line under an offer's title: minimum spend, expiry, how many are
/// left. [warn] is for the one that says the offer is over, which has to stand
/// out from the ones that are merely conditions.
class VoucherMetaText extends StatelessWidget {
  final String text;
  final bool warn;

  const VoucherMetaText(this.text, {super.key, this.warn = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: warn ? FontWeight.bold : FontWeight.normal,
        color: warn ? palette.warnInk : palette.textTertiary,
      ),
    );
  }
}
