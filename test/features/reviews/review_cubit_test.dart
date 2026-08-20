import 'dart:typed_data';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/reviews/controllers/review_cubit.dart';

void main() {
  test('ReviewCubit tracks rating and photo state', () {
    final cubit = ReviewCubit(delayService: const NoopAppDelayService());

    cubit.setRating(4);
    // The photo is now real bytes the reviewer took, not a bundled asset.
    cubit.attachPhoto(Uint8List.fromList(const [1, 2, 3]));

    expect(cubit.state.rating, 4);
    expect(cubit.state.photoAttached, isTrue);
    expect(cubit.hasPhoto, isTrue);

    cubit.removePhoto();
    expect(cubit.state.photoAttached, isFalse);
    expect(cubit.hasPhoto, isFalse);
    cubit.attachPhoto(Uint8List.fromList(const [1, 2, 3]));
    expect(cubit.state.canSubmit('Good shop'), isTrue);

    cubit.close();
  });

  test('ReviewCubit submits only valid reviews', () async {
    final cubit = ReviewCubit(delayService: const NoopAppDelayService());

    await cubit.submit('Missing rating');
    expect(cubit.state.submitted, isFalse);

    cubit.setRating(5);
    await cubit.submit('Good shop');

    expect(cubit.state.submitted, isTrue);
    expect(cubit.state.submitting, isFalse);

    cubit.close();
  });
}
