import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/reviews/controllers/review_cubit.dart';

void main() {
  test('ReviewCubit tracks rating and photo state', () {
    final cubit = ReviewCubit(submitDelay: Duration.zero);

    cubit.setRating(4);
    cubit.togglePhoto();

    expect(cubit.state.rating, 4);
    expect(cubit.state.photoAttached, isTrue);
    expect(cubit.state.canSubmit('Good shop'), isTrue);

    cubit.close();
  });

  test('ReviewCubit submits only valid reviews', () async {
    final cubit = ReviewCubit(submitDelay: Duration.zero);

    await cubit.submit('Missing rating');
    expect(cubit.state.submitted, isFalse);

    cubit.setRating(5);
    await cubit.submit('Good shop');

    expect(cubit.state.submitted, isTrue);
    expect(cubit.state.submitting, isFalse);

    cubit.close();
  });
}
