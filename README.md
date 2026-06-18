# GreenMap

GreenMap adalah aplikasi revolusioner berbasis *Flutter* yang dirancang untuk memudahkan masyarakat dalam mengelola sampah mereka secara bijak. Aplikasi ini menghubungkan pengguna dengan Bank Sampah terdekat, memungkinkan penyetoran sampah untuk ditukar menjadi poin, serta menyediakan *Marketplace* untuk menukarkan poin dengan berbagai *voucher* menarik.

## Fitur Utama
- **Lokasi Bank Sampah:** Cari dan temukan Bank Sampah terdekat menggunakan peta interaktif.
- **Setor Sampah:** Pengguna dapat menyetor sampah yang dapat didaur ulang dan mendapatkan poin.
- **Tukar Poin (Marketplace):** Poin yang terkumpul dapat ditukar dengan voucher belanja, pulsa, atau diskon.
- **Edukasi Lingkungan:** Artikel dan panduan untuk hidup lebih ramah lingkungan.
- **Sistem Peran (Role):** Memiliki antarmuka dan hak akses berbeda untuk *User* biasa, *Admin Bank*, dan *Super Admin*.

---

## Panduan Menjalankan Aplikasi (Mock Data) 🚀

Aplikasi ini saat ini berjalan menggunakan **Data Mock (Dummy)**. Semua data disimpan secara sementara di memori aplikasi selama sesi berjalan. Anda tidak perlu menghubungkan aplikasi ke backend atau database apapun.

Untuk menjalankan aplikasi ini:
1. Pastikan Anda sudah menginstal [Flutter](https://docs.flutter.dev/get-started/install).
2. Jalankan `flutter pub get` untuk mengunduh semua *dependencies*.
3. Jalankan aplikasi menggunakan `flutter run`.

---

## Akun Demo (Login) 🔐

Gunakan akun-akun di bawah ini untuk menguji berbagai fitur dan peran yang ada di dalam aplikasi.

### 1. Akun Pengguna (User)
Gunakan akun ini untuk mengetes fitur menyetor sampah, melihat peta, melihat riwayat poin, dan menukarkan voucher.
- **Email:** `eja@greenmap.id`
- **Password:** `user123`

*Catatan: Anda juga dapat mendaftar (Register) akun baru. Akun baru yang didaftarkan akan disimpan secara sementara di memori dan dapat digunakan untuk login kembali selama aplikasi belum di-restart.*

### 2. Akun Admin Bank Sampah (Admin Bank)
Gunakan akun ini untuk menerima atau menolak setoran sampah dari pengguna yang masuk ke bank sampah spesifik Anda.
- **Email:** `admin1@greenmap.id` (Admin Bank Syiah Kuala)
- **Password:** `admin123`
- *(Tersedia juga `admin2@greenmap.id` hingga `admin4@greenmap.id` dengan password yang sama).*

### 3. Akun Super Admin (Super Admin)
Gunakan akun ini untuk mengakses dashboard pengelolaan *Voucher* (membuat, mengedit, dan menghapus voucher).
- **Email:** `superadmin@greenmap.id`
- **Password:** `admin123`

---

## Arsitektur & Teknologi 🛠️
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Routing:** GoRouter (Dengan ShellRoute untuk navigasi bawah bersarang)
- **Peta:** Flutter Map (Leaflet) dengan OpenStreetMap
- **Data:** *In-Memory Mock Data* (Model, Provider, dan Repository lokal)
