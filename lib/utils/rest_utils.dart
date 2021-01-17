import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class RestUtils {
  static Map<String, String> authenticationHeader(
      {String username, String password}) {
    Map<String, String> headers = new Map();
    String auth =
        Base64Encoder().convert(Utf8Encoder().convert('$username:$password'));
    headers[HttpHeaders.authorizationHeader] = 'Basic $auth';
    return headers;
  }

  static Future<Dio> dioClient(
      {String username,
      String password,
      bool withResponseInterceptor = true,
      BaseOptions baseOptions}) async {
    Dio dioClient = new Dio(baseOptions);
//    Map headers = await customHeaders();
    dioClient.options.headers
        .addAll(authenticationHeader(username: 'datadrive', password: '!datadrive\$'));
    dioClient.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) {
//      options.headers.addAll(headers);
      return options;
    }, onResponse: (Response response) {
//      EntityLog.request(response);
//      EntityLog.response(response);
      return response;
    }, onError: (DioError dioError) async {
//      EntityLog.request(dioError.response);
//      EntityLog.response(dioError.response);
      return dioError;
    }));
    return dioClient;
  }
}
