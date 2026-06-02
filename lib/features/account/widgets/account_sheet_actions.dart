import 'package:flutter/material.dart';

import '../../../theme/app_palette.dart';
import 'account_edit_profile_sheet.dart';
import 'account_help_sheet.dart';

Future<bool?> showAccountEditProfileSheet(
  BuildContext context, {
  required String initialName,
  required String initialEmail,
  required void Function(String name, String email) onSave,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.palette.appBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => AccountEditProfileSheet(
      initialName: initialName,
      initialEmail: initialEmail,
      onSave: onSave,
    ),
  );
}

void showAccountHelpSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.palette.appBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const AccountHelpSheet(),
  );
}
