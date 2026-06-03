import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_labels/controllers/qr_label_cubit.dart';

void main() {
  test('QrLabelCubit builds clipboard text for pledge label', () {
    final cubit = QrLabelCubit(pledgeId: 'proof-123');

    expect(cubit.state.pledgeId, 'proof-123');
    expect(cubit.state.clipboardText, contains('proof-123'));
    expect(cubit.state.clipboardText, contains('VnGrocery Check'));

    cubit.close();
  });
}
