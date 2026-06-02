import 'package:flutter/material.dart';

class VoucherCheckInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCheck;

  const VoucherCheckInputRow({
    super.key,
    required this.controller,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Mã voucher',
              hintText: 'VD: FRESH20',
              prefixIcon: Icon(Icons.confirmation_number),
            ),
            onSubmitted: (_) => onCheck(),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 56,
          child:
              FilledButton(onPressed: onCheck, child: const Text('Kiểm tra')),
        ),
      ],
    );
  }
}
