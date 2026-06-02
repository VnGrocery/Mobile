import '../../data/data_hooks.dart';
import '../../data/models.dart';

class SellerPledgePresenter {
  const SellerPledgePresenter._();

  static const categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Khác'
  ];

  static String titleForStep(int step) {
    return switch (step) {
      1 => 'Bước 1: Chụp ảnh hàng',
      2 => 'Bước 2: Chấm điểm sản phẩm',
      _ => 'Bước 3: Xác nhận ghi nhận',
    };
  }

  static String normalizedScore(String raw) {
    return raw.trim().isEmpty ? '8.5' : raw.trim();
  }

  static void addPledge({
    required String productId,
    required String score,
    required String category,
  }) {
    final data = AppDataHooks.instance;
    data.addPledge(
      productId,
      PledgeHistoryItem(
        time: 'Vừa xong',
        title: 'Người bán thêm ghi nhận mới',
        description: 'Điểm đánh giá $score/10 cho loại: $category.',
        isVerified: true,
        hasProof: true,
        proofId: data.nextId(),
      ),
    );
  }
}
