import 'package:flutter/material.dart';
import 'package:news_c20_online/core/theme/app_colors.dart';
import 'package:news_c20_online/modules/layout/view/widegts/article_widget.dart';
import 'package:news_c20_online/modules/search/manager/search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: AppBar(
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildSearchField(provider),
                    SizedBox(height: 16),
                    Expanded(child: buildBody(provider)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget buildSearchField(SearchProvider provider) {
    return TextField(
      controller: provider.searchController,
      style: TextStyle(color: AppColors.white),
      cursorColor: AppColors.white,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        provider.search();
      },
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(color: AppColors.white),
        prefixIcon: Icon(Icons.search, color: AppColors.white),
        suffixIcon: IconButton(
          onPressed: () {
            provider.clear();
          },
          icon: Icon(Icons.close, color: AppColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.white),
        ),
      ),
    );
  }

  Widget buildBody(SearchProvider provider) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.white));
    }

    if (provider.errorMessage != null) {
      return buildMessage(Icons.wifi_off, provider.errorMessage!);
    }

    if (!provider.hasSearched) {
      return buildMessage(Icons.search, "Search for any news topic");
    }

    if (provider.articles.isEmpty) {
      return buildMessage(Icons.search_off, "No articles found");
    }

    return SingleChildScrollView(
      child: Column(
        children: provider.articles.map((article) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ArticleWidget(article: article),
          );
        }).toList(),
      ),
    );
  }

  Widget buildMessage(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 48),
          SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
