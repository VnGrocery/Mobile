import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class ReviewScreen extends StatefulWidget {
  final String shopId;

  const ReviewScreen({super.key, required this.shopId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final _comment = TextEditingController();
  bool _loading = false;
  bool _photoAttached = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _rating > 0 && _comment.text.trim().isNotEmpty && !_loading;

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _photoAttached
              ? 'Đã gửi đánh giá kèm ảnh. Cảm ơn bạn!'
              : 'Đã gửi đánh giá. Cảm ơn bạn!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _togglePhoto() {
    setState(() => _photoAttached = !_photoAttached);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _photoAttached ? 'Đã đính kèm ảnh demo' : 'Đã bỏ ảnh đính kèm',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Đánh giá cửa hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Trải nghiệm của bạn thế nào?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 24),
              child: Text(
                'Đánh giá của bạn giúp cộng đồng chọn sản phẩm tốt hơn.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final selected = index < _rating;
                return IconButton(
                  iconSize: 48,
                  onPressed: _loading
                      ? null
                      : () => setState(() => _rating = index + 1),
                  icon: Icon(
                    selected ? Icons.star : Icons.star_border,
                    color: selected
                        ? AppColors.warningOrange
                        : palette.textTertiary,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _comment,
              enabled: !_loading,
              maxLines: null,
              minLines: 6,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Nhập nhận xét của bạn tại đây...',
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _loading ? null : _togglePhoto,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: _photoAttached
                      ? palette.positiveBg
                      : palette.mutedSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _photoAttached ? Icons.check_circle : Icons.add_a_photo,
                      color:
                          _photoAttached ? AppColors.primaryGreen : Colors.grey,
                    ),
                    Text(
                      _photoAttached ? 'Đã thêm hình ảnh' : 'Thêm hình ảnh',
                      style: TextStyle(
                        color: _photoAttached
                            ? AppColors.primaryGreen
                            : Colors.grey,
                        fontSize: 12,
                        fontWeight: _photoAttached
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _canSubmit ? _submit : null,
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Gửi đánh giá',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
