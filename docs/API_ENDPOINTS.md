# BhumiLestari Web API

## Base URL

Production:

```text
https://sultan-noor-bhumilestari.pws.cs.ui.ac.id
```

Local Android emulator:

```text
http://10.0.2.2:8000
```

Base URL dapat diganti saat menjalankan Flutter:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Authentication

Endpoint privat menggunakan DRF token authentication:

```http
Authorization: Token <token-login>
Accept: application/json
```

Token diperoleh dari `POST /api/v1/users/login/` dan disimpan oleh aplikasi
melalui `flutter_secure_storage`.

## Users

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `POST` | `/api/v1/users/otp/send/` | Public | Mengirim OTP registrasi |
| `POST` | `/api/v1/users/register/` | Public | Registrasi buyer atau seller |
| `POST` | `/api/v1/users/login/` | Public | Login dan memperoleh token |
| `POST` | `/api/v1/users/logout/` | Authenticated | Logout dan menghapus token server |
| `GET` | `/api/v1/users/profile/` | Authenticated | Membaca profil sendiri |
| `PUT/PATCH` | `/api/v1/users/profile/` | Authenticated | Memperbarui profil sendiri |
| `POST` | `/api/v1/users/password/` | Authenticated | Mengubah password |
| `GET/POST` | `/api/v1/users/payment-methods/` | Authenticated | Daftar atau tambah metode pembayaran |
| `DELETE` | `/api/v1/users/payment-methods/<id>/` | Authenticated | Menghapus metode pembayaran |
| `POST/DELETE` | `/api/v1/users/account/delete/` | Authenticated | Menghapus akun sendiri |

## Products

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/v1/products/` | Public | Katalog produk terverifikasi |
| `GET` | `/api/v1/products/<product_id>/` | Public | Detail produk |
| `GET/POST` | `/api/v1/products/mine/` | Seller | Daftar atau tambah produk sendiri |
| `GET/PATCH/DELETE` | `/api/v1/products/mine/<product_id>/` | Seller | Kelola produk sendiri |
| `GET` | `/api/v1/products/eco-features/` | Public | Daftar eco feature |
| `GET` | `/api/v1/products/admin/verification/` | Admin | Antrean verifikasi produk |
| `GET/PATCH` | `/api/v1/products/admin/verification/<product_id>/` | Admin | Detail dan keputusan verifikasi |

## Reviews

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/v1/reviews/toko/<store_id>/` | Public | Daftar ulasan suatu toko |
| `POST` | `/api/v1/reviews/toko/<store_id>/` | Authenticated buyer | Membuat ulasan |
| `GET` | `/api/v1/reviews/saya/` | Authenticated | Daftar ulasan sendiri |
| `PATCH/DELETE` | `/api/v1/reviews/<review_id>/` | Review owner | Mengubah atau menghapus ulasan |
| `POST/PATCH/DELETE` | `/api/v1/reviews/<review_id>/balasan/` | Seller | Mengelola balasan seller |
| `POST` | `/api/v1/reviews/<review_id>/laporan/` | Authenticated | Melaporkan ulasan |
| `GET` | `/api/v1/reviews/laporan/` | Admin | Daftar laporan moderasi |
| `PATCH` | `/api/v1/reviews/laporan/<report_id>/` | Admin | Memproses laporan moderasi |

## Checkout

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/v1/checkout/cart/` | Buyer | Melihat keranjang |
| `POST` | `/api/v1/checkout/cart/items/` | Buyer | Menambahkan produk ke keranjang |
| `PATCH/DELETE` | `/api/v1/checkout/cart/items/<item_id>/` | Buyer | Mengubah atau menghapus item |
| `PATCH` | `/api/v1/checkout/cart/selection/` | Buyer | Memilih item checkout |
| `GET` | `/api/v1/checkout/summary/` | Buyer | Ringkasan checkout |
| `GET` | `/api/v1/checkout/orders/` | Buyer/Seller | Daftar pesanan sesuai role |
| `POST` | `/api/v1/checkout/orders/` | Buyer | Membuat pesanan |
| `GET/PATCH` | `/api/v1/checkout/orders/<order_id>/` | Buyer/Seller | Detail atau perubahan status pesanan |

## Dashboard

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/v1/dashboard/seller/summary/` | Seller | Ringkasan toko seller |
| `GET` | `/api/v1/dashboard/sales-report/` | Seller/Admin | Laporan penjualan |

Parameter laporan:

```text
?period=mingguan
?period=bulanan
```

## Chat

Chat UI sudah tersedia di Flutter, tetapi backend `main` belum menyediakan
endpoint `/api/v1/chat/`. Integrasi data Chat harus menunggu kontrak API dari
modul Chat dan tidak boleh menggunakan endpoint buatan sendiri.
