import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:obd/utils/rest_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatadriveRestService {

  static DatadriveRestService _instance;

  factory DatadriveRestService(context) =>
      _instance ?? DatadriveRestService.internal();

  DatadriveRestService.internal();

  static const BASE_URL = "https://datadrivemvp.herokuapp.com/";

  static const URL_REGISTER = "api/v1/register";
  static const URL_TRANSACTION = "api/v1/transaction";
  static const URL_OUTPUT = "api/v1/output?publicKey=";


  Future<Map> register() async {
    Dio dio = await RestUtils.dioClient(withResponseInterceptor: false);
    try {
      dio.options.baseUrl = BASE_URL;
      dio.options.contentType =
          ContentType.parse("application/json").toString();
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(URL_REGISTER);
      dynamic data = response.data;
      return data;
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> output() async {
    Dio dio = await RestUtils.dioClient(withResponseInterceptor: false);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString('publicKey');

    try {
      dio.options.baseUrl = BASE_URL;
      dio.options.contentType =
          ContentType.parse("application/json").toString();
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(URL_OUTPUT+publicKey);
      dynamic data = response.data;
      return data;
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> getTransaction(String transactionId) async {
    Dio dio = await RestUtils.dioClient(withResponseInterceptor: false);
    try {
      dio.options.baseUrl = BASE_URL;
      dio.options.contentType =
          ContentType.parse("application/json").toString();
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get('$URL_TRANSACTION/$transactionId');
      dynamic data = response.data;
      return data;
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }
}
