import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class BlockchainProofState {
  final PledgeProof? proof;
  final bool loading;

  const BlockchainProofState({this.proof, this.loading = false});

  bool get hasProof => proof != null;
}

class BlockchainProofCubit extends Cubit<BlockchainProofState> {
  final AppRepositories _repositories;
  final String shopId;
  final String pledgeId;

  BlockchainProofCubit({
    required this.shopId,
    required this.pledgeId,
    AppRepositories? repositories,
  }) : _repositories = repositories ?? AppRepositories.instance,
       super(const BlockchainProofState());

  /// Anchoring takes a few seconds, so this is callable again from the view to
  /// turn a pending certificate into a confirmed one.
  Future<void> load() async {
    if (isClosed) return;
    emit(BlockchainProofState(proof: state.proof, loading: true));

    final remote = _repositories.pledges.remote;
    if (remote == null) {
      if (isClosed) return;
      emit(const BlockchainProofState());
      return;
    }

    final proof = await remote.pledgeProof(shopId, pledgeId);
    if (isClosed) return;
    emit(BlockchainProofState(proof: proof));
  }
}
