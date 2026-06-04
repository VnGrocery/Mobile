import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'seller_pledge_state.dart';

class SellerPledgeCubit extends Cubit<SellerPledgeState> {
  final AppDelayService _delayService;
  final AppRepositories _repositories;
  final String productId;
  final Duration analyzeDelay;
  final Duration commitDelay;

  SellerPledgeCubit({
    required this.productId,
    this.analyzeDelay = const Duration(milliseconds: 1500),
    this.commitDelay = const Duration(milliseconds: 900),
    AppDelayService delayService = AppDelayService.instance,
    AppRepositories? repositories,
  })  : _delayService = delayService,
        _repositories = repositories ?? AppRepositories.instance,
        super(SellerPledgeState.initial());

  void back() {
    if (state.step <= 1) return;
    emit(state.copyWith(step: state.step - 1, committed: false));
  }

  Future<void> capture() async {
    if (state.analyzing) return;
    emit(state.copyWith(analyzing: true, committed: false));
    await _delayService.waitDuration(analyzeDelay);
    emit(state.copyWith(analyzing: false, step: 2));
  }

  void setCategory(String category) {
    emit(state.copyWith(category: category, committed: false));
  }

  void continueToConfirm() {
    emit(state.copyWith(step: 3, committed: false));
  }

  Future<void> commit(String rawScore) async {
    if (state.committing) return;
    emit(state.copyWith(committing: true, committed: false));
    await _delayService.waitDuration(commitDelay);
    final score = SellerPledgePresenter.normalizedScore(rawScore);
    _repositories.pledges.add(
      productId,
      PledgeHistoryItem(
        time: 'Vừa xong',
        title: 'Người bán thêm ghi nhận mới',
        description: 'Điểm đánh giá $score/10 cho loại: ${state.category}.',
        isVerified: true,
        hasProof: true,
        proofId: _repositories.ids.nextId(),
      ),
    );
    emit(state.copyWith(committing: false, committed: true));
  }
}
