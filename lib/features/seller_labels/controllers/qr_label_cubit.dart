import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'qr_label_state.dart';

class QrLabelCubit extends Cubit<QrLabelState> with CloseSafeEmit {
  QrLabelCubit({required String pledgeId, AppRepositories? repositories})
    : super(_build(pledgeId, repositories ?? AppRepositories.instance));

  static QrLabelState _build(String pledgeId, AppRepositories repositories) {
    final payload = repositories.pledges.latestQrPayload;
    final token = payload?['bundleToken']?.toString() ?? '';
    final bundle = payload?['bundleId']?.toString() ?? '';
    return QrLabelState(
      pledgeId: pledgeId,
      bundleToken: token,
      bundleId: bundle,
    );
  }
}
