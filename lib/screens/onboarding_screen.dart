import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class _Page {
  final String title;
  final String desc;
  final IconData icon;
  const _Page(this.title, this.desc, this.icon);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _Page(
      'Xem cam kết chất lượng',
      'Mọi sản phẩm từ người bán đều có cam kết điểm số AI minh bạch.',
      Icons.verified_user,
    ),
    _Page(
      'Chụp ảnh kiểm tra',
      'Chụp ảnh ngay tại sạp để AI đối chiếu chất lượng thực tế tức thì.',
      Icons.photo_camera,
    ),
    _Page(
      'Ra quyết định dễ dàng',
      'Mua sắm an tâm hơn khi mọi bằng chứng chất lượng đều được xác thực.',
      Icons.check_circle,
    ),
  ];

  void _finish() => Navigator.pushReplacementNamed(context, Routes.auth);

  void _next() {
    if (_page == _pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(_pages.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 8),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.meatRed : const Color(0xFFD3D3D3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            FilledButton(
              onPressed: _next,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isLast ? 'Bắt đầu' : 'Tiếp tục'),
                  if (!isLast) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Bỏ qua',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.meatRed.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(p.icon,
                              size: 60, color: AppColors.meatRed),
                        ),
                        const SizedBox(height: 48),
                        Text(p.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Text(p.desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
