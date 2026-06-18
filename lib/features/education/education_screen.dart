import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/mock/mock_data.dart';
import '../../shared/widgets/app_widgets.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = MockData.articles;
    final featured = articles.where((a) => a.isFeatured).toList();
    final rest = articles.where((a) => !a.isFeatured).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('📚', style: TextStyle(fontSize: 28)),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Edukasi Lingkungan',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                              Text('Belajar lebih banyak tentang lingkungan',
                                  style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.3))),
                        child: const Row(children: [
                          Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                          SizedBox(width: 10),
                          Text('Cari artikel...', style: TextStyle(color: Colors.white60, fontSize: 14)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Featured
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: '🌟 Artikel Pilihan'),
                  const SizedBox(height: 14),
                  ...featured.map((a) => GestureDetector(
                    onTap: () => context.go('/education/article/${a.id}'),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        boxShadow: AppShadows.button,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                                    child: Text(a.category, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(a.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, height: 1.3)),
                                  const SizedBox(height: 6),
                                  Text(a.summary, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    const Icon(Icons.access_time_rounded, color: Colors.white60, size: 13),
                                    const SizedBox(width: 4),
                                    Text('${a.readMinutes} menit baca', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                                    const SizedBox(width: 12),
                                    Text('• ${AppUtils.formatDate(a.publishedAt)}', style: const TextStyle(color: Colors.white60, fontSize: 11)),
                                  ]),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('🌿', style: TextStyle(fontSize: 50)),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),

          // More articles
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Artikel Lainnya'),
                  const SizedBox(height: 14),
                  ...rest.map((a) => GestureDetector(
                    onTap: () => context.go('/education/article/${a.id}'),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: AppShadows.card),
                      child: Row(
                        children: [
                          Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              image: a.imageUrl != null 
                                  ? DecorationImage(
                                      image: AssetImage(a.imageUrl!),
                                      fit: BoxFit.cover,
                                    ) 
                                  : null,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: a.imageUrl == null
                                ? const Center(child: Icon(Icons.article_rounded, size: 28, color: AppColors.primary))
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(a.category, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(a.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('${a.readMinutes} menit • ${AppUtils.formatDate(a.publishedAt)}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                          ])),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
