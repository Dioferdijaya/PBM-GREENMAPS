import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/voucher_model.dart';
import '../../providers/voucher_provider.dart';
import '../../shared/widgets/green_text_field.dart';

class CreateVoucherScreen extends StatefulWidget {
  final VoucherModel? editVoucher; // null = create, non-null = edit
  const CreateVoucherScreen({super.key, this.editVoucher});

  @override
  State<CreateVoucherScreen> createState() => _CreateVoucherScreenState();
}

class _CreateVoucherScreenState extends State<CreateVoucherScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _merchantCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _pointsCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _minTransCtrl;

  // State
  VoucherCategory _category = VoucherCategory.other;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 30));
  bool _isFeatured = false;
  bool _isActive = true;

  bool get _isEdit => widget.editVoucher != null;

  static const _catColors = {
    VoucherCategory.coffee: Color(0xFF6D4C41),
    VoucherCategory.food: Color(0xFFE65100),
    VoucherCategory.minimarket: Color(0xFF1565C0),
    VoucherCategory.transport: Color(0xFF00796B),
    VoucherCategory.other: Color(0xFF6A1B9A),
  };

  @override
  void initState() {
    super.initState();
    final v = widget.editVoucher;
    _nameCtrl = TextEditingController(text: v?.name ?? '');
    _descCtrl = TextEditingController(text: v?.description ?? '');
    _merchantCtrl = TextEditingController(text: v?.merchant ?? '');
    _valueCtrl = TextEditingController(text: v != null ? '${v.value}' : '');
    _pointsCtrl = TextEditingController(text: v != null ? '${v.pointsCost}' : '');
    _stockCtrl = TextEditingController(text: v != null ? '${v.stock}' : '');
    _minTransCtrl = TextEditingController(text: '0');
    if (v != null) {
      _category = v.category;
      _expiryDate = v.expiryDate;
      _isFeatured = v.isFeatured;
      _isActive = v.isActive;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose(); _merchantCtrl.dispose();
    _valueCtrl.dispose(); _pointsCtrl.dispose(); _stockCtrl.dispose();
    _minTransCtrl.dispose();
    super.dispose();
  }

  Color get _activeColor => _catColors[_category] ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
        ),
        title: Text(_isEdit ? 'Edit Voucher' : 'Buat Voucher Baru',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(_isEdit ? 'Simpan' : 'Terbitkan',
                style: TextStyle(color: _activeColor, fontWeight: FontWeight.w700)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade100),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Preview Card ─────────────────────────────
            _PreviewCard(
              name: _nameCtrl.text.isEmpty ? 'Nama Voucher' : _nameCtrl.text,
              merchant: _merchantCtrl.text.isEmpty ? 'Merchant' : _merchantCtrl.text,
              value: int.tryParse(_valueCtrl.text) ?? 0,
              points: int.tryParse(_pointsCtrl.text) ?? 0,
              category: _category,
              catColor: _activeColor,
              isFeatured: _isFeatured,
              expiryDate: _expiryDate,
            ),
            const SizedBox(height: 20),

            // ── Informasi Voucher ─────────────────────────
            _SectionHeader('Informasi Voucher', Icons.info_outline_rounded),
            const SizedBox(height: 12),
            _buildCard([
              _ValidatedField(
                label: 'Nama Voucher *',
                hint: 'Contoh: Kopi Gratis Janji Jiwa',
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              _ValidatedField(
                label: 'Merchant / Partner *',
                hint: 'Contoh: Janji Jiwa, Indomaret',
                controller: _merchantCtrl,
                onChanged: (_) => setState(() {}),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deskripsi',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Jelaskan kegunaan dan syarat voucher ini...',
                      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 16),

            // ── Kategori ──────────────────────────────────
            _SectionHeader('Kategori Voucher', Icons.category_rounded),
            const SizedBox(height: 12),
            _buildCard([
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: VoucherCategory.values.map((cat) {
                  final selected = _category == cat;
                  final color = _catColors[cat] ?? AppColors.primary;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? color.withOpacity(0.12) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: selected ? color : Colors.transparent, width: 1.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(cat.icon, size: 16,
                            color: selected ? color : AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(cat.label,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                color: selected ? color : AppColors.textSecondary)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Nilai & Poin ──────────────────────────────
            _SectionHeader('Nilai & Poin', Icons.stars_rounded),
            const SizedBox(height: 12),
            _buildCard([
              Row(children: [
                Expanded(
                  child: _ValidatedField(
                    label: 'Nilai Voucher (Rp) *',
                    hint: '25000',
                    controller: _valueCtrl,
                    keyboardType: TextInputType.number,
                    prefix: 'Rp',
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v!.isEmpty) return 'Wajib diisi';
                      if (int.tryParse(v) == null) return 'Harus angka';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ValidatedField(
                    label: 'Harga Poin *',
                    hint: '500',
                    controller: _pointsCtrl,
                    keyboardType: TextInputType.number,
                    suffix: 'Poin',
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v!.isEmpty) return 'Wajib diisi';
                      if (int.tryParse(v) == null) return 'Harus angka';
                      if (int.parse(v) <= 0) return 'Harus > 0';
                      return null;
                    },
                  ),
                ),
              ]),
              if (_valueCtrl.text.isNotEmpty && _pointsCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _activeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    Icon(Icons.calculate_rounded, size: 14, color: _activeColor),
                    const SizedBox(width: 8),
                    Text(
                      'Nilai/Poin: ${_pointsCtrl.text.isNotEmpty && int.tryParse(_pointsCtrl.text) != null && int.parse(_pointsCtrl.text) > 0 ? 'Rp ${AppUtils.formatCurrency(((int.tryParse(_valueCtrl.text) ?? 0) / int.parse(_pointsCtrl.text)).round())} / poin' : '-'}',
                      style: TextStyle(fontSize: 12, color: _activeColor, fontWeight: FontWeight.w600),
                    ),
                  ]),
                ),
              ],
            ]),
            const SizedBox(height: 16),

            // ── Stok & Masa Berlaku ───────────────────────
            _SectionHeader('Stok & Masa Berlaku', Icons.inventory_2_outlined),
            const SizedBox(height: 12),
            _buildCard([
              _ValidatedField(
                label: 'Jumlah Stok *',
                hint: '100',
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                suffix: 'lembar',
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v!.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(v) == null) return 'Harus angka';
                  if (int.parse(v) < 0) return 'Tidak boleh negatif';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tanggal Kedaluwarsa *',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.calendar_today_rounded, size: 16, color: _activeColor),
                        const SizedBox(width: 10),
                        Text(
                          AppUtils.formatDate(_expiryDate),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _activeColor),
                        ),
                        const Spacer(),
                        Text(
                          '${_expiryDate.difference(DateTime.now()).inDays} hari lagi',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
                      ]),
                    ),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 16),

            // ── Pengaturan ────────────────────────────────
            _SectionHeader('Pengaturan', Icons.tune_rounded),
            const SizedBox(height: 12),
            _buildCard([
              _ToggleRow(
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFFFB300),
                title: 'Voucher Unggulan',
                subtitle: 'Tampilkan di bagian Featured',
                value: _isFeatured,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const Divider(height: 20),
              _ToggleRow(
                icon: Icons.visibility_rounded,
                iconColor: AppColors.primary,
                title: 'Status Aktif',
                subtitle: 'Voucher dapat dilihat dan ditukar user',
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ]),
            const SizedBox(height: 28),

            // ── Submit Button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(_isEdit ? Icons.save_rounded : Icons.publish_rounded,
                    color: Colors.white),
                label: Text(_isEdit ? 'Simpan Perubahan' : 'Terbitkan Voucher',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _activeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: AppShadows.card,
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: _activeColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final vp = context.read<VoucherProvider>();
    final voucher = VoucherModel(
      id: _isEdit ? widget.editVoucher!.id : 'v_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty
          ? 'Voucher ${_nameCtrl.text.trim()}'
          : _descCtrl.text.trim(),
      merchant: _merchantCtrl.text.trim(),
      pointsCost: int.parse(_pointsCtrl.text),
      stock: int.parse(_stockCtrl.text),
      category: _category,
      expiryDate: _expiryDate,
      value: int.parse(_valueCtrl.text),
      isActive: _isActive,
      isFeatured: _isFeatured,
    );

    if (_isEdit) {
      vp.updateVoucher(voucher);
    } else {
      vp.addVoucher(voucher);
    }

    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isEdit ? 'Voucher berhasil diperbarui!' : 'Voucher berhasil diterbitkan!'),
      backgroundColor: _activeColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 16, color: AppColors.textSecondary),
    const SizedBox(width: 8),
    Text(title,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
  ]);
}

class _ValidatedField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const _ValidatedField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
          prefixText: prefix != null ? '$prefix ' : null,
          suffixText: suffix,
          prefixStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          suffixStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 18),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    ),
    Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    ),
  ]);
}

class _PreviewCard extends StatelessWidget {
  final String name;
  final String merchant;
  final int value;
  final int points;
  final VoucherCategory category;
  final Color catColor;
  final bool isFeatured;
  final DateTime expiryDate;

  const _PreviewCard({
    required this.name,
    required this.merchant,
    required this.value,
    required this.points,
    required this.category,
    required this.catColor,
    required this.isFeatured,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Pratinjau Voucher',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          if (isFeatured)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('⭐ Featured',
                  style: TextStyle(fontSize: 9, color: Color(0xFFE65100), fontWeight: FontWeight.w700)),
            ),
        ]),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              // Left panel
              Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(category.icon, color: catColor, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    value > 0 ? AppUtils.formatCurrency(value) : 'Rp 0',
                    style: TextStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              // Divider
              CustomPaint(painter: _DashPainter(color: Colors.grey.shade200), size: const Size(1, 90)),
              // Right content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(category.label,
                          style: TextStyle(color: catColor, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 5),
                    Text(name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(merchant,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.stars_rounded, size: 13, color: catColor),
                      const SizedBox(width: 4),
                      Text(points > 0 ? '$points Poin' : '0 Poin',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: catColor)),
                      const Spacer(),
                      Text('s/d ${AppUtils.formatDate(expiryDate)}',
                          style: const TextStyle(fontSize: 9, color: AppColors.textHint)),
                    ]),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke;
    const dashH = 5.0; const gapH = 4.0; double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + gapH;
    }
  }
  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}
