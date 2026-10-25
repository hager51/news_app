import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../manager/layout_provider.dart';
import '../widegts/article_widget.dart';


class ArticlesScreen extends StatelessWidget {
  ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            DefaultTabController(
              length: provider.sources.length,
              child: TabBar(
                onTap: (value) {
                  provider.onChangeSource(provider.sources[value]);
                },
                dividerColor: Colors.transparent,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: AppColors.white,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.white,
                tabs: provider.sources.map((e) {
                  return Tab(text: e.name ?? "");
                }).toList(),
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return ArticleWidget(article: provider.articles[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: provider.articles.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
