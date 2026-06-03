import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class SellerPledgePresenter {
  const SellerPledgePresenter._();

  static final AppRepositories _repos = AppRepositories.instance;

  static const categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Khác',
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
    _repos.pledges.add(
      productId,
      PledgeHistoryItem(
        time: 'Vừa xong',
        title: 'Người bán thêm ghi nhận mới',
        description: 'Điểm đánh giá $score/10 cho loại: $category.',
        isVerified: true,
        hasProof: true,
        proofId: _repos.ids.nextId(),
      ),
    );
  }
}
