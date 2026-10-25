import 'package:dio/dio.dart';

import '../../../../core/services/api_service.dart';

abstract class RemoteDataSource {
  Future<Response> getNews(String sourceId);

  Future<Response> getSources(String categoryId);

  Future<Response> searchNews(String query);
}


class RemoteDataSourceImp extends RemoteDataSource{

  @override
  Future<Response<dynamic>> getNews(String sourceId) {
    return ApiService.dio.get("everything?sources=$sourceId");
  }

  @override
  Future<Response<dynamic>> getSources(String categoryId) {
    return ApiService.dio.get("top-headlines/sources",queryParameters: {
      "category":categoryId
    });
  }

  @override
  Future<Response<dynamic>> searchNews(String query) {
    return ApiService.dio.get("everything", queryParameters: {
      "q": query,
    });
  }

}
