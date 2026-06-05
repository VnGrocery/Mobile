# VnGrocery

Ứng dụng Flutter demo cho bài toán minh bạch chất lượng thực phẩm: buyer có thể khám phá cửa hàng, quét sản phẩm, so sánh cam kết; seller có thể quản lý cửa hàng, sản phẩm và cam kết.

## Tính năng chính

- Xác thực demo: đăng nhập, đăng ký, quên mật khẩu, đổi mật khẩu.
- Chuyển chế độ User/Seller ngay trong tab tài khoản.
- Buyer flow:
  - Khám phá cửa hàng.
  - Bản đồ mở rộng toàn màn hình.
  - Quét sản phẩm và xem chi tiết.
  - So sánh AI freshness với cam kết.
- Seller flow:
  - Tổng quan seller.
  - Quản lý sản phẩm.
  - Tạo cam kết chất lượng.
  - Quản lý thông tin cửa hàng.
- Toàn bộ dữ liệu đang chạy bằng mock JSON qua `MockDb` → repositories → `AppDataHooks`.

## Công nghệ

- Flutter (Material 3)
- Dart SDK: `>=3.10.3 <4.0.0`
- Không dùng backend thật ở bản hiện tại

## Cấu trúc thư mục

- `lib/main.dart`: entrypoint, `MultiBlocProvider`, localization delegates/locales.
- `lib/routes/app_routes.dart`: named routes + typed/defensive arguments.
- `lib/data/models/`: JSON-backed UI/domain models.
- `lib/data/repositories/`: domain repositories over mock DB.
- `lib/data/data_hooks.dart`: UI façade/backend seam.
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
- `ai_compare`
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

`integration_test/app_smoke_test.dart` dùng `integration_test`; có thể chạy thiết bị/emulator bằng `flutter test integration_test`.

## Trạng thái dữ liệu

- Dữ liệu đang là mock, không gọi API thật.
- Luồng dữ liệu hiện tại: mock JSON → `MockDb` → repositories → `AppDataHooks`.
- Backend replacement nên giữ contract repository/data hook để không đổi UI flow.

## Mô hình dữ liệu

Source of truth hiện nằm trong `lib/data/`:

- `lib/data/models/`: entity UI dùng trực tiếp.
- `lib/data/mock_json_data.dart`: seed data dạng JSON-like map.
- `lib/data/repositories/`: query/mutation theo domain.
- `lib/data/data_hooks.dart`: façade để UI lấy/ghi dữ liệu.

Entity chính: `Shop`, `Product`, `Review`, `PledgeHistoryItem`, `Voucher`,
`UserVoucher`, `VoucherCheckResult`, `BuyerCheckResult`.

Quan hệ chính:

- `Shop.id` ← `Product.shopId`
- `Shop.id` ← `Voucher.shopId`
- `Product.id` ← pledge history lookup
- `Voucher.id` ← `UserVoucher.voucherId`

Backend contract hiện dùng key camelCase. Snake_case không được map tự động. Các
field required trong model sẽ throw nếu thiếu/sai type; field optional/default xem
constructor trong `lib/data/models/`. Date input hỗ trợ `DateTime`, epoch ms hoặc
ISO-8601 string; giá trị invalid/null fallback về `1970-01-01`.

## Localization

- Config: `l10n.yaml`.
- Sources: `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb`.
- Generated: `lib/l10n/app_localizations*.dart`.
- Dependencies: `flutter_localizations`, `intl`.
- App hỗ trợ `en`, `vi`; cập nhật ARB rồi regenerate.

## OpenStreetMap

- Renderer: `lib/widgets/osm_tile_map.dart`.
- Default tiles: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`.
- Attribution hiển thị: `© OpenStreetMap contributors`.
- Behavior: clamp zoom/lat, wrap longitude/antimeridian x, fallback tile icon khi lỗi network.
- Lưu ý public OSM tile usage policy; production nên dùng tile provider riêng/thương mại qua `tileUriBuilder`.

## Lưu ý Android/Gradle

- App đang cấu hình theo AGP mới.
- Nếu môi trường local báo warning Gradle/Kotlin, ưu tiên kiểm tra:
  - `android/gradle.properties`
  - `android/settings.gradle`
  - plugin/dependency Android mới thêm.

## Giấy phép

Dự án sử dụng file LICENSE hiện có trong repo.
