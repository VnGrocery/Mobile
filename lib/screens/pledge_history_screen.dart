import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/pledge_history/controllers/pledge_history_cubit.dart';
import 'package:vngrocery/features/pledge_history/controllers/pledge_history_state.dart';
import 'package:vngrocery/features/pledge_history/widgets/pledge_history_components.dart';
import 'package:vngrocery/theme/app_palette.dart';

class PledgeHistoryScreen extends StatefulWidget {
  final String productId;

  const PledgeHistoryScreen({super.key, required this.productId});

  @override
  State<PledgeHistoryScreen> createState() => _PledgeHistoryScreenState();
}

class _PledgeHistoryScreenState extends State<PledgeHistoryScreen> {
  late final PledgeHistoryCubit _historyCubit;

  @override
  void initState() {
    super.initState();
    _historyCubit = PledgeHistoryCubit()..load(widget.productId);
  }

  @override
  void dispose() {
    _historyCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _historyCubit,
      child: BlocBuilder<PledgeHistoryCubit, PledgeHistoryState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: const Text('Lịch sử ghi nhận')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const PledgeTimelineHeader(),
                const SizedBox(height: 16),
                if (state.isEmpty)
                  const EmptyPledgeHistory()
                else
                  for (final item in state.history)
                    PledgeTimelineItem(item: item),
              ],
            ),
          );
        },
      ),
    );
  }
}
