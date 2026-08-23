import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';

void main() {
  tearDown(() {
    SessionManager.instance.logout();
  });

  test('SessionCubit logs in user mode by default', () {
    final cubit = SessionCubit();

    cubit.login(email: 'buyer@example.com', displayName: 'Buyer Demo');

    expect(cubit.state.isLoggedIn, isTrue);
    expect(cubit.state.email, 'buyer@example.com');
    expect(cubit.state.displayName, 'Buyer Demo');
    expect(cubit.state.role, 'user');
    expect(cubit.state.shopId, isNull);

    cubit.close();
  });

  test('a buyer cannot put themselves into the seller side', () {
    // The switch used to rewrite the role itself, so a buyer who flipped it
    // was shown a seller app the server would refuse at every call. Selling is
    // a permission an admin grants, and only the token carries it.
    final cubit = SessionCubit();
    cubit.login(email: 'buyer@example.com');

    cubit.setSellerMode(true);

    expect(cubit.state.canSell, isFalse);
    expect(cubit.state.isSeller, isFalse);
    expect(cubit.state.shopId, isNull);

    cubit.close();
  });

  test('an approved seller can switch sides', () {
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com', role: 'seller');

    expect(cubit.state.canSell, isTrue);
    // Opens on the buyer side; the switch is one tap away.
    expect(cubit.state.isSeller, isFalse);

    cubit.setSellerMode(true);
    expect(cubit.state.isSeller, isTrue);

    cubit.setSellerMode(false);
    expect(cubit.state.isSeller, isFalse);

    cubit.close();
  });

  test('SessionCubit updates shop id through manager API', () {
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com', role: 'seller');

    cubit.setShopId('s2');

    expect(cubit.state.shopId, 's2');

    cubit.close();
  });

  test('switching back to the buyer side keeps the shop the account owns', () {
    // The shop belongs to the account, not to the side of the app being
    // looked at; clearing it here used to make the seller tabs re-fetch it
    // every time the switch was touched.
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com', role: 'seller');
    cubit.setShopId('shop-7');

    cubit.setSellerMode(true);
    cubit.setSellerMode(false);

    expect(cubit.state.isSeller, isFalse);
    expect(cubit.state.shopId, 'shop-7');

    cubit.close();
  });

  test('SessionCubit logout clears session state', () {
    final cubit = SessionCubit();
    cubit.login(email: 'buyer@example.com');

    cubit.logout();

    expect(cubit.state.isLoggedIn, isFalse);
    expect(cubit.state.email, isEmpty);
    expect(cubit.state.role, 'user');
    expect(cubit.state.shopId, isNull);
    expect(cubit.state.displayName, 'User');

    cubit.close();
  });

  test('SessionCubit trims login profile values via manager', () {
    final cubit = SessionCubit();

    cubit.login(email: ' buyer@example.com ', displayName: ' Buyer Demo ');

    expect(cubit.state.email, 'buyer@example.com');
    expect(cubit.state.displayName, 'Buyer Demo');

    cubit.close();
  });

  test('SessionCubit uses default login profile for blank email', () {
    final cubit = SessionCubit();

    cubit.login(email: '   ');

    expect(cubit.state.email, 'demo@vngrocery.com');
    expect(cubit.state.displayName, 'demo');

    cubit.close();
  });

  test('SessionCubit trims profile updates', () {
    final cubit = SessionCubit();
    cubit.login(email: 'buyer@example.com');

    cubit.updateProfile(displayName: ' New Name ', email: ' new@example.com ');

    expect(cubit.state.displayName, 'New Name');
    expect(cubit.state.email, 'new@example.com');

    cubit.close();
  });

  test('SessionCubit preserves current email for blank profile update email', () {
    final cubit = SessionCubit();
    cubit.login(email: 'buyer@example.com');

    cubit.updateProfile(displayName: 'Buyer', email: '   ');

    expect(cubit.state.displayName, 'Buyer');
    expect(cubit.state.email, 'buyer@example.com');

    cubit.close();
  });

  test('SessionCubit seller login waits for the server to name the shop', () {
    final cubit = SessionCubit();

    cubit.login(email: 'seller@example.com', role: 'seller');

    expect(cubit.state.canSell, isTrue);
    // Only /me/shop knows, and it has not answered yet.
    expect(cubit.state.shopId, isNull);

    cubit.close();
  });

  test('SessionManager exposes immutable current snapshot listenable', () {
    final session = SessionManager.instance;

    session.login(email: 'seller@example.com', role: 'seller');
    session.setSellerMode(true);
    expect(session.currentListenable.value.role, 'seller');
    expect(session.currentListenable.value.isSeller, isTrue);
    session.logout();
    expect(session.currentListenable.value.role, 'user');
    expect(session.currentListenable.value.isLoggedIn, isFalse);
  });
}
