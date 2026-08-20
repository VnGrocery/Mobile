import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_cubit.dart';

void main() {
  test('QrLabelCubit carries the pledge id it was opened with', () {
    final cubit = QrLabelCubit(pledgeId: 'proof-123');

    expect(cubit.state.pledgeId, 'proof-123');
    // No fresh commit in this session, so there is no QR to print.
    expect(cubit.state.hasToken, isFalse);

    cubit.close();
  });
}
