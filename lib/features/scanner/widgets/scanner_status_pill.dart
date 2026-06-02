import 'package:flutter/material.dart';

class ScannerStatusPill extends StatelessWidget {
  final bool verifying;

  const ScannerStatusPill({super.key, required this.verifying});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verifying ? Icons.gps_fixed : Icons.location_on,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            verifying
                ? 'Đang kiểm tra vị trí quầy hàng...'
                : 'Sẵn sàng kiểm tra sản phẩm',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
