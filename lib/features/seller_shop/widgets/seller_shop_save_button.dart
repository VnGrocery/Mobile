import 'package:flutter/material.dart';

class SellerShopSaveButton extends StatelessWidget {
  final bool saving;
  final bool enabled;
  final VoidCallback onSave;

  const SellerShopSaveButton({
    super.key,
    required this.saving,
    required this.enabled,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: saving || !enabled ? null : onSave,
        icon: saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save),
        label: Text(saving ? 'Đang lưu...' : 'Lưu thay đổi'),
      ),
    );
  }
}
