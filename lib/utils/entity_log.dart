import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:obd/utils/app_utils.dart';

class EntityLog {
  static AnsiPen cianoDark = new AnsiPen()
    ..white()
    ..rgb(r: 0.0, g: 0.4, b: 1.0);

  static AnsiPen ciano = new AnsiPen()
    ..white()
    ..rgb(r: 0.0, g: 0.8, b: 1.0);

  static AnsiPen yellow = new AnsiPen()
    ..white()
    ..rgb(r: 1.0, g: 0.8, b: 0.2);

  static AnsiPen purple = new AnsiPen()
    ..white()
    ..rgb(r: 0.4, g: 0.4, b: 0.8);

  static void request(Response response) {
    if (AppUtils.isInDebugMode) {
      debugPrint(ciano("--------  REQUEST  --------"));
      debugPrint(ciano(
          " URL\n${response?.request?.baseUrl}${response?.request?.path}"));
      debugPrint(ciano(" STATUS CODE ${response?.statusCode.toString()}"));
      debugPrint(ciano(" HEADERS\n${response?.request?.headers}"));
      debugPrint(ciano(" DATA\n${response?.request?.data?.toString()}"));
      debugPrint(ciano("---------------------------"));
    }
  }

  static void response(Response response) {
    if (AppUtils.isInDebugMode) {
      debugPrint(cianoDark("-------- RESPONSE ---------"));
      debugPrint(cianoDark(" HEADERS\n${response?.headers}"));
      debugPrint(cianoDark(" DATA\n${response?.data?.toString()}"));
      debugPrint(cianoDark("---------------------------"));
    }
  }

  static void longResponse(Response response) {
    if (AppUtils.isInDebugMode) {
//    debugPrint('response: ${response.data}');

      String value = response.data.toString();
      print("---------------------------");
      print(purple("RESPONSE"));
      if (value.length > 1000) {
        double chunkCount = (value.length / 1000); // integer division
        for (int i = 0; i <= chunkCount; i++) {
          int max = 1000 * (i + 1);
          if (max >= value.length) {
            print(purple(value.substring(1000 * i)));
          } else {
            print(purple(value.substring(1000 * i, max)));
          }
        }
      } else {
        print(purple(value));
      }
      print("---------------------------");
    }
  }
}
