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

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/v1/chat/sellers/search/` | Authenticated | Cari toko penjual atau rekomendasi acak (`?q=`) |
| `POST` | `/api/v1/chat/sessions/ai/` | Buyer | Buat atau ambil sesi chat AI dengan penjual |
| `POST/DELETE` | `/api/v1/chat/sessions/<session_id>/products/` | Buyer/Seller | Tambah atau hapus konteks produk sesi (`?product_id=`) |
| `POST/DELETE` | `/api/v1/chat/sessions/<session_id>/products/delete/` | Buyer/Seller | Alternatif hapus konteks produk sesi |
| `POST` | `/api/v1/chat/sessions/<session_id>/send/` | Buyer | Kirim pesan ke bot AI (termasuk auto-handover) |
| `POST` | `/api/v1/chat/sessions/<session_id>/escalate-to-seller/` | Buyer | Alihkan sesi AI ke direct chat penjual |
| `POST` | `/api/v1/chat/sessions/<session_id>/switch-to-ai/` | Buyer | Alihkan sesi direct kembali ke asisten AI |
| `GET` | `/api/v1/chat/sessions/<session_id>/messages/` | Session participant / Admin | Ambil riwayat pesan sesi dan tandai terbaca |
| `POST` | `/api/v1/chat/sessions/<session_id>/direct-send/` | Session participant | Kirim pesan langsung pada sesi direct chat |
| `POST` | `/api/v1/chat/sessions/<session_id>/archive/` | Session participant | Toggle arsip sesi secara independen |
| `GET` | `/api/v1/chat/buyer/sessions/` | Buyer | Daftar sesi inbox pembeli (`?tab=`, `?search=`) |
| `GET` | `/api/v1/chat/seller/sessions/` | Seller | Daftar sesi direct inbox penjual (`?tab=`, `?search=`) |
| `GET/POST/PUT/PATCH` | `/api/v1/chat/seller/settings/` | Seller | Ambil atau ubah pengaturan bot dan jam operasional |
| `GET/POST` | `/api/v1/chat/seller/knowledge/` | Seller | Daftar atau tambah Q&A basis pengetahuan bot (`?product_id=`) |
| `GET/PUT/PATCH/DELETE` | `/api/v1/chat/seller/knowledge/<knowledge_id>/` | Seller | Detail, ubah, atau hapus item Q&A bot |
| `POST` | `/api/v1/chat/seller/knowledge/<knowledge_id>/toggle/` | Seller | Toggle status `is_active` item Q&A bot |
| `POST` | `/api/v1/chat/sessions/<session_id>/rating/` | Buyer | Kirim atau perbarui rating (1-5) dan feedback sesi |
| `POST` | `/api/v1/chat/reports/` | Buyer/Seller | Laporkan pelanggaran pengguna |
| `GET` | `/api/v1/chat/broadcast/channels/` | Authenticated | Daftar channel siaran toko (`?tab=`, `?search=`) |
| `GET` | `/api/v1/chat/broadcast/channels/explore/` | Authenticated | Cari dan jelajahi channel siaran toko (`?q=`) |
| `POST` | `/api/v1/chat/broadcast/channels/<channel_id>/add/` | Authenticated | Tambahkan channel ke daftar tanpa auto-follow |
| `POST` | `/api/v1/chat/broadcast/channels/<channel_id>/follow/` | Authenticated | Toggle follow/unfollow channel siaran |
| `POST` | `/api/v1/chat/broadcast/channels/<channel_id>/archive/` | Authenticated | Toggle arsip channel siaran |
| `GET` | `/api/v1/chat/broadcast/channels/<channel_id>/messages/` | Authenticated | Baca pesan siaran channel |
| `POST` | `/api/v1/chat/broadcast/channels/<channel_id>/messages/` | Seller (channel owner) | Kirim pesan siaran baru pada channel sendiri |
| `POST` | `/api/v1/chat/broadcast/channels/<channel_id>/send/` | Seller (channel owner) | Alias pengiriman pesan siaran pada channel sendiri |

Parameter tab daftar sesi dan channel:

```text
?tab=semua
?tab=belum_dibaca
?tab=belum_dibalas
?tab=diarsipkan
```
