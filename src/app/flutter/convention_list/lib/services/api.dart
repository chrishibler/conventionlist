import 'package:convention_list/api_info.dart';
import 'package:dio/dio.dart';

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
}
