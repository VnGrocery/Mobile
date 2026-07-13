import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
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
    final remote = _repositories.pledges.remote;
    if (remote == null) {
      await _delayService.wait(AppDelayKind.pledgeAnalysis);
      emit(state.copyWith(analyzing: false, step: 2));
      return;
    }
    try {
      final data = await rootBundle.load('assets/images/meat.png');
      final result = await remote.score(data.buffer.asUint8List());
      emit(
        state.copyWith(
          analyzing: false,
          step: 2,
          aiScore: (result['score'] as num?)?.toDouble() ?? 0,
          confidence: (result['confidence'] as num?)?.toDouble() ?? 0,
          imageHash: result['imageHash']?.toString() ?? '',
          imageCid: result['imageCid']?.toString() ?? '',
          category: result['category']?.toString() ?? state.category,
        ),
      );
    } catch (_) {
      emit(state.copyWith(analyzing: false));
    }
  }

  void setCategory(String category) {
    emit(state.copyWith(category: category, committed: false));
  }

  void continueToConfirm() {
    emit(state.copyWith(step: 3, committed: false));
  }

  Future<String?> commit(String rawScore, AppLocalizations l10n) async {
    if (state.committing) return null;
    emit(state.copyWith(committing: true, committed: false));
    final score = SellerPledgePresenter.normalizedScore(rawScore);
    final remote = _repositories.pledges.remote;
    if (remote != null) {
      try {
        final product = _repositories.products.byId(productId);
        final result = await remote.commit(
          shopId: product.shopId,
          productId: productId,
          bundleId: _repositories.ids.nextId(),
          score: double.parse(score),
          category: state.category,
          confidence: state.confidence,
          imageHash: state.imageHash,
          imageCid: state.imageCid,
        );
        _repositories.pledges.latestQrPayload = result;
        await _repositories.pledges.refresh(product.shopId, productId);
        emit(state.copyWith(committing: false, committed: true));
        return result['pledgeId']?.toString();
      } catch (_) {
        emit(state.copyWith(committing: false));
        return null;
      }
    }
    await _delayService.wait(AppDelayKind.pledgeCommit);
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
    return null;
  }
}
