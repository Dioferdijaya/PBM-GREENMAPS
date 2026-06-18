import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/waste_type_model.dart';
import '../../data/models/waste_bank_model.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/green_button.dart';
import '../../shared/widgets/green_text_field.dart';

class CreateDepositScreen extends StatefulWidget {
  const CreateDepositScreen({super.key});

  @override
  State<CreateDepositScreen> createState() => _CreateDepositScreenState();
}

class _CreateDepositScreenState extends State<CreateDepositScreen> {
  WasteTypeModel? _selectedWasteType;
  WasteBankModel? _selectedBank;
  final _weightCtrl = TextEditingController();
  String? _photoPath;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _photoPath = picked.path);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWasteType == null) {
      _showError('Pilih jenis sampah terlebih dahulu');
      return;
    }
    if (_selectedBank == null) {
      _showError('Pilih bank sampah tujuan');
      return;
    }
    final user = context.read<AuthProvider>().currentUser!;
    final success = await context.read<DepositProvider>().createDeposit(
          userId: user.id,
          wasteBank: _selectedBank!,
          wasteType: _selectedWasteType!,
          estimatedWeight: double.parse(_weightCtrl.text),
          photoUrl: _photoPath,
        );
    if (!mounted) return;
    if (success) {
      _showSuccess();
      context.go('/deposit');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Permintaan setor berhasil dikirim!'),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final depositing = context.watch<DepositProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Buat Permintaan Setor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              _buildStepRow(),
              const SizedBox(height: 24),

              // Waste type selection
              const Text('Jenis Sampah',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MockData.wasteTypes.map((wt) {
                  final isSelected = _selectedWasteType?.id == wt.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedWasteType = wt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        boxShadow: isSelected ? AppShadows.button : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(wt.icon, size: 16, color: isSelected ? Colors.white : AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${wt.name} • ${wt.pointsPerKg.toInt()} poin/kg',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Bank selection
              const Text('Bank Sampah Tujuan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...MockData.wasteBanks.take(4).map((bank) {
                final isSelected = _selectedBank?.id == bank.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedBank = bank),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primarySurface
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_rounded, size: 24, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(bank.name,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Text(bank.openHours,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Weight
              const Text('Estimasi Berat (Kg)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              GreenTextField(
                label: 'Estimasi berat',
                hint: 'Contoh: 2.5',
                controller: _weightCtrl,
                prefixIcon: Icons.scale_rounded,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Berat wajib diisi';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Masukkan berat yang valid';
                  return null;
                },
              ),

              // Estimated points preview
              if (_selectedWasteType != null && _weightCtrl.text.isNotEmpty)
                Builder(builder: (_) {
                  final w = double.tryParse(_weightCtrl.text) ?? 0;
                  final pts =
                      (w * _selectedWasteType!.pointsPerKg).toInt();
                  return Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primaryLight.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded,
                            color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          'Estimasi poin: ~$pts poin',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 24),

              // Photo
              const Text('Foto Sampah',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickPhoto,
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.primaryLight.withOpacity(0.4),
                        style: BorderStyle.solid),
                  ),
                  child: _photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: const Center(
                            child: Icon(Icons.check_circle_rounded,
                                color: AppColors.success, size: 48),
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                color: AppColors.primary, size: 40),
                            SizedBox(height: 8),
                            Text('Ambil foto sampah (opsional)',
                                style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
              GreenButton(
                label: 'Kirim Permintaan Setor',
                onPressed: _submit,
                isLoading: depositing,
                width: double.infinity,
                icon: Icons.send_rounded,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primarySurface, Color(0xFFE0F2F1)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          _StepDot(number: '1', label: 'Pilih Jenis', done: false),
          _StepLine(),
          _StepDot(number: '2', label: 'Pilih Bank', done: false),
          _StepLine(),
          _StepDot(number: '3', label: 'Detail', done: false),
          _StepLine(),
          _StepDot(number: '4', label: 'Kirim', done: false),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String number;
  final String label;
  final bool done;
  const _StepDot({required this.number, required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: done ? AppColors.primary : AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: AppColors.primaryLight.withOpacity(0.4),
      ),
    );
  }
}
