import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/mock/mock_data.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final board = MockData.leaderboard;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: '🎓 Kampus'), Tab(text: '🏙️ Kota'), Tab(text: '🌏 Nasional')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: List.generate(3, (_) => _LeaderboardList(entries: board)),
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List entries;
  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    final currentUserId = MockData.currentUser.id;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Podium
          _buildPodium(entries.take(3).toList()),
          const SizedBox(height: 16),
          // Ranked list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: entries.length > 3 ? entries.length - 3 : 0,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final entry = entries[i + 3];
              final isMe = entry.userId == currentUserId;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.primarySurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppShadows.card,
                  border: isMe ? Border.all(color: AppColors.primaryLight.withOpacity(0.4)) : null,
                ),
                child: Row(children: [
                  SizedBox(width: 36, child: Text('#${entry.rank}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
                      color: isMe ? AppColors.primary : AppColors.textSecondary))),
                  CircleAvatar(radius: 20, backgroundColor: AppColors.primarySurface,
                      child: Text(entry.userName.substring(0, 1), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${entry.userName}${isMe ? ' (Kamu)' : ''}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isMe ? AppColors.primary : null)),
                    Text(entry.institution ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${AppUtils.formatPoints(entry.totalPoints)} poin',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    Text('${entry.totalWasteKg} Kg', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ]),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPodium(List top) {
    if (top.length < 3) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.button,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _PodiumEntry(entry: top[1], height: 80, medal: '🥈', rank: '2'),
          _PodiumEntry(entry: top[0], height: 110, medal: '🥇', rank: '1'),
          _PodiumEntry(entry: top[2], height: 65, medal: '🥉', rank: '3'),
        ],
      ),
    );
  }
}

class _PodiumEntry extends StatelessWidget {
  final entry;
  final double height;
  final String medal, rank;
  const _PodiumEntry({required this.entry, required this.height, required this.medal, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isFirst = rank == '1';
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(medal, style: TextStyle(fontSize: isFirst ? 32 : 24)),
        const SizedBox(height: 6),
        CircleAvatar(
          radius: isFirst ? 28 : 22,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Text(entry.userName.substring(0, 1),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: isFirst ? 20 : 16)),
        ),
        const SizedBox(height: 6),
        Text(entry.userName.split(' ').first,
            style: TextStyle(color: Colors.white, fontSize: isFirst ? 12 : 10, fontWeight: FontWeight.w700)),
        Text('${AppUtils.formatPoints(entry.totalPoints)} pts',
            style: const TextStyle(color: Colors.white70, fontSize: 10)),
        const SizedBox(height: 8),
        Container(
          width: isFirst ? 80 : 66,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isFirst ? 0.25 : 0.15),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          alignment: Alignment.center,
          child: Text(rank, style: TextStyle(color: Colors.white70, fontSize: isFirst ? 22 : 18, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
