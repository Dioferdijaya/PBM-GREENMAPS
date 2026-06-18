import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/waste_bank_model.dart';
import '../../providers/waste_bank_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  WasteBankModel? _selectedBank;
  double _radius = 5.0;

  @override
  Widget build(BuildContext context) {
    final banks = context.watch<WasteBankProvider>().banks;

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ─────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
              initialZoom: AppConstants.defaultZoom,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.greenmap.app',
              ),
              // Radius circle
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(
                        AppConstants.defaultLat, AppConstants.defaultLng),
                    radius: _radius * 1000,
                    useRadiusInMeter: true,
                    color: AppColors.primary.withOpacity(0.1),
                    borderColor: AppColors.primary.withOpacity(0.4),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              // Bank markers
              MarkerLayer(
                markers: [
                  // User location
                  Marker(
                    point: const LatLng(
                        AppConstants.defaultLat, AppConstants.defaultLng),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.info.withOpacity(0.4),
                              blurRadius: 8)
                        ],
                      ),
                    ),
                  ),
                  ...banks.map((bank) => Marker(
                    point: LatLng(bank.lat, bank.lng),
                    width: 48,
                    height: 56,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedBank = bank);
                        context
                            .read<WasteBankProvider>()
                            .selectBank(bank);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedBank?.id == bank.id
                                  ? AppColors.primary
                                  : bank.isOpen
                                      ? Colors.white
                                      : Colors.grey.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                              boxShadow: AppShadows.elevated,
                            ),
                            child: Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 18),
                          ),
                          Container(
                            width: 6,
                            height: 8,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),

          // ── Top Bar ──────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.elevated,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cari bank sampah...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textHint),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.tune_rounded,
                              color: AppColors.primary, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Radius slider
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.card,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.radar_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Radius: ${_radius.toInt()} km',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                        Expanded(
                          child: Slider(
                            value: _radius,
                            min: 1,
                            max: 20,
                            divisions: 19,
                            activeColor: AppColors.primary,
                            onChanged: (v) => setState(() => _radius = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bank Count chip ───────────────────────────────
          Positioned(
            top: 0,
            right: 16,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 130),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: AppShadows.button,
                  ),
                  child: Text(
                    '${banks.length} Bank',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),

          // ── Selected bank bottom sheet ────────────────────
          if (_selectedBank != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBankCard(context, _selectedBank!),
            ),

          // ── No selection: bank list ───────────────────────
          if (_selectedBank == null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBankList(context, banks),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          _mapController.move(
            const LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
            AppConstants.defaultZoom,
          );
        },
        child: const Icon(Icons.my_location_rounded),
      ),
    );
  }

  Widget _buildBankList(BuildContext context, List<WasteBankModel> banks) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: AppShadows.elevated,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text('Bank Sampah di Sekitar',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${banks.length} Lokasi',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              itemCount: banks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final bank = banks[i];
                return GestureDetector(
                  onTap: () => setState(() => _selectedBank = bank),
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: bank.isOpen
                                      ? AppColors.success.withOpacity(0.15)
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                bank.isOpen ? 'Buka' : 'Tutup',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: bank.isOpen
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(bank.name,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(bank.openHours,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCard(BuildContext context, WasteBankModel bank) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: AppShadows.elevated,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                    child: Icon(Icons.account_balance_rounded, size: 28, color: AppColors.primary)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(bank.address,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedBank = null),
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textHint, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.access_time_rounded, bank.openHours),
              const SizedBox(width: 8),
              _infoChip(Icons.phone_outlined, bank.phone),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: bank.isOpen
                      ? AppColors.success.withOpacity(0.1)
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(bank.isOpen ? '● Buka' : '● Tutup',
                    style: TextStyle(
                        fontSize: 11,
                        color:
                            bank.isOpen ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/map/bank/${bank.id}'),
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: const Text('Detail'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/deposit/create'),
                  icon: const Icon(Icons.recycling_rounded, size: 18),
                  label: const Text('Setor Sampah'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
