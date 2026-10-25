import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c20_online/core/theme/app_colors.dart';
import 'package:news_c20_online/modules/layout/data/models/news_response.dart';
import 'package:news_c20_online/modules/layout/view/widegts/article_bottom_sheet.dart';

class ArticleWidget extends StatelessWidget {
  final Articles article;
  const ArticleWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showArticleBottomSheet(context, article);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(),
            SizedBox(height: 12),
            Text(
              article.title ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "By : ${article.author ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Text(
                  getTimeAgo(article.publishedAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget buildImage() {
    String url = article.urlToImage ?? "";
    if (url.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey.shade800,
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => SizedBox(
          height: 150,
          child: Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }

  String getTimeAgo(String? publishedAt) {
    if (publishedAt == null) return "";
    DateTime? date = DateTime.tryParse(publishedAt);
    if (date == null) return "";

    Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }
}
