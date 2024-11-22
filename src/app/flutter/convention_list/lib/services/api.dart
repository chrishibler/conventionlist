import 'package:convention_list/api_info.dart';
import 'package:convention_list/models/new_convention.dart';
import 'package:convention_list/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/bounds.dart';
import '../models/convention.dart';
import '../models/position.dart';
import '../models/response_page.dart';
import '../models/search_params.dart';

@lazySingleton
class Api {
  final Dio dio;
  final AuthService authService;

  Api({required this.authService, required this.dio});

  Future<ResponsePage> getConventions({
    required OrderBy orderBy,
    required int pageKey,
    String? search,
    Position? position,
    bool? approved,
  }) async {
    final String url = '$apiBaseUrl/conventions?page=$pageKey${SearchParams(
      orderBy: orderBy,
      search: search,
      position: position,
      approved: approved,
    ).toQueryString()}';
    var response = await dio.get(url);
    ResponsePage page = ResponsePage.fromJson(response.data);
    return page;
  }

  Future<Convention> getConvention({required String id}) async {
    final String url = '/conventions/$id';
    var response = await dio.get(url);
    Convention convention = Convention.fromJson(response.data);
    return convention;
  }

  Future<void> postConvention(NewConvention newConvention) async {
    if (authService.credentials == null) {
      throw Exception('No credentials found');
    }
    String accessToken = authService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    await dio.post(
      '/conventions',
      data: newConvention.toJson(),
      options: options,
    );
  }

  Future<ResponsePage> getUserConventions({
    required int pageKey,
    String? search,
  }) async {
    final String url = '/user/conventions?page=$pageKey${SearchParams(search: search).toQueryString()}';
    String accessToken = authService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    var response = await dio.get(
      url,
      options: options,
    );
    ResponsePage page = ResponsePage.fromJson(response.data);
    return page;
  }

  Future<List<Convention>> getAllConventionsByBounds({required Bounds bounds}) async {
    bool hasMore = true;
    int pageKey = 1;
    List<Convention> conventions = [];
    while (hasMore) {
      final String url =
          '/conventions/bounds?north=${bounds.north}&east=${bounds.east}&south=${bounds.south}&west=${bounds.west}&page=$pageKey';
      var response = await dio.get(url);
      ResponsePage page = ResponsePage.fromJson(response.data);
      conventions.addAll(page.conventions);
      hasMore = pageKey < page.totalPages;
      pageKey++;
    }
    return conventions;
  }

  Future<ResponsePage> getConventionsByBounds({
    required int pageKey,
    required Bounds bounds,
  }) async {
    final String url =
        '/conventions/bounds?north=${bounds.north}&east=${bounds.east}&south=${bounds.south}&west=${bounds.west}&page=$pageKey';
    var response = await dio.get(url);
    ResponsePage page = ResponsePage.fromJson(response.data);
    return page;
  }

  Future<void> deleteConvention(Convention convention) async {
    final String url = '/conventions/${convention.id}';
    String accessToken = authService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    await dio.delete(
      url,
      options: options,
    );
  }

  Future<void> putConvention(Convention convention) async {
    final String url = '/conventions/${convention.id}';
    String accessToken = authService.credentials!.accessToken;
    Options options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    await dio.put(
      url,
      options: options,
      data: convention.toJson(),
    );
  }
}
