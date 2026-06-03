import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';

class SellerPledgeState {
  final int step;
  final bool analyzing;
  final bool committing;
  final bool committed;
  final String category;

  const SellerPledgeState({
    this.step = 1,
    this.analyzing = false,
    this.committing = false,
    this.committed = false,
    required this.category,
  });

  factory SellerPledgeState.initial() {
    return SellerPledgeState(
      category: SellerPledgePresenter.categories.first,
    );
  }

  SellerPledgeState copyWith({
    int? step,
    bool? analyzing,
    bool? committing,
    bool? committed,
    String? category,
  }) {
    return SellerPledgeState(
      step: step ?? this.step,
      analyzing: analyzing ?? this.analyzing,
      committing: committing ?? this.committing,
      committed: committed ?? this.committed,
      category: category ?? this.category,
    );
  }
}
