# Định hướng lại app mobile quanh dữ liệu blockchain

## Vấn đề

Server đã là một **cỗ máy đánh giá độ tin cậy**: nó tính điểm, đối chiếu hash
on-chain, và trả về **kết luận đã sẵn sàng để hiển thị**. App mobile hiện là một
app thương mại điện tử thông thường và bỏ qua gần như toàn bộ phần đó.

Toàn bộ codebase mobile chỉ chạm tới dữ liệu blockchain **đúng 1 lần**
(`integrityStatus` trong `lib/data/models/pledge_history_item.dart:21`).

Nghịch lý cần sửa: đề tài là *"truy xuất thông tin độ tươi sản phẩm ứng dụng
blockchain"*, nhưng người dùng mở app lên **không bao giờ nhìn thấy blockchain**.

## Server đang cho không những gì

### `GET /v1/shops/{shopId}/pledges/{pledgeId}/proof` — chưa từng được gọi

Đây không phải dữ liệu thô. Server **tự sinh sẵn nội dung cho UI**:

| Trường | Ý nghĩa |
|---|---|
| `proofStatus` | `verified` / `pending` / `warning` / `revoked` / `unknown` |
| `proofHeadline` | Tiêu đề tiếng Việt viết sẵn, ví dụ *"Cam ket da duoc xac thuc"* |
| `proofSummary` | Câu mô tả đầy đủ cho người dùng cuối |
| `recommendedActions` | **Chỉ thị UI**: `show_verified_badge`, `show_pending_badge`, `show_warning`, `hide_trust_badge`, `show_revoked_state`, `retry_later`, `contact_admin`, `consider_reanchor`, `refresh_record`, `show_neutral_state` |
| `integrity.chainTxHash` | Mã giao dịch on-chain |
| `integrity.chainBlockNumber` | Số block |
| `integrity.onChainMatch` | Hash lưu trong DB có khớp hash trên chain không |
| `integrity.onChainTimestamp` | Thời điểm neo |
| `integrity.mismatchReason` | Lý do lệch, khi có |

Nguồn: `server/internal/service/shop/service.go:231-267`.

### `trustSummary` — có sẵn trong mọi response shop, đang bị bỏ

| Trường | Ý nghĩa |
|---|---|
| `score` | 0–100 |
| `grade` | `excellent` (≥85) / `good` (≥70) / `watch` (≥55) / `risk` |
| `pledgeScore`, `reviewScore`, `buyerCheckScore`, `consistencyScore`, `recencyScore`, `coverageScore` | 6 điểm thành phần |
| `pledgeCount`, `buyerCheckCount`, `trustedCheckCount`, `highRiskCheckCount` | Số liệu đếm |
| `reasons[]` | 17 mã lý do, ví dụ `pledges_consistent_with_buyer_checks`, `buyer_checks_high_risk` |

### `POST /v1/buyer/check` — mobile chỉ đọc 3/25 trường

Đang dùng: `verdict`, `actualScore`, `locationStatus`.
Đang bỏ: `trusted`, `pledgedScore`, `scoreDelta`, `pledgedCategory`,
`actualCategory`, `categoryMatch`, `actualConfidence`, `reasons[]`, `hasPledge`,
`policyVersion`, `imageHash`, `imageCid`.

Chính `pledgedScore` so với `actualScore` mới là câu trả lời cho câu hỏi
*"người bán có nói thật không"* — đó là toàn bộ ý nghĩa của sản phẩm.

---

## Ba nguyên tắc định hướng

### 1. Client không được tự tính lại kết luận tin cậy

Server đã chốt `proofStatus` và `recommendedActions`. Mobile chỉ **render**.

Nếu mobile tự suy diễn (kiểu `if (score > 8) badge = xanh`), hai bên sẽ lệch
nhau ngay khi công thức server đổi — và mất tính "một nguồn sự thật", vốn là
điều khiến hệ thống đáng tin. Hãy coi `recommendedActions` là **hợp đồng UI**.

### 2. Trust hiện diện ở mọi nơi sản phẩm xuất hiện, không nằm trong một màn hình bị chôn sâu

Người dùng không đi tìm blockchain. Nó phải đập vào mắt ngay tại danh sách sản
phẩm, chi tiết sản phẩm, và trang cửa hàng.

### 3. Trạng thái xấu phải hiển thị rõ ràng, không im lặng

`warning` và `revoked` mới là bằng chứng hệ thống **thật sự hoạt động** — nó bắt
được gian lận. Che đi thì còn lại chỉ là một cái nhãn xanh trang trí.

---

## Bản đồ: dữ liệu server → màn hình

| Màn hình | Hiện tại | Cần thêm |
|---|---|---|
| `product_detail_screen` | tên, giá, mô tả | **Badge trust + nút "Xem chứng nhận blockchain"** |
| `buyer_check_result_screen` | verdict, điểm thực tế | **Cam kết vs thực tế, độ lệch, khớp loại, lý do** |
| `store_detail_screen` | tên, rating, review | **Thẻ điểm tin cậy: score, grade, 6 thành phần, lý do** |
| `home` / `explore` (card shop) | tên, rating | **Badge grade nhỏ** |
| `pledge_history_screen` | trạng thái cơ bản | **Trạng thái neo + link tx cho từng pledge** |
| *(mới)* `blockchain_proof_screen` | — | **txHash, block, dataHash, thời điểm neo, nút copy/chia sẻ** |

---

## Lộ trình

### Giai đoạn 1 — Làm cho blockchain hiện ra (ưu tiên cao nhất)

Ít việc nhất, thay đổi nhiều nhất về mặt cảm nhận sản phẩm.

1. **Model `PledgeProof`** trong `lib/data/models/` — ánh xạ nguyên vẹn
   `PledgeProofBundleResponse`, không bịa thêm logic.
2. **`RemoteDataSource.pledgeProof(shopId, pledgeId)`** gọi endpoint `/proof`.
3. **Widget `TrustBadge`** dùng chung trong `lib/core/widgets/`, ánh xạ thuần tuý:

   | `proofStatus` | Màu | Nhãn |
   |---|---|---|
   | `verified` | xanh lá | Đã xác thực on-chain |
   | `pending` | xám | Đang neo lên blockchain |
   | `warning` | cam | Phát hiện sai lệch |
   | `revoked` | đỏ | Cam kết đã bị thu hồi |
   | `unknown` | trung tính | Chưa xác thực được |

   Quyết định hiện/ẩn dựa trên `recommendedActions`, **không** tự suy luận từ
   `proofStatus`.
4. Gắn `TrustBadge` vào `product_detail_screen`.

### Giai đoạn 2 — Điểm tin cậy của cửa hàng

5. Bổ sung `trustSummary` vào `Shop.fromJson` (hiện đang bị bỏ qua hoàn toàn ở
   `lib/data/models/shop.dart:28`).
6. **`TrustScoreCard`** ở `store_detail_screen`: điểm lớn + grade, kèm 6 thanh
   thành phần để thấy điểm đến từ đâu.
7. Dịch 17 mã `reasons` sang tiếng Việt trong `app_vi.arb` / `app_en.arb`
   (ví dụ `no_buyer_checks` → *"Chưa có người mua nào kiểm chứng"*).
8. Badge grade nhỏ trên card shop ở home và explore.

### Giai đoạn 3 — Màn hình chứng nhận và đối chiếu

9. **`blockchain_proof_screen`**: `chainTxHash`, `chainBlockNumber`, `dataHash`,
   `onChainTimestamp`, `onChainMatch`, nút copy và chia sẻ.
   *Đây chính là màn hình để chụp đưa vào báo cáo đồ án.*
10. Nâng cấp `buyer_check_result_screen`: hiển thị **cam kết vs thực tế** cạnh
    nhau, `scoreDelta`, `categoryMatch`, và danh sách `reasons`.
11. Trạng thái neo cho từng dòng trong `pledge_history_screen`.

---

## Việc cần làm kèm theo

- **Chuỗi i18n**: 5 `proofStatus` + 4 `grade` + 17 `reasons` = **26 khoá mới**
  cho mỗi ngôn ngữ. `proofHeadline`/`proofSummary` server trả sẵn tiếng Việt
  **không dấu** — cần quyết định: dùng thẳng, hay tự dịch ở client theo
  `proofStatus` để có dấu và có bản tiếng Anh. Khuyến nghị dùng cách thứ hai và
  giữ `proofSummary` làm phương án dự phòng.
- **Trạng thái `pending`**: hash neo mất vài giây. Màn hình cần cho phép làm mới,
  đúng như `recommendedActions: ["show_pending_badge", "retry_later"]` gợi ý.
- **Không chặn luồng mua hàng** khi `/proof` lỗi — badge chuyển `unknown`,
  phần còn lại của màn hình vẫn hoạt động bình thường.

## Ba việc chặn cần xử lý song song

Định hướng này chỉ phát huy khi 3 lỗi sau được sửa (chi tiết đã báo cáo riêng):

1. `ApiClient.defaultBaseUrl` trỏ `10.0.2.2:8080` — cổng đó là IPFS gateway,
   API thật ở `5000`.
2. Scanner QR đang là mô phỏng (`scanner_cubit.dart` chỉ delay rồi báo xong), và
   dự án chưa có thư viện quét/tạo QR.
3. Không có cách làm mới `bundleToken` khi hết hạn 30 phút — server đã có sẵn
   `POST /v1/shops/{shopId}/pledges/{pledgeId}/bundle-token` nhưng mobile chưa gọi.
