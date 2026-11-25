# Proyek Akhir Kelompok 8 - PBP E

## BhumiLestari (Mobile Version)

> Integrasi Flutter Framework - Django Web API Service

## Identitas Kelompok
| Nama | NPM |
| --- | --- |
| Alfarrel Ersya Balawa | 2506656406 |
| Athifah Mufidah | 2506612045 |
| Nurfadhil Kurniawan | 2506540765 |
| Regina Gunadi | 2506542852 |
| Sultan Noor Dafiq | 2506600713 |

## Deskripsi Aplikasi
<div align ="justify">
Marketplace yang menjual berbagai macam produk eco-friendly (pakaian, perlengkapan sehari-hari, home & kitchen supplies, furniture, beauty & care) dari penjual yang telah terverifikasi.
</div>

## Peran Pengguna Aplikasi
<div align = "justify">
Semua orang yang peduli terkait masalah lingkungan dan ingin berusaha mengurangi dampaknya dengan menggunakan produk eco-friendly. Pada aplikasi terdapat 4 peran: Guest, Buyer, Seller, dan Admin.
</div>

| Peran | Keterangan |
| --- | --- |
| Guest | Pengunjung yang belum login, hanya dapat melihat katalog produk |
| Buyer | Pembeli yang sudah login, dapat melihat katalog dan berbelanja, memberi review |
| Seller | Penjual, mengelola produk tokonya sendiri (tambah, ubah, hapus) |
| Admin | Admin, memverifikasi produk penjual (menyetujui atau menolak) |

## Daftar Modul & Pembagian Kerja Anggota
| Nomor | Modul | Fungsi | Pemilik |
| --- | --- | --- | --- |
| 1. | User | Laman Profile, Login/Sign Up Pembeli/Penjual | Nurfadhil Kurniawan |
| 2. | Produk | Laman Katalog Produk | Regina Gunadi |
| 3. | Chat | Laman Chat Penjual/Pembeli | Alfarrel Ersya Balawa |
| 4. | Ulasan Toko | Laman Ulasan + Rating Toko | Sultan Noor Dafiq |
| 5. | Keranjang | Laman Keranjang & Checkout | Athifah Mufidah |

## Alur Pengintegrasian Data
Backend menggunakan Django REST Framework dengan autentikasi token untuk
endpoint privat. Dokumentasi endpoint lengkap tersedia di
[`docs/API_ENDPOINTS.md`](docs/API_ENDPOINTS.md).

Base URL production:

```text
https://sultan-noor-bhumilestari.pws.cs.ui.ac.id
```

Untuk menjalankan aplikasi dengan backend lokal pada Android emulator:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### Endpoint DRF Modul Produk - Regina Gunadi
| Operasi | Guest | Buyer | Seller | Admin |
|---|---|---|---|---|
| Create | - | - | `POST /api/v1/products/mine/` | - |
| Read (daftar produk) | `GET /api/v1/products/` | `GET /api/v1/products/` | `GET /api/v1/products/mine/` | `GET /api/v1/products/admin/verification/` |
| Read (detail per produk) | `GET /api/v1/products/<product_id>/` | `GET /api/v1/products/<product_id>/` | `GET /api/v1/products/mine/<product_id>/` | `GET /api/v1/products/admin/verification/<product_id>/` |
| Update | - | - | `PATCH /api/v1/products/mine/<product_id>/` | `PATCH /api/v1/products/admin/verification/<product_id>/` |
| Delete | - | - | `DELETE /api/v1/products/mine/<product_id>/` | - |

### Endpoint DRF Modul Ulasan Toko - Sultan Noor Dafiq
| Operasi | Guest | Buyer | Seller | Admin |
|---|---|---|---|---|
| Create | - | `POST /api/v1/reviews/toko/<store_id>/` | `POST /api/v1/reviews/<review_id>/balasan/` | - |
| Read (daftar ulasan toko) | `GET /api/v1/reviews/toko/<store_id>/` | `GET /api/v1/reviews/toko/<store_id>/` | `GET /api/v1/reviews/toko/<store_id>/` | `GET /api/v1/reviews/laporan/` |
| Read (ulasan sendiri) | - | `GET /api/v1/reviews/saya/` | - | - |
| Update | - | `PATCH /api/v1/reviews/<review_id>/` | `PATCH /api/v1/reviews/<review_id>/balasan/` | `PATCH /api/v1/reviews/laporan/<report_id>/` |
| Delete | - | `DELETE /api/v1/reviews/<review_id>/` | `DELETE /api/v1/reviews/<review_id>/balasan/` | - |
| Report | - | `POST /api/v1/reviews/<review_id>/laporan/` | `POST /api/v1/reviews/<review_id>/laporan/` | `GET /api/v1/reviews/laporan/` |

### Endpoint DRF Modul Keranjang & Checkout - Athifah Mufidah
| Operasi | Guest | Buyer | Seller | Admin |
|---|---|---|---|---|
| Create (item keranjang) | - | `POST /api/v1/checkout/cart/items/` | - | - |
| Create (pesanan) | - | `POST /api/v1/checkout/orders/` | - | - |
| Read (keranjang) | - | `GET /api/v1/checkout/cart/` | - | - |
| Read (ringkasan checkout) | - | `GET /api/v1/checkout/summary/` | - | - |
| Read (pesanan) | - | `GET /api/v1/checkout/orders/`<br>`GET /api/v1/checkout/orders/<order_id>/` | `GET /api/v1/checkout/orders/`<br>`GET /api/v1/checkout/orders/<order_id>/` | - |
| Update (item keranjang) | - | `PATCH /api/v1/checkout/cart/items/<item_id>/`<br>`PATCH /api/v1/checkout/cart/selection/` | - | - |
| Update (status pesanan) | - | `PATCH /api/v1/checkout/orders/<order_id>/` | `PATCH /api/v1/checkout/orders/<order_id>/` | - |
| Delete | - | `DELETE /api/v1/checkout/cart/items/<item_id>/` | - | - |

### Endpoint DRF Modul Chat - Alfarrel Ersya Balawa
| Operasi | Guest | Buyer | Seller | Admin |
|---|---|---|---|---|
| Create (sesi AI & kirim pesan) | - | `POST /api/v1/chat/sessions/ai/`<br>`POST /api/v1/chat/sessions/<session_id>/send/`<br>`POST /api/v1/chat/sessions/<session_id>/direct-send/` | `POST /api/v1/chat/sessions/<session_id>/direct-send/` | `POST /api/v1/chat/sessions/<session_id>/direct-send/` |
| Create (konteks produk sesi) | - | `POST /api/v1/chat/sessions/<session_id>/products/` | `POST /api/v1/chat/sessions/<session_id>/products/` | - |
| Create (rating sesi) | - | `POST /api/v1/chat/sessions/<session_id>/rating/` | - | - |
| Create (knowledge base bot) | - | - | `POST /api/v1/chat/seller/knowledge/` | - |
| Create (pesan siaran channel) | - | - | `POST /api/v1/chat/broadcast/channels/<channel_id>/messages/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/send/` | - |
| Read (pencarian penjual) | - | `GET /api/v1/chat/sellers/search/` | `GET /api/v1/chat/sellers/search/` | `GET /api/v1/chat/sellers/search/` |
| Read (daftar sesi inbox) | - | `GET /api/v1/chat/buyer/sessions/` | `GET /api/v1/chat/seller/sessions/` | - |
| Read (riwayat pesan sesi) | - | `GET /api/v1/chat/sessions/<session_id>/messages/` | `GET /api/v1/chat/sessions/<session_id>/messages/` | `GET /api/v1/chat/sessions/<session_id>/messages/` |
| Read (pengaturan & knowledge bot) | - | - | `GET /api/v1/chat/seller/settings/`<br>`GET /api/v1/chat/seller/knowledge/`<br>`GET /api/v1/chat/seller/knowledge/<knowledge_id>/` | - |
| Read (channel & pesan siaran) | - | `GET /api/v1/chat/broadcast/channels/`<br>`GET /api/v1/chat/broadcast/channels/explore/`<br>`GET /api/v1/chat/broadcast/channels/<channel_id>/messages/` | `GET /api/v1/chat/broadcast/channels/`<br>`GET /api/v1/chat/broadcast/channels/explore/`<br>`GET /api/v1/chat/broadcast/channels/<channel_id>/messages/` | `GET /api/v1/chat/broadcast/channels/`<br>`GET /api/v1/chat/broadcast/channels/explore/`<br>`GET /api/v1/chat/broadcast/channels/<channel_id>/messages/` |
| Update (handover AI/direct & arsip sesi) | - | `POST /api/v1/chat/sessions/<session_id>/escalate-to-seller/`<br>`POST /api/v1/chat/sessions/<session_id>/switch-to-ai/`<br>`POST /api/v1/chat/sessions/<session_id>/archive/` | `POST /api/v1/chat/sessions/<session_id>/archive/` | `POST /api/v1/chat/sessions/<session_id>/archive/` |
| Update (pengaturan & knowledge bot) | - | - | `POST/PUT/PATCH /api/v1/chat/seller/settings/`<br>`PUT/PATCH /api/v1/chat/seller/knowledge/<knowledge_id>/`<br>`POST /api/v1/chat/seller/knowledge/<knowledge_id>/toggle/` | - |
| Update (tambah, follow, arsip channel) | - | `POST /api/v1/chat/broadcast/channels/<channel_id>/add/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/follow/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/archive/` | `POST /api/v1/chat/broadcast/channels/<channel_id>/add/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/follow/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/archive/` | `POST /api/v1/chat/broadcast/channels/<channel_id>/add/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/follow/`<br>`POST /api/v1/chat/broadcast/channels/<channel_id>/archive/` |
| Delete (konteks produk sesi) | - | `DELETE /api/v1/chat/sessions/<session_id>/products/`<br>`POST/DELETE /api/v1/chat/sessions/<session_id>/products/delete/` | `DELETE /api/v1/chat/sessions/<session_id>/products/`<br>`POST/DELETE /api/v1/chat/sessions/<session_id>/products/delete/` | - |
| Delete (knowledge base bot) | - | - | `DELETE /api/v1/chat/seller/knowledge/<knowledge_id>/` | - |
| Report | - | `POST /api/v1/chat/reports/` | `POST /api/v1/chat/reports/` | - |

## Navigasi Aplikasi

Navigasi Flutter menggunakan named route yang dipusatkan pada
`lib/navigation/app_router.dart`. Route lama `/produk` tetap dipertahankan
sebagai alias agar kompatibel dengan pekerjaan anggota lain.

| Route | Halaman |
|---|---|
| `/` | Beranda/Ringkasan |
| `/products` | Produk |
| `/cart` | Keranjang |
| `/orders` | Pesanan atau riwayat pembelian |
| `/sales-report` | Laporan penjualan |
| `/chat` | Chat pembeli |
| `/profile` | Profil pengguna |
| `/admin/products` | Verifikasi produk admin |
| `/admin/reviews` | Moderasi ulasan admin |

Bottom navigation disusun berdasarkan role:

| Role | Menu utama |
|---|---|
| Guest | Produk, Login |
| Buyer | Produk, Keranjang, Riwayat Beli, Chat, Pengguna |
| Seller | Ringkasan, Produk, Pesanan, Laporan Penjualan, Chat, Pengguna |
| Admin | Verifikasi Produk, Moderasi Ulasan, Laporan Penjualan, Pengguna |

## Tautan Design Figma 
https://www.figma.com/design/JG0Xg7sLjXzbTzazoMqXJY/Project-E08?m=auto&t=nzirHQ1MJJJQBQYP-6

## Tautan APK
(INCOMING)
