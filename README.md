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
- Toàn bộ dữ liệu đang chạy bằng mock data qua lớp hook.

## Công nghệ

- Flutter (Material 3)
- Dart SDK: `>=3.0.0 <4.0.0`
- Không dùng backend thật ở bản hiện tại

## Cấu trúc thư mục

- `lib/main.dart`: entrypoint app.
- `lib/routes/app_routes.dart`: khai báo toàn bộ route.
- `lib/screens/`: các màn hình.
- `lib/screens/tabs/`: các tab chính trong `MainScreen`.
- `lib/data/`: models, session, mock DB, data hooks.
- `lib/theme/`: màu sắc và theme app.
- `assets/images/`: ảnh dùng trong giao diện.

## Danh sách route

- `splash`
- `onboarding`
- `auth`
- `main`
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

## Cài đặt và chạy

1. Cài Flutter SDK theo hướng dẫn chính thức.
2. Trong thư mục dự án, chạy:

```bash
flutter pub get
```

3. Chạy ứng dụng:

```bash
flutter run
```

## Trạng thái dữ liệu

- Dữ liệu đang là mock, không gọi API thật.
- Điểm nối dữ liệu tập trung ở:
  - `lib/data/data_hooks.dart`
  - `lib/data/mock_data.dart`
- Khi tích hợp backend, thay implementation trong `AppDataHooks` để giữ nguyên UI flow.

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

## Lưu ý Android/Gradle

- App đang cấu hình theo AGP mới.
- Nếu môi trường local báo warning Gradle/Kotlin, ưu tiên kiểm tra:
  - `android/gradle.properties`
  - `android/settings.gradle`
  - plugin/dependency Android mới thêm.

## Giấy phép

Dự án sử dụng file LICENSE hiện có trong repo.
