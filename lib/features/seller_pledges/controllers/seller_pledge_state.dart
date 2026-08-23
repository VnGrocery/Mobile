import 'package:vngrocery/features/home/category_presenter.dart';

class SellerPledgeState {
  final int step;
  final bool analyzing;
  final bool committing;
  final bool committed;
  final String category;
  final double aiScore;
  final double confidence;
  final String imageHash;
  final String imageCid;

  const SellerPledgeState({
    this.step = 1,
    this.analyzing = false,
    this.committing = false,
    this.committed = false,
    required this.category,
    this.aiScore = 8.2,
    this.confidence = 0,
    this.imageHash = '',
    this.imageCid = '',
  });

  factory SellerPledgeState.initial() {
    return SellerPledgeState(category: CategoryPresenter.selectable.first);
  }

  SellerPledgeState copyWith({
    int? step,
    bool? analyzing,
    bool? committing,
    bool? committed,
    String? category,
    double? aiScore,
    double? confidence,
    String? imageHash,
    String? imageCid,
  }) {
    return SellerPledgeState(
      step: step ?? this.step,
      analyzing: analyzing ?? this.analyzing,
      committing: committing ?? this.committing,
      committed: committed ?? this.committed,
      category: category ?? this.category,
      aiScore: aiScore ?? this.aiScore,
      confidence: confidence ?? this.confidence,
      imageHash: imageHash ?? this.imageHash,
      imageCid: imageCid ?? this.imageCid,
    );
  }
}
