import 'package:flutter_bloc/flutter_bloc.dart';

import 'qr_label_state.dart';
import 'package:vngrocery/data/repositories.dart';

class QrLabelCubit extends Cubit<QrLabelState> {
  QrLabelCubit({required String pledgeId})
    : super(
        QrLabelState(
          pledgeId: pledgeId,
          clipboardText: _clipboardText(pledgeId),
        ),
      );

  static String _clipboardText(String pledgeId) {
    final payload = AppRepositories.instance.pledges.latestQrPayload;
    final token = payload?['bundleToken']?.toString() ?? '';
    final bundle = payload?['bundleId']?.toString() ?? '';
    return 'VnGrocery Check\nMã ghi nhận: $pledgeId\nMã lô: $bundle\nToken: $token';
  }
}
