import 'package:flutter/material.dart';
import 'package:vngrocery/features/pledge_history/pledge_history_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/core/widgets/trust_copy.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class PledgeTimelineHeader extends StatelessWidget {
  const PledgeTimelineHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text(
      l10n.pledgeTimelineTitle,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class EmptyPledgeHistory extends StatelessWidget {
  const EmptyPledgeHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Center(
        child: Text(
          l10n.pledgeHistoryEmpty,
          style: TextStyle(color: context.palette.textSecondary),
        ),
      ),
    );
  }
}

class PledgeTimelineItem extends StatelessWidget {
  final PledgeHistoryItem item;

  /// Empty when the product's shop is unknown, in which case the certificate
  /// cannot be addressed and the link is left out.
  final String shopId;

  const PledgeTimelineItem({super.key, required this.item, this.shopId = ''});

  bool get _canOpenCertificate => shopId.isNotEmpty && item.proofId.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final color = item.isVerified
        ? AppColors.primaryGreen
        : AppColors.warningOrange;
    final description = PledgeHistoryPresenter.description(l10n, item);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: Container(width: 2, color: palette.border)),
              ],
            ),
          ),
          Expanded(
            child: Card(
              color: palette.card,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.palette.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            TrustCopy.integrityStatus(
                              context,
                              item.integrityStatus,
                            ),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      PledgeHistoryPresenter.title(l10n, item),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: palette.textSecondary,
                        ),
                      ),
                    if (item.hasProof) ...[
                      const Divider(height: 24, thickness: 0.5),
                      InkWell(
                        onTap: _canOpenCertificate
                            ? () => Navigator.pushNamed(
                                context,
                                Routes.blockchainProof,
                                arguments: BlockchainProofArgs(
                                  shopId: shopId,
                                  pledgeId: item.proofId,
                                ),
                              )
                            : null,
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 14,
                              color: context.palette.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.pledgeOriginalReceipt(item.proofId),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.palette.textSecondary,
                                ),
                              ),
                            ),
                            if (_canOpenCertificate)
                              Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: context.palette.textSecondary,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
