import 'package:flutter/material.dart';

class SellerShopTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  /// A number field gets the number pad. Typing a price on the letter
  /// keyboard is the sort of friction a seller feels every single time.
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const SellerShopTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
