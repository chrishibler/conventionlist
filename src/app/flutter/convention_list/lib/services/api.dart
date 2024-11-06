import 'package:convention_list/api_info.dart';
import 'package:convention_list/models/new_convention.dart';
import 'package:convention_list/services/auth_service.dart';
import 'package:dio/dio.dart';

import '../models/convention.dart';
import '../models/position.dart';
import '../models/response_page.dart';
import '../models/search_params.dart';

class Api {
  static final Dio dio = Dio();

  Future<ResponsePage> getConventions({
    required OrderBy orderBy,
    required int pageKey,
    String? search,
    Position? position,
  }) async {
    final String url =
        '$apiBaseUrl/conventions?page=$pageKey${SearchParams(orderBy: orderBy, search: search, position: position).toQueryString()}';
    var response = await dio.get(url);
    ResponsePage page = ResponsePage.fromJson(response.data);
    return page;
  }

  Future<void> postConvention(NewConvention newConvention) async {
    if (AuthService.credentials == null) {
      throw Exception('No credentials found');
    }
    String accessToken = AuthService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    var response = await dio.post(
      '$apiBaseUrl/conventions',
      data: newConvention.toJson(),
      options: options,
    );
    print(response);
  }

  Future<ResponsePage> getUserConventions({required int pageKey}) async {
    final String url = '$apiBaseUrl/user/conventions?page=$pageKey';
    String accessToken = AuthService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    var response = await dio.get(
      url,
      options: options,
    );
    ResponsePage page = ResponsePage.fromJson(response.data);
    return page;
  }

  Future<void> deleteConvention(Convention convention) async {
    final String url = '$apiBaseUrl/conventions/${convention.id}';
    String accessToken = AuthService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    await dio.delete(
      url,
      options: options,
    );
  }

  Future<void> putConvention(Convention convention) async {
    final String url = '$apiBaseUrl/conventions/${convention.id}';
    String accessToken = AuthService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    await dio.put(
      url,
      options: options,
      data: convention.toJson(),
    );
  }
}
