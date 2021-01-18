import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:obd/utils/rest_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OBDRestService {
  static OBDRestService _instance;

  factory OBDRestService(context) => _instance ?? OBDRestService.internal();

  OBDRestService.internal();

  static const BASE_URL = "http://192.168.1.1/";

  static const URL_CONFIGURATION = "api/configuration";

  Future<dynamic> configuration(String hostname, String publicKey) async {

    String baseUrl = 'http://$hostname/';
    Dio dio = await RestUtils.dioClient(withResponseInterceptor: false);
    try {
      dio.options.baseUrl = baseUrl;
      dio.options.contentType =
          ContentType.parse("application/json").toString();
      dio.options.responseType = ResponseType.json;
      Response response =
          await dio.post(URL_CONFIGURATION, data: {"publicKey": publicKey});
      dynamic data = response.data;
      return data;
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }
}
