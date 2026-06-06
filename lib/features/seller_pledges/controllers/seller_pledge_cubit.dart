import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'seller_pledge_state.dart';

class SellerPledgeCubit extends Cubit<SellerPledgeState> {
  final AppDelayService _delayService;
  final AppRepositories _repositories;
  final String productId;

  SellerPledgeCubit({
    required this.productId,
    AppDelayService delayService = AppDelayService.instance,
    AppRepositories? repositories,
  }) : _delayService = delayService,
       _repositories = repositories ?? AppRepositories.instance,
       super(SellerPledgeState.initial());

  void back() {
    if (state.step <= 1) return;
    emit(state.copyWith(step: state.step - 1, committed: false));
  }

  Future<void> capture() async {
    if (state.analyzing) return;
    emit(state.copyWith(analyzing: true, committed: false));
    await _delayService.wait(AppDelayKind.pledgeAnalysis);
    emit(state.copyWith(analyzing: false, step: 2));
  }

  void setCategory(String category) {
    emit(state.copyWith(category: category, committed: false));
  }

  void continueToConfirm() {
    emit(state.copyWith(step: 3, committed: false));
  }

  Future<void> commit(String rawScore, AppLocalizations l10n) async {
    if (state.committing) return;
    emit(state.copyWith(committing: true, committed: false));
    await _delayService.wait(AppDelayKind.pledgeCommit);
    final score = SellerPledgePresenter.normalizedScore(rawScore);
    _repositories.pledges.add(
      productId,
      PledgeHistoryItem(
        time: l10n.sellerPledgeRecordTimeJustNow,
        title: l10n.sellerPledgeRecordTitle,
        description: SellerPledgePresenter.recordDescription(
          score: score,
          category: state.category,
          l10n: l10n,
        ),
        isVerified: true,
        hasProof: true,
        proofId: _repositories.ids.nextId(),
      ),
    );
    emit(state.copyWith(committing: false, committed: true));
  }
}
