import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

// NetworkError - ошибка сети
// WrongData - неверные данные
// OtherError - другие ошибки
// ServerError - ошибка сервера (500)
// TimeoutError - ошибка превышения времени ошидания ответа сервера

enum HttpClientExceptionType {
  NetworkError,
  WrongData,
  OtherError,
  ServerError,
  TimeoutError
}

class HttpClientException implements Exception {
  final HttpClientExceptionType type;

  HttpClientException(this.type);
}

// стандартная библиотека для отправки запросов HttpClient()
final httpClient =
    HttpClient();

// Метод api запроса
Future<T> functionRequest<T>({
  required String method,
  required Map<String, dynamic> params,
  required T Function(dynamic json) parser,
  String? access,
}) async {
  try {
    final request = await httpClient.postUrl(ApiConstants.url);
    request.headers.set('Content-type', 'application/json; charset=utf-8');
    if (access != null){
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
    print('Запрос $method успешно отправлен');
    if (response.statusCode == 200) {
      final dynamic json = (await response.jsonDecode());
      final result = parser(json);
      return result;
    } else if (response.statusCode == 500) {
      print(method);
      print('Сервер недоступен!');
      print('Сервер недоступен!');
      throw HttpClientException(HttpClientExceptionType.ServerError);
    } else {
      print(method);
      print('Неверные данные запроса');
      print('Произошла ошибка, попробуйте еще раз');
      throw HttpClientException(HttpClientExceptionType.WrongData);
    }
  } on TimeoutException {
    print(method);
    print('Истекло время ожидания!');
    print('Истекло время ожидания!');
    throw HttpClientException(HttpClientExceptionType.TimeoutError);
  } on SocketException {
    print(method);
    print('Отсутствует подключение к сети');
    print('Отсутствует подключение к сети');
    throw HttpClientException(HttpClientExceptionType.NetworkError);
  } on HttpClientException {
    rethrow;
  } catch (_) {
    print(method);
    print('Неизвестная ошибка сервера!');
    print('Произошла ошибка, попробуйте еще раз');
    throw HttpClientException(HttpClientExceptionType.OtherError);
  }
}
