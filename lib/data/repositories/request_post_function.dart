import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../api_constants.dart';

//todo переписать клиента
extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((v) => json.decode(v));
  }
}

class AppApiRequestFailure implements Exception {
  /// {@macro dailyer_api_request_failure}
  const AppApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

//typedef TokenProvider = Future<String?> Function();

class AppApiClient {
  AppApiClient._({
    required String url,
    required TokenProvider tokenProvider,
    var httpClient,
  })
      : _url = url,
        _httpClient = httpClient ?? http.Client(),
        _tokenProvider = tokenProvider;

  final String _url;
  final  _httpClient;
  final TokenProvider _tokenProvider;

  AppApiClient.mockable({
    required TokenProvider tokenProvider,
    var httpClient,
  }) : this._(
    url: '',
    httpClient: httpClient,
    tokenProvider: tokenProvider,
  );

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
    //todo добавить специфику запроса в переменную
  );

  Future<T> functionRequest<T>({
    required String method,
    required Map<String, dynamic> params,
    required T Function(dynamic json) parser,
    String? access,
  }) async {

      final request = await _httpClient.postUrl(ApiConstants.url);
      request.headers.set('Content-type', 'application/json; charset=utf-8');
      if (access != null) {
        request.headers.set('Authorization', 'Bearer $access');
      }
      request.write(
        jsonEncode(<String, dynamic>{
          "jsonrpc": "2.0",
          "method": method,
          "params": params,
          "id": Uuid().v4(),
        }),
      );
      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      final body = response.json();

      print('Запрос $method успешно отправлен');
        if (response.statusCode != HttpStatus.ok) {
          throw AppApiRequestFailure(
            body: body,
            statusCode: response.statusCode,
          );
        }
      final result = parser(json);
      return result;
  //необходимый прототип
  // Future<int> getNews<T>({
  //   required String id,
  //   int? count,
  //   int? offset,
  //   int? cityId,
  // }) async {
  //   final uri = Uri.parse('$_url');
  //   final response = await _httpClient.post(
  //     uri,
  //     headers: await _getRequestHeaders(),
  //     body: jsonEncode({
  //       'jsonrpc':'2.0',
  //       'method': 'get_news',
  //       'params': { "offset": offset,
  //         "count": count,
  //         "city_id": cityId,},
  //       'id': Uuid().v4(),
  //     })
  //   );
  //   final body = response.body;
  //
  //   if (response.statusCode != HttpStatus.ok) {
  //     throw AppApiRequestFailure(
  //       body: {},
  //       statusCode: response.statusCode,
  //     );
  //   }
  //
  //   return 0;//NewsResponse.fromJson(body);
  // }

  Future<Map<String, String>> _getRequestHeaders() async {
    final token = await _tokenProvider();
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

}

