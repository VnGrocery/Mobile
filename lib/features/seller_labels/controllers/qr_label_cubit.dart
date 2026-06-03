import 'package:flutter_bloc/flutter_bloc.dart';

import 'qr_label_state.dart';

class QrLabelCubit extends Cubit<QrLabelState> {
  QrLabelCubit({required String pledgeId})
      : super(
          QrLabelState(
            pledgeId: pledgeId,
            clipboardText: _clipboardText(pledgeId),
          ),
        );

  static String _clipboardText(String pledgeId) {
    return 'VnGrocery Check\nMã ghi nhận: $pledgeId\nQuét mã để kiểm tra thông tin sản phẩm';
  }
}
