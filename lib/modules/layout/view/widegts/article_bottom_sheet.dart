import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c20_online/core/theme/app_colors.dart';
import 'package:news_c20_online/modules/layout/data/models/news_response.dart';
import 'package:url_launcher/url_launcher.dart';

void showArticleBottomSheet(BuildContext context, Articles article) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return ArticleBottomSheet(article: article);
    },
  );
}

class ArticleBottomSheet extends StatelessWidget {
  final Articles article;
  const ArticleBottomSheet({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(),
            SizedBox(height: 16),
            Text(
              article.title ?? "",
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Text(
              getDescription(),
              style: TextStyle(color: AppColors.black, fontSize: 14),
            ),
            SizedBox(height: 24),
            buildViewButton(context),
          ],
        ),
      ),
    );
  }


  String getDescription() {
    if (article.description != null && article.description!.isNotEmpty) {
      return article.description!;
    }
    if (article.content != null && article.content!.isNotEmpty) {
      return article.content!;
    }
    return "No description available";
  }

  Widget buildImage() {
    String url = article.urlToImage ?? "";
    if (url.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey.shade300,
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

  Widget buildViewButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          openArticle(context);
        },
        child: Text("View Full Article"),
      ),
    );
  }

  Future<void> openArticle(BuildContext context) async {
    String url = article.url ?? "";
    bool opened = false;

    if (url.isNotEmpty) {
      try {
        opened = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        opened = false;
      }
    }

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the article link")),
      );
    }
  }
}
