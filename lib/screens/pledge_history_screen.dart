import 'package:flutter/material.dart';

import '../features/pledge_history/pledge_history_presenter.dart';
import '../features/pledge_history/widgets/pledge_history_components.dart';
import '../theme/app_palette.dart';

class PledgeHistoryScreen extends StatelessWidget {
  final String productId;

  const PledgeHistoryScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final history = PledgeHistoryPresenter.history(productId);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: const Text('Lịch sử ghi nhận')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PledgeTimelineHeader(),
          const SizedBox(height: 16),
          if (history.isEmpty)
            const EmptyPledgeHistory()
          else
            for (final item in history) PledgeTimelineItem(item: item),
        ],
      ),
    );
  }
}
