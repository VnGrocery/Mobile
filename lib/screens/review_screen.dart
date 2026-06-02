import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../features/reviews/widgets/review_components.dart';
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

  bool get _canSubmit =>
      _rating > 0 && _comment.text.trim().isNotEmpty && !_loading;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Đánh giá cửa hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ReviewIntro(),
            RatingPicker(
              rating: _rating,
              enabled: !_loading,
              onChanged: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 32),
            ReviewCommentField(
              controller: _comment,
              enabled: !_loading,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            ReviewPhotoAttachment(
              attached: _photoAttached,
              enabled: !_loading,
              onTap: _togglePhoto,
            ),
            const Spacer(),
            ReviewSubmitButton(
              enabled: _canSubmit,
              loading: _loading,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    AppFeedback.showSnackBar(
      context,
      _photoAttached
          ? 'Đã gửi đánh giá kèm ảnh. Cảm ơn bạn!'
          : 'Đã gửi đánh giá. Cảm ơn bạn!',
    );
    Navigator.pop(context);
  }

  void _togglePhoto() {
    setState(() => _photoAttached = !_photoAttached);
    AppFeedback.showSnackBar(
      context,
      _photoAttached ? 'Đã đính kèm ảnh demo' : 'Đã bỏ ảnh đính kèm',
    );
  }
}
