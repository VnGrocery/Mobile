import 'package:flutter/material.dart';

class SellerPledgeCaptureStep extends StatelessWidget {
  final bool analyzing;
  final VoidCallback onCapture;

  const SellerPledgeCaptureStep({
    super.key,
    required this.analyzing,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Camera Preview',
              style: TextStyle(color: Color(0xFF555555)),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: analyzing ? null : onCapture,
            child: analyzing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera),
                      SizedBox(width: 12),
                      Text(
                        'Chụp ảnh hàng hóa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
