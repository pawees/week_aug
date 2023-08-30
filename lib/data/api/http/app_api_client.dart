import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:clean_architecture_my_project/data/api/models/promo_responce.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:clean_architecture_my_project/data/api/models/news_response.dart';
import 'package:clean_architecture_my_project/data/repositories/news_repository/models/news_model.dart';
import 'package:clean_architecture_my_project/data/repositories/promo_repository/models/promo_model.dart';

import '../api_interface.dart';


class AppApiRequestFailure implements Exception {
  const AppApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

typedef TokenProvider = Future<String?>;

class AppApiClient implements ApiInterface {
  AppApiClient._({
    required String url,
    required TokenProvider tokenProvider,
    var httpClient,
  })  : _url = url,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  final String _url;
  final _httpClient;
  final TokenProvider _tokenProvider;


  AppApiClient.doctorLight({
    required TokenProvider tokenProvider,
    var httpClient,
  }) : this._(
          url: 'https://doctor43.ru/api/v2/',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );

  AppApiClient.jsonPlaceholder({
    required TokenProvider tokenProvider,
    var httpClient,
  }) : this._(
          url: 'https://jsonplaceholder.typicode.com/',
          httpClient: httpClient,
          tokenProvider: tokenProvider,
        );
  @override
  Future<List<NewsModel>> getNews({
    int? count,
    int? offset,
    int? cityId,
  }) async {
    final uri = Uri.parse('$_url');
    final response = await _httpClient.post(uri,
        headers: await _getRequestHeaders(),
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'get_news',
          'params': {
            "offset": offset,
            "count": count,
            "city_id": cityId,
          },
          'id': Uuid().v4(),
        }));

    if (response.statusCode != HttpStatus.ok) {
      throw AppApiRequestFailure(
        body: {},
        statusCode: response.statusCode,
      );
    }
    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));
    List<dynamic> data = map['result'];

    return NewsResponse.fromJson(data);
  }

  @override
  Future<List<PromoModel>> getPromo({
    int? count,
    int? offset,
    int? cityId,
  }) async {
    final uri = Uri.parse('$_url');
    final response = await _httpClient.post(uri,
        headers: await _getRequestHeaders(),
        body: jsonEncode({
          'jsonrpc': '2.0',
          'method': 'get_promo',
          'params': {
            "offset": offset,
            "count": count,
            "city_id": cityId,
          },
          'id': Uuid().v4(),
        }));

    if (response.statusCode != HttpStatus.ok) {
      throw AppApiRequestFailure(
        body: {},
        statusCode: response.statusCode,
      );
    }

    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));
    List<dynamic> data = map['result'];

    return PromoResponse.fromJson(data);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = null;
    return {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }
}
