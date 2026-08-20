import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/trust_badge.dart';
import 'package:vngrocery/features/blockchain_proof/controllers/blockchain_proof_cubit.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Shows the on-chain record behind a pledge: transaction, block, hash and
/// whether the stored data still matches what was anchored.
class BlockchainProofScreen extends StatefulWidget {
  final String shopId;
  final String pledgeId;

  const BlockchainProofScreen({
    super.key,
    required this.shopId,
    required this.pledgeId,
  });

  @override
  State<BlockchainProofScreen> createState() => _BlockchainProofScreenState();
}

class _BlockchainProofScreenState extends State<BlockchainProofScreen> {
  late final BlockchainProofCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlockchainProofCubit(
      shopId: widget.shopId,
      pledgeId: widget.pledgeId,
    )..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _copy(String label, String value) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    AppFeedback.showSnackBar(
      context,
      AppLocalizations.of(context).blockchainProofCopied,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<BlockchainProofCubit, BlockchainProofState>(
        builder: (context, state) {
          final proof = state.proof;
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: Text(l10n.blockchainProofTitle),
              actions: [
                IconButton(
                  tooltip: l10n.blockchainProofRefresh,
                  onPressed: state.loading ? null : () => _cubit.load(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: proof == null
                ? Center(
                    child: state.loading
                        ? const CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.blockchainProofNoRecord,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // The verdict itself is the point of this screen, so it is
                      // shown even when the server would hide the badge.
                      TrustBadge(proof: proof, ignoreHideAction: true),
                      const SizedBox(height: 12),
                      Text(
                        TrustProofCopy.summary(context, proof),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 20),
                      if (!proof.integrity.hasChainRecord)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            l10n.blockchainProofNoRecord,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _ProofRow(
                              label: l10n.blockchainProofPledge,
                              value: proof.pledgeId,
                              onCopy: _copy,
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofScore,
                              value: proof.score == 0
                                  ? '-'
                                  : '${proof.score.toStringAsFixed(1)}/10',
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofTxHash,
                              value: proof.integrity.chainTxHash,
                              onCopy: _copy,
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofBlock,
                              value: proof.integrity.chainBlockNumber == 0
                                  ? '-'
                                  : '${proof.integrity.chainBlockNumber}',
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofDataHash,
                              value: proof.integrity.dataHash,
                              onCopy: _copy,
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofAnchoredAt,
                              value:
                                  proof.integrity.onChainTimestamp
                                      ?.toLocal()
                                      .toString() ??
                                  '-',
                            ),
                            _ProofRow(
                              label: l10n.blockchainProofMatch,
                              value: proof.integrity.onChainMatch
                                  ? l10n.blockchainProofYes
                                  : l10n.blockchainProofNo,
                              valueColor: proof.integrity.onChainMatch
                                  ? AppColors.trustGreen
                                  : AppColors.warningOrange,
                              last: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.blockchainProofCopyHint,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _ProofRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool last;
  final void Function(String label, String value)? onCopy;

  const _ProofRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.last = false,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final shown = value.isEmpty ? '-' : value;
    final copyable = onCopy != null && value.isNotEmpty;

    return InkWell(
      onTap: copyable ? () => onCopy!(label, value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                if (copyable)
                  const Icon(
                    Icons.copy,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              shown,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
            if (!last)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Divider(height: 1),
              ),
          ],
        ),
      ),
    );
  }
}
