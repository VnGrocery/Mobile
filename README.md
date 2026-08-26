# VnGrocery

Ứng dụng Flutter cho bài toán minh bạch chất lượng thực phẩm, tích hợp trực tiếp với VnGrocery Server.

## Tính năng chính

- Xác thực API: đăng nhập, đăng ký, quên mật khẩu, đổi mật khẩu và lưu session.
- Chuyển chế độ User/Seller ngay trong tab tài khoản.
- Buyer flow:
  - Khám phá cửa hàng, ưu tiên cửa hàng trong bán kính 5km rồi mới tới 20km.
  - Bản đồ kéo/zoom được, ghim theo toạ độ thật, có vòng bán kính quanh vị trí.
  - Quét sản phẩm và xem chi tiết.
  - So sánh AI freshness với cam kết.
  - Lịch sử thay đổi của sản phẩm (chuỗi hash có chữ ký) và biểu đồ giá 30 ngày.
- Seller flow:
  - Tổng quan seller.
  - Quản lý sản phẩm.
  - Tạo cam kết chất lượng.
  - Quản lý thông tin cửa hàng.
- Runtime dùng REST API cho auth, shop, product, review, pledge, buyer check và voucher. `MockDb` chỉ còn là test double cho unit/widget test.

## Công nghệ

- Flutter (Material 3)
- Dart SDK: `>=3.10.3 <4.0.0`
- REST client: package `http`
- Hive lưu session và cart trên thiết bị

## Cấu trúc thư mục

- `lib/main.dart`: entrypoint, `MultiBlocProvider`, localization delegates/locales, `Routes.routeFactory(session)` wiring.
- `lib/routes/app_routes.dart`: named routes + typed/defensive arguments + session-aware route factory.
- `lib/data/models/`: JSON-backed UI/domain models.
- `lib/data/repositories/`: domain repositories over mock DB.
- `lib/data/data_hooks.dart`: legacy compatibility stub; code mới nên đi thẳng qua repositories.
- `lib/features/*/controllers/`: BLoC/Cubit state.
- `lib/features/cart/repositories/cart_repository.dart`: Hive cart persistence.
- `lib/screens/`: app screens.
- `lib/screens/tabs/`: main tabs in `MainScreen`.
- `lib/widgets/osm_tile_map.dart`: reusable OSM tile renderer.
- `lib/l10n/`: ARB sources and generated localization files.
- `integration_test/`: integration smoke tests.
- `test/`: unit/widget tests.
- `lib/theme/`: app colors/theme.
- `assets/images/`: UI images.

## Danh sách route

- `splash`
- `onboarding`
- `auth`
- `main`
- `manual_voucher`
- `change_password`
- `explore_map`
- `scan`
- `product_detail`
- `blockchain_proof`
- `buyer_check_result`
- `store_detail`
- `review`
- `seller_products`
- `seller_create_product`
- `seller_create_pledge`
- `seller_shop`
- `pledge_history`
- `qr_label`
- `voucher_wallet`
- `voucher_qr`
- `cart`

## Cài đặt và chạy

```bash
flutter pub get
flutter gen-l10n # hoặc sinh qua flutter pub get khi flutter.generate=true
flutter analyze
flutter test
flutter test integration_test/app_smoke_test.dart
flutter run
```

API mặc định trên Android emulator là `http://10.0.2.2:5050`. Có thể đổi bằng compile-time define:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5050
flutter build apk --dart-define=API_BASE_URL=https://api.example.com
```

Google login cần cấu hình OAuth native theo `google_sign_in` và truyền web client ID dùng để Server xác minh:

```bash
flutter run --dart-define=GOOGLE_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

Thay vì lặp lại từng `--dart-define`, có thể gom hết vào một file (`.env`, gitignored) và nạp bằng cờ đọc file gốc của Flutter:

```bash
cp .env.example .env   # rồi sửa domain/port cho đúng máy của bạn
flutter run --dart-define-from-file=.env
```

Thiết bị thật phải dùng địa chỉ LAN/HTTPS mà thiết bị truy cập được. HTTP cleartext chỉ được bật trong Android debug manifest; production nên dùng HTTPS.

`integration_test/app_smoke_test.dart` dùng `integration_test`; cần Android/iOS device hoặc emulator. Smoke hiện dùng stable keys cho onboarding/auth/logout flow thay vì selector text cứng. Lệnh chuẩn:

```bash
flutter test integration_test/app_smoke_test.dart
```

Nếu chưa có device, lệnh integration thường báo `No supported devices connected`.
Widget/unit test thuần vẫn chạy được bằng `flutter test`.

## Trạng thái dữ liệu

- Runtime: Server REST API → `RemoteDataSource` → repositories → Cubit/BLoC.
- Test: mock JSON → `MockDb` → cùng repository/Cubit boundary.
- Cart tiếp tục lưu local bằng Hive vì Server chưa có nghiệp vụ order/checkout.

## Mô hình dữ liệu

Source of truth hiện nằm trong `lib/data/`:

- `lib/data/models/`: entity UI dùng trực tiếp.
- `lib/data/mock_json_data.dart`: fixture JSON-like, chỉ nạp trong test (`test/flutter_test_config.dart`); app chạy thật không dùng.
- `lib/data/repositories/`: query/mutation theo domain.
- `lib/data/data_hooks.dart`: stub legacy, giữ tạm để tương thích; không dùng cho code mới.

Entity chính: `Shop`, `Product`, `Review`, `PledgeHistoryItem`, `Voucher`,
`UserVoucher`, `VoucherCheckResult`, `BuyerCheckResult`.

Quan hệ chính:

- `Shop.id` ← `Product.shopId`
- `Shop.id` ← `Voucher.shopId`
- `Product.id` ← pledge history lookup
- `Voucher.id` ← `UserVoucher.voucherId`

### Mock backend JSON contract

`lib/data/mock_json_data.dart` mô phỏng payload backend. Top-level keys app dùng hiện tại:

- `demoShopId`
- `shops`
- `products`
- `reviewsByShop`
- `pledgesByProduct`
- `vouchers`
- `userVouchers`
- `lastBuyerCheck`

Contract dùng key camelCase. Snake_case không được map tự động. Field required
trong model sẽ throw nếu thiếu/sai type.

Required/default theo model:

- `Shop`: required `id`, `name`, `address`, `rating`, `reviewCount`,
  `description`; optional `logoUrl`.
- `Product`: required `id`, `shopId`, `name`, `description`, `category`,
  `freshnessScore`, `freshnessNote`, `price`, `tags`, `status`. `tags` chỉ giữ
  phần tử kiểu `String`; giá trị không phải list fallback về `[]`.
- `Review`: required `id`, `userName`, `rating`, `comment`, `date`.
- `PledgeHistoryItem`: required `time`, `title`, `description`, `isVerified`;
  defaults `hasProof=false`, `proofId=''`.
- `Voucher`: required `id`, `code`, `title`, `shopId`, `discountValue`,
  `isPercent`, `minSpend`, `expiresAt`; defaults `active=true`,
  `manual=false`, `note=''`, `codeFormat='QR'`.
- `UserVoucher`: required `id`, `userEmail`, `voucherId`; defaults
  `used=false`, `usedAt=null`.
- `BuyerCheckResult`: required `actualScore`, `locationStatus`, `verdict`.

Date input hỗ trợ `DateTime`, epoch ms hoặc ISO-8601 string; giá trị invalid
fallback về `1970-01-01`. `UserVoucher.usedAt` giữ `null` nếu field vắng mặt,
chỉ fallback epoch khi field có mặt nhưng parse lỗi. Contract tests:
`flutter test test/data`.

## Session và routing

- Session runtime dùng immutable `SessionSnapshot` trong `SessionManager`.
- `SessionManager` expose `current` và `currentListenable`; mutation đi qua `login`, `logout`, `updateProfile`, `setRole`, `setShopId`.
- `SessionCubit` map snapshot này thành `SessionState` cho UI.
- `MaterialApp` build route qua `Routes.routeFactory(session)` thay vì để route generator tự đọc singleton session.
- Route guards hiện chặn rõ buyer/seller/logged-out theo `RoutePolicy`.

## Localization

- Config: `l10n.yaml`.
- Sources: `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`.
- Generated: `lib/l10n/app_localizations*.dart`.
- Dependencies: `flutter_localizations`, `intl`.
- App hỗ trợ `en`, `vi`; cập nhật ARB rồi regenerate.
- `l10n.yaml` bật `nullable-getter: false`; file `untranslated_messages.json` sinh ra khi có message thiếu bản dịch.

## OpenStreetMap

- Renderer: `lib/widgets/osm_tile_map.dart`.
- Default tiles: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`.
- Attribution hiển thị: `© OpenStreetMap contributors`.
- Behavior: clamp zoom/lat, wrap longitude/antimeridian x, fallback tile icon khi lỗi network.
- Lưu ý public OSM tile usage policy; production nên dùng tile provider riêng/thương mại qua `OsmTileProviderConfig`.

Ví dụ provider production:

```dart
final providerConfig = OsmTileProviderConfig(
  tileUriBuilder: (z, x, y) => Uri.parse('https://tiles.example.com/$z/$x/$y.png'),
  attribution: '© Example Maps',
  minZoom: 0,
  maxZoom: 18,
);
```

## Lưu ý Android/Gradle

- App đang cấu hình theo AGP mới.
- Nếu môi trường local báo warning Gradle/Kotlin, ưu tiên kiểm tra:
  - `android/gradle.properties`
  - `android/settings.gradle`
  - plugin/dependency Android mới thêm.

## Giấy phép

Dự án sử dụng file LICENSE hiện có trong repo.
