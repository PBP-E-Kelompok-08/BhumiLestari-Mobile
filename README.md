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
### Modul Produk - Regina 
| Operasi | Guest | Buyer | Seller | Admin |
|---|---|---|---|---|
| Create | - | - | `POST /api/v1/products/mine/` | - |
| Read (daftar produk) | `GET /api/v1/products/` | `GET /api/v1/products/` | `GET /api/v1/products/mine/` | `GET /api/v1/products/admin/verification/` |
| Read (detail per produk) | `GET /api/v1/products/<product_id>/` | `GET /api/v1/products/<product_id>/` | `GET /api/v1/products/mine/<product_id>/` | `GET /api/v1/products/admin/verification/<product_id>/` |
| Update | - | - | `PATCH /api/v1/products/mine/<product_id>/` | `PATCH /api/v1/products/admin/verification/<product_id>/` |
| Delete | - | - | `DELETE /api/v1/products/mine/<product_id>/` | - |

## Tautan Design Figma 
https://www.figma.com/design/JG0Xg7sLjXzbTzazoMqXJY/Project-E08?node-id=1-4&p=f&t=WYGNfy6ztcR4rRba-0

## Tautan APK
(INCOMING)