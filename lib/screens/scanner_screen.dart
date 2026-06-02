import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class ScannerScreen extends StatefulWidget {
  final double bottomContentInset;

  const ScannerScreen({super.key, this.bottomContentInset = 0});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _line = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  Future<void> _simulate() async {
    setState(() => _verifying = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _verifying = false);
    Navigator.pushNamed(context, Routes.aiCompare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Text('Camera Preview...',
                style: TextStyle(color: Color(0xFF555555), fontSize: 18)),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.bottomContentInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Quét sản phẩm',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Đưa mã QR hoặc tem sản phẩm vào khung hình',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _line,
                          builder: (_, __) => Positioned(
                            top: _line.value * 278,
                            left: 0,
                            right: 0,
                            child: Container(height: 2, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _verifying ? Icons.gps_fixed : Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _verifying
                              ? 'Đang kiểm tra vị trí quầy hàng...'
                              : 'Sẵn sàng kiểm tra sản phẩm',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _verifying ? null : _simulate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(220, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      _verifying ? 'Đang kiểm tra...' : 'Giả lập quét sản phẩm',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(Icons.arrow_back, () => Navigator.pop(context)),
                  _circleBtn(Icons.flash_on, () {}),
                ],
              ),
            ),
          ),
          if (_verifying)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text('Đang kiểm tra sản phẩm...',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
