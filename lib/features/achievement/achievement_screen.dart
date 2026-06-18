import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/achievement_model.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = MockData.achievements;
    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Achievement & Badge')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Progress header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF7B1FA2).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.emoji_events_rounded, size: 36, color: Colors.white),
                    const SizedBox(width: 14),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Progress Badge', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('${unlocked.length} / ${achievements.length} Diperoleh',
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    percent: unlocked.length / achievements.length,
                    lineHeight: 12,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    progressColor: Colors.white,
                    barRadius: const Radius.circular(50),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text('${(unlocked.length / achievements.length * 100).toInt()}% selesai',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const Spacer(),
                    Text('${achievements.length - unlocked.length} badge tersisa',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ],
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _StatCard('${user.depositCount}', 'Total\nSetoran', Icons.recycling_rounded),
                const SizedBox(width: 12),
                _StatCard('${user.totalWasteKg.toStringAsFixed(1)} Kg', 'Sampah\nTerkumpul', Icons.eco_rounded),
                const SizedBox(width: 12),
                _StatCard('${user.totalPoints}', 'Total\nPoin', Icons.stars_rounded),
              ]),
            ),

            // Unlocked badges
            if (unlocked.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
                child: Align(alignment: Alignment.centerLeft,
                    child: Text('✅ Badge Diperoleh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
                itemCount: unlocked.length,
                itemBuilder: (_, i) => _BadgeCard(achievement: unlocked[i], isUnlocked: true),
              ),
            ],

            // Locked badges
            if (locked.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
                child: Align(alignment: Alignment.centerLeft,
                    child: Text('🔒 Badge Belum Diperoleh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
                itemCount: locked.length,
                itemBuilder: (_, i) => _BadgeCard(achievement: locked[i], isUnlocked: false),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _StatCard(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
        child: Column(children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary), textAlign: TextAlign.center),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final AchievementModel achievement;
  final bool isUnlocked;
  const _BadgeCard({required this.achievement, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnlocked ? AppColors.primaryLight.withOpacity(0.3) : Colors.grey.shade200),
        boxShadow: isUnlocked ? AppShadows.card : null,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(achievement.icon,
                size: 36, color: isUnlocked ? AppColors.primary : Colors.grey.shade400),
            if (!isUnlocked)
              Positioned(bottom: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                    child: const Icon(Icons.lock_rounded, size: 10, color: Colors.white),
                  )),
          ],
        ),
        const SizedBox(height: 8),
        Text(achievement.name,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                color: isUnlocked ? AppColors.textPrimary : AppColors.textHint),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(achievement.description,
            style: TextStyle(fontSize: 9, color: isUnlocked ? AppColors.textSecondary : AppColors.textHint),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
