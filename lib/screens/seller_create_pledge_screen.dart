import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../features/seller_pledges/seller_pledge_presenter.dart';
import '../features/seller_pledges/widgets/seller_pledge_steps.dart';
import '../theme/app_palette.dart';

class SellerCreatePledgeScreen extends StatefulWidget {
  final String productId;

  const SellerCreatePledgeScreen({super.key, required this.productId});

  @override
  State<SellerCreatePledgeScreen> createState() =>
      _SellerCreatePledgeScreenState();
}

class _SellerCreatePledgeScreenState extends State<SellerCreatePledgeScreen> {
  int _step = 1;
  bool _analyzing = false;
  bool _loading = false;

  final double _aiScore = 8.2;
  final _sellerScore = TextEditingController(text: '8.5');
  String _category = SellerPledgePresenter.categories.first;

  @override
  void dispose() {
    _sellerScore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(SellerPledgePresenter.titleForStep(_step)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: switch (_step) {
          1 => SellerPledgeCaptureStep(
              analyzing: _analyzing,
              onCapture: _capture,
            ),
          2 => SellerPledgeEvaluateStep(
              aiScore: _aiScore,
              sellerScore: _sellerScore,
              category: _category,
              onCategoryChanged: (category) =>
                  setState(() => _category = category),
              onContinue: () => setState(() => _step = 3),
            ),
          _ => SellerPledgeConfirmStep(
              score: SellerPledgePresenter.normalizedScore(_sellerScore.text),
              loading: _loading,
              onCommit: _commit,
            ),
        },
      ),
    );
  }

  void _back() {
    if (_step > 1) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _capture() async {
    setState(() => _analyzing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _step = 2;
    });
  }

  Future<void> _commit() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final score = SellerPledgePresenter.normalizedScore(_sellerScore.text);
    SellerPledgePresenter.addPledge(
      productId: widget.productId,
      score: score,
      category: _category,
    );
    if (!mounted) return;
    AppFeedback.showSnackBar(context, 'Đã lưu ghi nhận sản phẩm.');
    Navigator.pop(context);
  }
}
