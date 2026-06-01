import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class AiFreshnessScreen extends StatefulWidget {
  const AiFreshnessScreen({super.key});

  @override
  State<AiFreshnessScreen> createState() => _AiFreshnessScreenState();
}

class _AiFreshnessScreenState extends State<AiFreshnessScreen> {
  bool _analyzing = false;

  Future<void> _analyze() async {
    setState(() => _analyzing = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.buyerCheckResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Chụp ảnh kiểm tra thực tế')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Bước 2: Chụp ảnh miếng thịt tại sạp',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Hệ thống sẽ đối chứng chất lượng thực tế với cam kết của người bán.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _analyzing
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text('AI đang chấm điểm lại...',
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : const Icon(Icons.photo_camera,
                        size: 64, color: Color(0xFF555555)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _analyzing ? null : _analyze,
                child: const Text('Chụp ảnh & Đối chứng AI',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
