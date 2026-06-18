import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/waste_type_model.dart';
import '../models/waste_bank_model.dart';
import '../models/deposit_model.dart';
import '../models/voucher_model.dart';
import '../models/point_transaction_model.dart';
import '../models/article_model.dart';
import '../models/achievement_model.dart';

class MockData {
  // ─── Users ────────────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'u001',
    name: 'Eja Pratama',
    email: 'eja@greenmap.id',
    phone: '081234567890',
    role: 'user',
    totalPoints: 1250,
    totalWasteKg: 25.5,
    depositCount: 8,
    createdAt: DateTime(2024, 1, 15),
    badges: ['badge_001', 'badge_002'],
  );

  static final UserModel superAdmin = UserModel(
    id: 'sa001',
    name: 'Super Admin',
    email: 'superadmin@greenmap.id',
    phone: '081000000000',
    role: 'superadmin',
    totalPoints: 0,
    createdAt: DateTime(2023, 6, 1),
  );

  static final UserModel adminBank1 = UserModel(id: 'ab001', name: 'Admin Bank Syiah Kuala', email: 'admin1@greenmap.id', phone: '081000000001', role: 'admin_bank', wasteBankId: 'wb001', createdAt: DateTime(2023, 6, 1));
  static final UserModel adminBank2 = UserModel(id: 'ab002', name: 'Admin Bank Baiturrahman', email: 'admin2@greenmap.id', phone: '081000000002', role: 'admin_bank', wasteBankId: 'wb002', createdAt: DateTime(2023, 6, 1));
  static final UserModel adminBank3 = UserModel(id: 'ab003', name: 'Admin Bank Darussalam', email: 'admin3@greenmap.id', phone: '081000000003', role: 'admin_bank', wasteBankId: 'wb003', createdAt: DateTime(2023, 6, 1));
  static final UserModel adminBank4 = UserModel(id: 'ab004', name: 'Admin Bank Peukan Bada', email: 'admin4@greenmap.id', phone: '081000000004', role: 'admin_bank', wasteBankId: 'wb004', createdAt: DateTime(2023, 6, 1));

  static final List<UserModel> users = [
    currentUser,
    UserModel(
      id: 'u002', name: 'Budi Santoso', email: 'budi@mail.com',
      phone: '082345678901', totalPoints: 2100, totalWasteKg: 42.0,
      depositCount: 15, createdAt: DateTime(2024, 2, 1),
      badges: ['badge_001', 'badge_002', 'badge_003'],
    ),
    UserModel(
      id: 'u003', name: 'Sari Dewi', email: 'sari@mail.com',
      phone: '083456789012', totalPoints: 980, totalWasteKg: 19.6,
      depositCount: 6, createdAt: DateTime(2024, 3, 10),
      badges: ['badge_001'],
    ),
    UserModel(
      id: 'u004', name: 'Rizky Fajar', email: 'rizky@mail.com',
      phone: '084567890123', totalPoints: 3400, totalWasteKg: 68.0,
      depositCount: 22, createdAt: DateTime(2023, 11, 5),
      badges: ['badge_001', 'badge_002', 'badge_003', 'badge_004'],
    ),
    UserModel(
      id: 'u005', name: 'Maya Putri', email: 'maya@mail.com',
      phone: '085678901234', totalPoints: 760, totalWasteKg: 15.2,
      depositCount: 4, createdAt: DateTime(2024, 4, 20),
      badges: ['badge_001'],
    ),
  ];

  // ─── Waste Types ──────────────────────────────────────────
  static final List<WasteTypeModel> wasteTypes = [
    const WasteTypeModel(
      id: 'wt001', name: 'Plastik', pointsPerKg: 20,
      icon: Icons.local_drink_rounded, description: 'Botol plastik, kantong, wadah',
      color: '#2196F3',
    ),
    const WasteTypeModel(
      id: 'wt002', name: 'Kardus', pointsPerKg: 15,
      icon: Icons.inventory_2_rounded, description: 'Kotak kardus, karton',
      color: '#FF9800',
    ),
    const WasteTypeModel(
      id: 'wt003', name: 'Kaleng', pointsPerKg: 25,
      icon: Icons.takeout_dining_rounded, description: 'Kaleng minuman, kaleng makanan',
      color: '#9E9E9E',
    ),
    const WasteTypeModel(
      id: 'wt004', name: 'Kertas', pointsPerKg: 10,
      icon: Icons.description_rounded, description: 'Koran, majalah, kertas bekas',
      color: '#795548',
    ),
    const WasteTypeModel(
      id: 'wt005', name: 'Kaca', pointsPerKg: 18,
      icon: Icons.wine_bar_rounded, description: 'Botol kaca, pecahan kaca',
      color: '#00BCD4',
    ),
    const WasteTypeModel(
      id: 'wt006', name: 'Elektronik', pointsPerKg: 50,
      icon: Icons.devices_rounded, description: 'Gadget, baterai, kabel bekas',
      color: '#9C27B0',
    ),
    const WasteTypeModel(
      id: 'wt007', name: 'Logam', pointsPerKg: 30,
      icon: Icons.build_rounded, description: 'Besi, tembaga, aluminium',
      color: '#607D8B',
    ),
    const WasteTypeModel(
      id: 'wt008', name: 'Minyak Jelantah', pointsPerKg: 35,
      icon: Icons.water_drop_rounded, description: 'Minyak goreng bekas pakai',
      color: '#FFC107',
    ),
  ];

  // ─── Waste Banks ──────────────────────────────────────────
  static final List<WasteBankModel> wasteBanks = [
    const WasteBankModel(
      id: 'wb001',
      name: 'Bank Sampah Syiah Kuala',
      address: 'Kopelma Darussalam, Syiah Kuala, Banda Aceh',
      lat: 5.5684, lng: 95.3670,
      phone: '0651-123456',
      openHours: '08:00 - 16:00',
      operationalDays: 'Senin - Jumat',
      acceptedWasteTypes: ['wt001', 'wt002', 'wt003', 'wt004'],
      isOpen: true,
      rating: 4.8,
    ),
    const WasteBankModel(
      id: 'wb002',
      name: 'Bank Sampah Baiturrahman',
      address: 'Kampung Baru, Baiturrahman, Banda Aceh',
      lat: 5.5532, lng: 95.3188,
      phone: '0651-234567',
      openHours: '07:00 - 15:00',
      operationalDays: 'Senin - Sabtu',
      acceptedWasteTypes: ['wt001', 'wt002', 'wt003', 'wt004', 'wt005', 'wt007'],
      isOpen: true,
      rating: 4.6,
    ),
    const WasteBankModel(
      id: 'wb003',
      name: 'Bank Sampah Darussalam',
      address: 'Lambaro Angan, Darussalam, Aceh Besar',
      lat: 5.5925, lng: 95.3854,
      phone: '0651-345678',
      openHours: '09:00 - 17:00',
      operationalDays: 'Selasa & Kamis',
      acceptedWasteTypes: ['wt001', 'wt002', 'wt004', 'wt008'],
      isOpen: false,
      rating: 4.4,
    ),
    const WasteBankModel(
      id: 'wb004',
      name: 'Bank Sampah Peukan Bada',
      address: 'Lamgeu Eu, Peukan Bada, Aceh Besar',
      lat: 5.5186, lng: 95.2758,
      phone: '0651-456789',
      openHours: '08:00 - 14:00',
      operationalDays: 'Senin - Sabtu',
      acceptedWasteTypes: ['wt001', 'wt002', 'wt003', 'wt006', 'wt007'],
      isOpen: true,
      rating: 4.9,
    ),
  ];

  // ─── Deposits ─────────────────────────────────────────────
  static List<DepositModel> deposits = [
    DepositModel(
      id: 'd001', userId: 'u001', wasteBankId: 'wb001',
      wasteBankName: 'Bank Sampah UGM',
      wasteTypeId: 'wt001', wasteTypeName: 'Plastik',
      estimatedWeight: 5.0, actualWeight: 5.2, status: DepositStatus.accepted,
      pointsEarned: 104, adminNote: 'Kondisi baik, bersih',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      processedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DepositModel(
      id: 'd002', userId: 'u001', wasteBankId: 'wb002',
      wasteBankName: 'Bank Sampah Mandiri Sehat',
      wasteTypeId: 'wt002', wasteTypeName: 'Kardus',
      estimatedWeight: 3.0, actualWeight: 3.1, status: DepositStatus.accepted,
      pointsEarned: 47, adminNote: 'Diterima',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      processedAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    DepositModel(
      id: 'd003', userId: 'u001', wasteBankId: 'wb001',
      wasteBankName: 'Bank Sampah UGM',
      wasteTypeId: 'wt003', wasteTypeName: 'Kaleng',
      estimatedWeight: 2.0, status: DepositStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    DepositModel(
      id: 'd004', userId: 'u001', wasteBankId: 'wb004',
      wasteBankName: 'Bank Sampah Digital Kotagede',
      wasteTypeId: 'wt001', wasteTypeName: 'Plastik',
      estimatedWeight: 4.0, status: DepositStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    DepositModel(
      id: 'd005', userId: 'u002', wasteBankId: 'wb001',
      wasteBankName: 'Bank Sampah UGM',
      wasteTypeId: 'wt004', wasteTypeName: 'Kertas',
      estimatedWeight: 8.0, actualWeight: 7.8, status: DepositStatus.accepted,
      pointsEarned: 78,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      processedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DepositModel(
      id: 'd006', userId: 'u003', wasteBankId: 'wb002',
      wasteBankName: 'Bank Sampah Mandiri Sehat',
      wasteTypeId: 'wt001', wasteTypeName: 'Plastik',
      estimatedWeight: 2.5, actualWeight: 2.0, status: DepositStatus.rejected,
      adminNote: 'Tercampur dengan sampah organik, tidak dapat diterima',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      processedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  // ─── Point Transactions ───────────────────────────────────
  static final List<PointTransactionModel> pointTransactions = [
    PointTransactionModel(
      id: 'pt001', userId: 'u001', amount: 104,
      type: PointTransactionType.earned,
      description: 'Plastik 5.2 Kg — Bank Sampah UGM',
      referenceId: 'd001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PointTransactionModel(
      id: 'pt002', userId: 'u001', amount: 47,
      type: PointTransactionType.earned,
      description: 'Kardus 3.1 Kg — Bank Sampah Mandiri',
      referenceId: 'd002',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    PointTransactionModel(
      id: 'pt003', userId: 'u001', amount: -500,
      type: PointTransactionType.spent,
      description: 'Voucher Kopi Janji Jiwa',
      referenceId: 'r001',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    PointTransactionModel(
      id: 'pt004', userId: 'u001', amount: 375,
      type: PointTransactionType.earned,
      description: 'Kaleng 5 Kg — Bank Sampah UGM',
      referenceId: 'd007',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    PointTransactionModel(
      id: 'pt005', userId: 'u001', amount: -200,
      type: PointTransactionType.spent,
      description: 'Voucher Grab 10K',
      referenceId: 'r002',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    PointTransactionModel(
      id: 'pt006', userId: 'u001', amount: 50,
      type: PointTransactionType.adjusted,
      description: 'Koreksi poin oleh admin',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  // ─── Vouchers ─────────────────────────────────────────────
  static List<VoucherModel> vouchers = [
    VoucherModel(
      id: 'v001', name: 'Kopi Gratis Janji Jiwa',
      description: 'Dapatkan 1 cup kopi gratis ukuran M di Janji Jiwa',
      merchant: 'Janji Jiwa', pointsCost: 500, stock: 50,
      category: VoucherCategory.coffee,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      value: 25000, isActive: true, isFeatured: true,
    ),
    VoucherModel(
      id: 'v002', name: 'Diskon 20% Kopi Kenangan',
      description: 'Diskon 20% untuk semua menu di Kopi Kenangan',
      merchant: 'Kopi Kenangan', pointsCost: 300, stock: 100,
      category: VoucherCategory.coffee,
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      value: 15000, isActive: true, isFeatured: true,
    ),
    VoucherModel(
      id: 'v003', name: 'Grab 15K',
      description: 'Voucher GrabFood senilai Rp 15.000',
      merchant: 'Grab', pointsCost: 200, stock: 200,
      category: VoucherCategory.transport,
      expiryDate: DateTime.now().add(const Duration(days: 14)),
      value: 15000, isActive: true, isFeatured: false,
    ),
    VoucherModel(
      id: 'v004', name: 'Indomaret 10K',
      description: 'Voucher belanja Indomaret senilai Rp 10.000',
      merchant: 'Indomaret', pointsCost: 150, stock: 300,
      category: VoucherCategory.minimarket,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      value: 10000, isActive: true, isFeatured: false,
    ),
    VoucherModel(
      id: 'v005', name: 'McD Gratis Kentang',
      description: 'Gratis Medium Fries di McDonald\'s',
      merchant: 'McDonald\'s', pointsCost: 400, stock: 75,
      category: VoucherCategory.food,
      expiryDate: DateTime.now().add(const Duration(days: 21)),
      value: 20000, isActive: true, isFeatured: true,
    ),
    VoucherModel(
      id: 'v006', name: 'Alfamart 5K',
      description: 'Cashback Rp 5.000 di Alfamart',
      merchant: 'Alfamart', pointsCost: 100, stock: 500,
      category: VoucherCategory.minimarket,
      expiryDate: DateTime.now().add(const Duration(days: 90)),
      value: 5000, isActive: true, isFeatured: false,
    ),
    VoucherModel(
      id: 'v007', name: 'GoFood 20K',
      description: 'Voucher GoFood senilai Rp 20.000',
      merchant: 'Gojek', pointsCost: 250, stock: 150,
      category: VoucherCategory.transport,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      value: 20000, isActive: true, isFeatured: false,
    ),
    VoucherModel(
      id: 'v008', name: 'Mixue Minuman Gratis',
      description: 'Gratis minuman reguler di Mixue',
      merchant: 'Mixue', pointsCost: 350, stock: 60,
      category: VoucherCategory.food,
      expiryDate: DateTime.now().add(const Duration(days: 28)),
      value: 18000, isActive: true, isFeatured: false,
    ),
  ];

  // ─── My Vouchers (Redemptions) ────────────────────────────
  static final List<RedemptionModel> myVouchers = [
    RedemptionModel(
      id: 'r001', userId: 'u001', voucherId: 'v001',
      voucherName: 'Kopi Gratis Janji Jiwa', merchant: 'Janji Jiwa',
      pointsSpent: 500, qrCode: 'GM-JJ-2024-001',
      uniqueCode: 'GMJJ2024001',
      status: RedemptionStatus.used,
      redeemedAt: DateTime.now().subtract(const Duration(days: 15)),
      expiresAt: DateTime.now().subtract(const Duration(days: 5)),
      voucherValue: 25000,
    ),
    RedemptionModel(
      id: 'r002', userId: 'u001', voucherId: 'v003',
      voucherName: 'Grab 15K', merchant: 'Grab',
      pointsSpent: 200, qrCode: 'GM-GB-2024-002',
      uniqueCode: 'GMGB2024002',
      status: RedemptionStatus.active,
      redeemedAt: DateTime.now().subtract(const Duration(days: 3)),
      expiresAt: DateTime.now().add(const Duration(days: 11)),
      voucherValue: 15000,
    ),
    RedemptionModel(
      id: 'r003', userId: 'u001', voucherId: 'v004',
      voucherName: 'Indomaret 10K', merchant: 'Indomaret',
      pointsSpent: 150, qrCode: 'GM-IM-2024-003',
      uniqueCode: 'GMIM2024003',
      status: RedemptionStatus.expired,
      redeemedAt: DateTime.now().subtract(const Duration(days: 40)),
      expiresAt: DateTime.now().subtract(const Duration(days: 10)),
      voucherValue: 10000,
    ),
  ];

  // ─── Articles ─────────────────────────────────────────────
  static final List<ArticleModel> articles = [
    ArticleModel(
      id: 'a001',
      title: 'Cara Memilah Sampah yang Benar di Rumah',
      summary: 'Pemilahan sampah sejak dari sumber adalah kunci keberhasilan program daur ulang.',
      content: '''Pemilahan sampah adalah langkah pertama yang sangat penting dalam pengelolaan sampah yang bertanggung jawab. Dengan memilah sampah sejak dari sumber (rumah tangga), kita dapat memaksimalkan nilai daur ulang dan mengurangi beban tempat pembuangan akhir.

**Kategori Sampah Utama:**

**1. Sampah Organik** 🌿
Termasuk sisa makanan, sayuran, buah-buahan, dan daun. Sampah organik dapat dijadikan kompos yang bermanfaat untuk pertanian.

**2. Sampah Anorganik** ♻️
Plastik, kertas, kaca, logam, dan karet. Sampah ini dapat didaur ulang menjadi produk baru.

**3. Sampah B3 (Berbahaya dan Beracun)** ⚠️
Baterai bekas, obat-obatan, cat, dan produk elektronik. Memerlukan penanganan khusus.

**Tips Praktis:**
- Siapkan minimal 3 tempat sampah berbeda
- Cuci wadah plastik dan kaca sebelum dibuang
- Lipat kardus agar tidak memakan banyak tempat
- Pisahkan baterai dan elektronik bekas

Dengan memilah sampah, kita berkontribusi pada SDG 12 — Konsumsi dan Produksi yang Bertanggung Jawab.''',
      category: 'Tips & Trik',
      author: 'Tim GreenMap',
      readMinutes: 4,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      isFeatured: true,
      imageUrl: 'assets/images/education_thumb.png',
    ),
    ArticleModel(
      id: 'a002',
      title: 'Manfaat Daur Ulang untuk Lingkungan dan Ekonomi',
      summary: 'Daur ulang bukan hanya ramah lingkungan, tapi juga menguntungkan secara ekonomi.',
      content: '''Daur ulang sampah memberikan manfaat ganda: menjaga kelestarian lingkungan sekaligus menggerakkan ekonomi sirkular yang berkelanjutan.

**Manfaat Lingkungan:**
- Mengurangi emisi gas rumah kaca
- Menghemat energi produksi
- Mengurangi eksploitasi sumber daya alam
- Mengurangi pencemaran tanah dan air

**Manfaat Ekonomi:**
- Menciptakan lapangan kerja di sektor daur ulang
- Menghasilkan pendapatan dari penjualan material daur ulang
- Menghemat biaya pengelolaan sampah kota
- Mendukung industri berbasis material daur ulang

**Fakta Menarik:**
- Mendaur ulang 1 ton kertas menyelamatkan 17 pohon
- Aluminium dapat didaur ulang tanpa batas
- Daur ulang plastik menghemat 70% energi dibanding produksi baru

GreenMap hadir untuk memudahkan Anda berkontribusi dalam ekosistem daur ulang yang lebih baik!''',
      category: 'Edukasi',
      author: 'Dr. Lingkungan Hidup',
      readMinutes: 5,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      isFeatured: false,
    ),
    ArticleModel(
      id: 'a003',
      title: 'SDG 12: Konsumsi dan Produksi yang Bertanggung Jawab',
      summary: 'Memahami tujuan pembangunan berkelanjutan nomor 12 dan peran kita.',
      content: '''SDG 12 (Sustainable Development Goal 12) berfokus pada "Responsible Consumption and Production" — memastikan pola konsumsi dan produksi yang berkelanjutan di seluruh dunia.

**Target Utama SDG 12:**
- Mengurangi limbah makanan global sebesar 50% pada 2030
- Pengelolaan kimia dan limbah berbahaya yang ramah lingkungan
- Mengurangi timbulan sampah melalui pencegahan, pengurangan, daur ulang, dan penggunaan kembali
- Mendorong laporan keberlanjutan oleh perusahaan

**Apa yang Bisa Kita Lakukan?**

✅ Kurangi penggunaan plastik sekali pakai
✅ Pilih produk dengan kemasan ramah lingkungan
✅ Daur ulang sampah melalui bank sampah
✅ Kompos sisa makanan
✅ Beli produk second-hand atau refurbished

**Peran GreenMap:**
GreenMap menjembatani masyarakat dengan bank sampah terdekat, memberikan insentif berupa poin untuk setiap kilogram sampah yang disetor, mendukung terwujudnya SDG 12 di tingkat lokal.

Mari bersama wujudkan Indonesia bebas sampah 2030! 🌿''',
      category: 'SDG & Kebijakan',
      author: 'GreenMap Research',
      readMinutes: 6,
      publishedAt: DateTime.now().subtract(const Duration(days: 8)),
      isFeatured: true,
    ),
    ArticleModel(
      id: 'a004',
      title: 'Mengenal Jenis-Jenis Plastik dan Cara Daur Ulangnya',
      summary: 'Tidak semua plastik sama. Pelajari kode plastik dan mana yang bisa didaur ulang.',
      content: '''Plastik merupakan material yang paling banyak kita jumpai dalam kehidupan sehari-hari, namun tidak semua plastik bisa didaur ulang dengan cara yang sama.

**Kode Plastik (Segitiga Daur Ulang):**

🔷 **PET (Kode 1)** — Botol minum, mudah didaur ulang
🔶 **HDPE (Kode 2)** — Jerigen, botol sampo, mudah didaur ulang
🔵 **PVC (Kode 3)** — Pipa, susah didaur ulang, berbahaya
🟡 **LDPE (Kode 4)** — Kantong belanja, bisa didaur ulang terbatas
🟢 **PP (Kode 5)** — Tutup botol, wadah makanan, bisa didaur ulang
🔴 **PS (Kode 6)** — Styrofoam, sulit didaur ulang
⚫ **Lainnya (Kode 7)** — Galon, sulit didaur ulang

**Tips:**
- Prioritaskan menyetor plastik kode 1, 2, dan 5
- Bersihkan plastik dari sisa makanan sebelum disetor
- Pisahkan plastik keras dan plastik lunak

Di GreenMap, kami menerima berbagai jenis plastik dan memberikan poin sesuai bobotnya!''',
      category: 'Pengetahuan Sampah',
      author: 'Tim GreenMap',
      readMinutes: 3,
      publishedAt: DateTime.now().subtract(const Duration(days: 12)),
      isFeatured: false,
    ),
  ];

  // ─── Achievements ─────────────────────────────────────────
  static final List<AchievementModel> achievements = [
    AchievementModel(
      id: 'badge_001', name: 'Pemula Hijau',
      description: 'Selesaikan setoran pertamamu', icon: Icons.eco_rounded,
      requiredCount: 1, type: 'deposit_count',
      isUnlocked: true, unlockedAt: DateTime(2024, 2, 1),
      color: '#4CAF50',
    ),
    AchievementModel(
      id: 'badge_002', name: 'Pejuang Daur Ulang',
      description: 'Setorkan sampah sebanyak 5 kali', icon: Icons.recycling_rounded,
      requiredCount: 5, type: 'deposit_count',
      isUnlocked: true, unlockedAt: DateTime(2024, 3, 15),
      color: '#2196F3',
    ),
    AchievementModel(
      id: 'badge_003', name: 'Eco Warrior',
      description: 'Setorkan sampah sebanyak 10 kali', icon: Icons.shield_rounded,
      requiredCount: 10, type: 'deposit_count',
      isUnlocked: false, color: '#FF9800',
    ),
    AchievementModel(
      id: 'badge_004', name: 'Penyelamat Bumi',
      description: 'Kumpulkan total 50 kg sampah', icon: Icons.public_rounded,
      requiredCount: 50, type: 'waste_kg',
      isUnlocked: false, color: '#9C27B0',
    ),
    AchievementModel(
      id: 'badge_005', name: 'Master Hijau',
      description: 'Kumpulkan 1000 poin', icon: Icons.emoji_events_rounded,
      requiredCount: 1000, type: 'points_earned',
      isUnlocked: true, unlockedAt: DateTime(2024, 4, 1),
      color: '#FFD700',
    ),
    AchievementModel(
      id: 'badge_006', name: 'Champion Sampah',
      description: 'Setorkan sampah sebanyak 20 kali', icon: Icons.military_tech_rounded,
      requiredCount: 20, type: 'deposit_count',
      isUnlocked: false, color: '#F44336',
    ),
  ];

  // ─── Leaderboard ──────────────────────────────────────────
  static final List<LeaderboardEntry> leaderboard = [
    LeaderboardEntry(userId: 'u004', userName: 'Rizky Fajar',
      totalPoints: 3400, totalWasteKg: 68.0, rank: 1,
      institution: 'UGM'),
    LeaderboardEntry(userId: 'u002', userName: 'Budi Santoso',
      totalPoints: 2100, totalWasteKg: 42.0, rank: 2,
      institution: 'UNY'),
    LeaderboardEntry(userId: 'u001', userName: 'Eja Pratama',
      totalPoints: 1250, totalWasteKg: 25.5, rank: 3,
      institution: 'UGM'),
    LeaderboardEntry(userId: 'u003', userName: 'Sari Dewi',
      totalPoints: 980, totalWasteKg: 19.6, rank: 4,
      institution: 'AMIKOM'),
    LeaderboardEntry(userId: 'u005', userName: 'Maya Putri',
      totalPoints: 760, totalWasteKg: 15.2, rank: 5,
      institution: 'UII'),
  ];

  // ─── Admin Stats ──────────────────────────────────────────
  static final Map<String, dynamic> adminStats = {
    'totalUsers': 5,
    'totalDeposits': 24,
    'totalWasteKg': 170.5,
    'totalPointsGiven': 8490,
    'vouchersRedeemed': 12,
    'monthlyWaste': [12.5, 18.0, 22.3, 28.0, 35.2, 30.0],
    'activeUsers': [2, 3, 4, 5, 5, 4],
    'months': ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'],
  };
}
