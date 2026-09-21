<div align="center">
  <h1>🎮 Phân Tích Mô Hình Monetization Game Mobile Trên Google Play Store</h1>
  <p><i>Benchmark hiệu quả doanh thu của 5 mô hình kiếm tiền trên 14,686 game Google Play</i></p>
</div>

---

## 🎯 Bối cảnh giả định

Studio game mobile của tôi chuẩn bị ra mắt sản phẩm mới trên Google Play. Với vai trò Data Analyst hỗ trợ team Monetization, tôi thực hiện phân tích này cho Head of Monetization nhằm trả lời hai câu hỏi:

- **Nên chọn mô hình kiếm tiền nào?**
- **Nên ưu tiên thị trường nào?**

---

## 📚 Nguồn dữ liệu

[Google Play App Usage & Rating Dataset 2026](https://www.kaggle.com/datasets/rauffauzanrambe/google-play-app-usage-and-rating-2026) — Kaggle, CC BY 4.0

*Ghi chú: Dataset là **synthetic**, nhằm mục tiêu để tôi thực hành các kỹ năng về phân tích dữ liệu và bài toán doanh nghiệp, các khuyến nghị được đưa ra dựa trên dữ liệu của dataset chỉ áp dụng trong phạm vi của repo và dataset này.*

---

## 🛠️ Công nghệ sử dụng

| Thành phần | Công cụ |
|---|---|
| Môi trường | Docker |
| Database | PostgreSQL |
| Xử lý & phân tích | Python (pandas, numpy, seaborn, scipy) |
| Trực quan hóa | Power BI |

---

## 📁 Cấu trúc dự án

```
├── data/                      # Dataset gốc từ Kaggle (không đưa lên repo)
├── sql_preprocessing_data/    # Dữ liệu đã xử lý, export sang Python
├── preprocessing.sql          # Tạo schema, import, kiểm chứng, tạo bảng phân tích
├── eda.ipynb                  # Phân tích và trực quan hóa
├── visualization.pbix         # Dashboard 3 trang
├── report.docx                # Báo cáo kết quả
├── docker-compose.yml         # Cấu hình PostgreSQL
└── README.md
```

---

## 🚀 Cách tiến hành lại

**1. Chuẩn bị dữ liệu và công cụ**
**1.1. Chuẩn bị dữ liệu

Tải dataset từ [Kaggle](https://www.kaggle.com/datasets/rauffauzanrambe/google-play-app-usage-and-rating-2026)

*Note: Dataset gồm nhiều file nặng nên sẽ không đính kèm trong repo, ưu tiên tự tải thông qua và thực hiện local nếu muốn thực hiện lại*

**1.2. Kết nối tới PostgreSQL Sever thông qua thiết lập cấu hình cho container trong Docker (Có thể bỏ qua nếu đã có kết nối tới PostgreSQL)**

```bash
docker compose up -d
```
Kết nối `localhost:5432` và cài đặt thiết lập PostgreSQL trong phần mềm chạy code

**2. Xử lý dữ liệu từ dataset trong SQL**

Mở `preprocessing.sql` để xem lại quá trình nạp, xử lý và kiểm tra dữ liệu thô từ dataset

**3. Phân tích và khám phá dữ liệu bằng Python**

Mở `eda.ipynb` — notebook lấy dữ liệu trực tiếp từ `sql_preprocessing_data/`, không cần Docker đang chạy

**4. Dashboard**

Mở `visualization.pbix` bằng Power BI Desktop

---

## 📊 Quy mô dữ liệu

| Chỉ số | Giá trị |
|---|---|
| Dataset gốc | 10 bảng, 5.5 triệu dòng, 100,000 app |
| Sau lọc Games | 17,042 game |
| Có dữ liệu doanh thu | **14,686 game** |
| Thị trường | 35 quốc gia |
| Mô hình monetization | 5 (Free, Free with Ads, Freemium, Paid, Subscription) |

---

## 💡 Phát hiện chính

- **24.7% game tạo ra 83% doanh thu** — Paid và Subscription chỉ chiếm 3,626/14,686 game nhưng đóng góp 25.66bn/30.92bn USD

- **ARPU phân tầng theo mức độ trực tiếp thu tiền**: Free (0.0025) → Free with Ads (0.016) → Freemium (0.33) → Subscription (1.62) → Paid (2.71). Chênh lệch hơn 1,000 lần giữa cao nhất và thấp nhất

- **Quy mô game không ảnh hưởng hiệu quả monetize** — ARPU gần như không đổi giữa 3 nhóm quy mô (Freemium: 0.278 / 0.275 / 0.281). Khác biệt doanh thu đến từ số lượng người dùng, không phải từ khả năng kiếm tiền trên mỗi người

- **eCPM của Freemium cao gấp 23 lần Free with Ads** (414 vs 18.3), và là chỉ số duy nhất tăng theo quy mô game

- **India và United States dẫn đầu doanh thu** ở mọi mô hình, thứ tự đóng góp giữ nguyên qua các thị trường

Chi tiết xem [báo cáo đầy đủ](report.docx).

---

## 🔍 Mở rộng: Phát hiện về chất lượng dữ liệu

Vì dataset là synthetic nên việc kiểm chứng từng cột trước khi đưa vào phân tích lần cần thiết. Quá trình này phát hiện nhiều vấn đề.

### 4 cột bị loại khỏi phân tích

| Cột | Lý do |
|---|---|
| `in_app_purchases_count` | Game `Free` vẫn có tới 18,060 giao dịch |
| `avg_iap_value_usd` | Có giá trị 26.01 khi count = 0; phân phối gần như giống hệt ở cả 5 mô hình (~4,900 giá trị distinct mỗi nhóm) |
| `monthly_recurring_revenue_usd` | Free/Paid/Freemium đều có MRR > 0 |
| `churn_rate_pct` | Cả 5 mô hình đều có **đúng 1,901 giá trị distinct** bất kể kích thước nhóm (Free 59,704 dòng vs Paid 19,983 dòng) → sinh từ pool cố định, độc lập với mô hình |

### Các phát hiện khác

- **File CSV gốc lỗi cấu trúc**: `user_behavior.csv` và `app_ratings_reviews.csv` có ~500K dòng đầu thừa cột index (dấu hiệu `to_csv()` quên `index=False`) → viết script Python chuẩn hoá, giữ nguyên file gốc

- **Bảng `monetization` không có khóa duy nhất**: ~3,358 dòng (1.7%) cùng `app_id + report_month + subscription_tier + iap_category` nhưng số liệu khác hoàn toàn (VD APP_000052 cùng tháng 2024-12: revenue 4.74M vs 1.37M)

- **Mâu thuẫn với tài liệu dataset**: README gốc tuyên bố dữ liệu phủ 2024–2025 và "composite uniqueness is enforced" — thực tế có dữ liệu từ 2023-01 đến 2026-04 và tồn tại trùng lặp

- **Dữ liệu regional quá thưa**: 17,035 dòng / 10,689 game = 1.6 dòng/game trên 35 quốc gia → mỗi game chỉ có dữ liệu ở 1-2 nước, chỉ phân tích được ở cấp thị trường

### Cột được xác nhận đáng tin

- `monetization_type` tuân rule chặt 100% với các cột doanh thu (Free → ad_revenue = 0, conversion = 0, iap_category = N/A; Freemium → ad_revenue > 0 + iap_category có giá trị; v.v.)
- `total_revenue / arpu` cho tỷ lệ ổn định trong từng app (độ lệch ~2%, chỉ do làm tròn) → xác nhận hai cột có quan hệ công thức thật


### 🤖 Về Machine Learning

Đã kiểm chứng khả thi trước khi quyết định **không triển khai ML**:

- **Dự đoán ARPU**: correlation giữa mọi driver (retention, session, rating, sentiment, uninstall, crash, installs, app_size) và ARPU đều |r| < 0.011 → không có tín hiệu

- **Dự đoán churn cấp user**: 5/6 feature giống hệt nhau giữa nhóm churn và không churn. Chỉ `retention_days` khác biệt rõ (8.46 vs 16.11) nhưng đây là **target leakage** — retention là hệ quả của churn, không phải nguyên nhân

Kết luận: dataset không đủ tín hiệu để xây dựng mô hình dự đoán có ý nghĩa. Ghi lại quá trình kiểm chứng thay vì train model cho có.

---

## ⚠️ Hạn chế

- **Dữ liệu synthetic** — kết luận phản ánh cách sinh dữ liệu, không phải quy luật thị trường thật
- **Không có dữ liệu chi phí UA** → không tính được CAC, ROAS, payback period
- **`report_month` rời rạc không đều** → không phân tích được xu hướng theo thời gian
- **ARPU theo quốc gia không đáng tin ở thị trường ít game** → đã lọc chỉ giữ thị trường có ≥200 game
- **Không có khác biệt giữa các loại IAP hay hạng thuê bao** → không đưa ra được khuyến nghị về thiết kế gói sản phẩm

---