import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/mock/mock_data.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String articleId;
  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article = MockData.articles.firstWhere((a) => a.id == articleId,
        orElse: () => MockData.articles.first);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppGradients.primary),
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(height: 40),
                    const Text('🌿', style: TextStyle(fontSize: 72)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
                      child: Text(article.category, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(article.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(article.author, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${article.readMinutes} menit baca', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  Text(AppUtils.formatDate(article.publishedAt), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 16),
                Container(height: 3, width: 40, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryLight.withOpacity(0.3))),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(article.summary,
                        style: const TextStyle(fontSize: 13, color: AppColors.primary, fontStyle: FontStyle.italic, height: 1.5))),
                  ]),
                ),
                const SizedBox(height: 20),
                // Content (rendered as paragraphs)
                ...article.content.split('\n\n').map((paragraph) {
                  if (paragraph.startsWith('**') && paragraph.endsWith('**')) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(paragraph.replaceAll('**', ''),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    );
                  }
                  if (paragraph.startsWith('#')) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Text(paragraph.replaceFirst(RegExp(r'^#+\s'), ''),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(paragraph.trim(),
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.7)),
                  );
                }),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
