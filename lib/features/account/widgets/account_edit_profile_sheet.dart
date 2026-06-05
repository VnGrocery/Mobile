import 'package:flutter/material.dart';

import 'package:vngrocery/core/ui/app_sheet.dart';
import 'package:vngrocery/core/validation/app_validators.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

class AccountEditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final void Function(String name, String email) onSave;

  const AccountEditProfileSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onSave,
  });

  @override
  State<AccountEditProfileSheet> createState() =>
      _AccountEditProfileSheetState();
}

class _AccountEditProfileSheetState extends State<AccountEditProfileSheet> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AppSheetHandle()),
            const SizedBox(height: 18),
            Text(
              l10n.accountEditProfile,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                labelText: l10n.authDisplayNameLabel,
                prefixIcon: const Icon(Icons.person),
              ),
              validator: AppValidators.displayName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.authEmailLabel,
                prefixIcon: const Icon(Icons.email),
              ),
              validator: AppValidators.email,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  widget.onSave(_name.text, _email.text);
                  Navigator.pop(context, true);
                },
                child: Text(l10n.accountSaveProfileChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
