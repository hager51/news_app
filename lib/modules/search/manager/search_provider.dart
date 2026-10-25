import 'package:flutter/material.dart';
import 'package:news_c20_online/modules/layout/data/models/news_response.dart';
import 'package:news_c20_online/modules/layout/data/repo/repo.dart';

class SearchProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  Repo repo = RepoImp();

  List<Articles> articles = [];
  bool isLoading = false;
  bool hasSearched = false;
  String? errorMessage;

  Future<void> search() async {
    String query = searchController.text.trim();
    if (query.isEmpty) return;

    isLoading = true;
    hasSearched = true;
    errorMessage = null;
    articles = [];
    notifyListeners();

    try {
      articles = await repo.searchNews(query);
    } catch (e) {
      errorMessage = "Something went wrong, check your internet and try again";
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    searchController.clear();
    articles = [];
    hasSearched = false;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
