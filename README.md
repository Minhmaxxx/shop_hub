# ShopHub

ShopHub là một ứng dụng thương mại điện tử mẫu viết bằng Flutter. Project này bao gồm:
- Ứng dụng Flutter (Android / iOS / Windows)
- Firebase (Authentication + Firestore + Storage)
- Backend mock (node + json) trong thư mục `backend` (có thể chạy local hoặc dùng endpoint deploy sẵn)

## Tính năng chính
- Hiển thị danh sách sản phẩm từ API
- Tìm kiếm & lọc theo category (kéo ngang + nút trái/phải)
- Đăng ký / đăng nhập (Email, Google, Facebook) bằng Firebase Auth
- Giỏ hàng được đồng bộ lên Firestore cho user đã đăng nhập
- Trang profile, trang chi tiết sản phẩm, checkout cơ bản

## Cấu trúc dự án (chính)
- lib/ : mã nguồn Flutter
  - providers/ : provider (Auth, Product, Cart)
  - screens/ : màn hình
  - models/ : các model
  - services/ : service kết nối Firebase / storage / backend
  - widgets/ : widget tùy chỉnh
- backend/ : mock API (server.js, db.json)
- android/, ios/, windows/ : native projects

---

## Yêu cầu trước khi chạy
- Flutter SDK (phiên bản tương thích với project)
- Node.js & npm (chạy backend local)
- Firebase project (nếu muốn sync Firestore + Auth)
- Firebase CLI (nếu deploy rules) — optional

---

## Cài đặt & chạy (Windows)
1. Clone repo
   - GitHub: `git clone <your-repo-url>`
2. Cài dependencies Flutter
   - Mở terminal ở thư mục project:
     - `flutter pub get`
3. (Tùy chọn) Chạy backend mock local:
   - Vào thư mục `backend`:
     - `cd backend`
     - `npm install`
     - `npm start`
   - Mặc định server lắng nghe ở `http://localhost:3000` (kiểm tra `server.js`)
   - Lưu ý: product_provider mặc định sử dụng API `https://shop-hub-backend-34kc.onrender.com`. Nếu muốn dùng local, chỉnh `_baseUrl` trong `lib/providers/product_provider.dart`.

4. (Nếu dùng Firebase) Thêm cấu hình Firebase:
   - Thêm `google-services.json` (Android) vào `android/app/`
   - Thêm `GoogleService-Info.plist` (iOS) vào `ios/Runner/`
   - Hoặc chạy `flutterfire configure` để tạo `lib/firebase_options.dart` (project đã chứa file mẫu).

5. Chạy app:
   - `flutter run` (kết nối thiết bị hoặc emulator)

---
App Screenshots

| Login | Home | Profile |
|:------:|:------:|:------:|
| <img src="https://github.com/user-attachments/assets/656cb28a-6ef1-4cae-990a-489ade0b0ff" width="180"/> | <img src="https://github.com/user-attachments/assets/59c9e69f-0de1-4840-a34b-7132ab615b41" width="180"/> | <img src="https://github.com/user-attachments/assets/d3bdcf7e-74ff-4457-85fa-13ecde4e8539" width="180"/> |

| Cart | Pay1 | Pay2 |
|:------:|:------:|:------:|
| <img src="https://github.com/user-attachments/assets/baa1e46c-e812-44e4-853e-c3ade70d79e1" width="180"/> | <img src="https://github.com/user-attachments/assets/a0398221-5376-4f2a-9ec1-434bc81b1c2f" width="180"/> |<img src="https://github.com/user-attachments/assets/477818d8-926a-4dcd-96ab-4751475d8fd4" width="180"/> |

