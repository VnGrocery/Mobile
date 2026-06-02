import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';

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
  String _category = 'Thịt bò';

  static const _categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Khác'
  ];

  @override
  void dispose() {
    _sellerScore.dispose();
    super.dispose();
  }

  String get _title => switch (_step) {
        1 => 'Bước 1: Chụp ảnh hàng',
        2 => 'Bước 2: Chấm điểm sản phẩm',
        _ => 'Bước 3: Xác nhận ghi nhận',
      };

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
    final data = AppDataHooks.instance;
    final score =
        _sellerScore.text.trim().isEmpty ? '8.5' : _sellerScore.text.trim();
    data.addPledge(
      widget.productId,
      PledgeHistoryItem(
        time: 'Vừa xong',
        title: 'Người bán thêm ghi nhận mới',
        description: 'Điểm đánh giá $score/10 cho loại: $_category.',
        isVerified: true,
        hasProof: true,
        proofId: data.nextId(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu ghi nhận sản phẩm.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: Text(_title),
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: switch (_step) {
          1 => _stepCapture(),
          2 => _stepEvaluate(),
          _ => _stepConfirm(),
        },
      ),
    );
  }

  Widget _stepCapture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 350,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(16)),
          child: const Center(
              child: Text('Camera Preview',
                  style: TextStyle(color: Color(0xFF555555)))),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: _analyzing ? null : _capture,
            child: _analyzing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.photo_camera),
                      SizedBox(width: 12),
                      Text('Chụp ảnh hàng hóa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _stepEvaluate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.card,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('ĐIỂM GỢI Ý TỪ ẢNH',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text('$_aiScore',
                    style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AppColors.freshGreen)),
                _categoryPill(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('ĐIỂM NGƯỜI BÁN NHẬP',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _sellerScore,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration:
              const InputDecoration(labelText: 'Nhập điểm đánh giá (0-10)'),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: () => setState(() => _step = 3),
            child: const Text('Tiếp tục xác nhận',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _categoryPill() {
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _category = v),
      itemBuilder: (_) => _categories
          .map((c) => PopupMenuItem(value: c, child: Text(c)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            color: AppColors.lightGray, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Loại: $_category',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _stepConfirm() {
    final score =
        _sellerScore.text.trim().isEmpty ? '8.5' : _sellerScore.text.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.meatRed.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.meatRed.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NỘI DUNG GHI NHẬN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.meatRed)),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tôi ghi nhận sản phẩm tại quầy với điểm đánh giá $score.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: _loading ? null : _commit,
            child: _loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Text('Xác nhận & lưu ghi nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
