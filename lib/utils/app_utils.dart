import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static void snackbarOffline(BuildContext context) {
    final snackBar = new SnackBar(
      content: new Text(
        'CONNESSIONE INTERNET ASSENTE',
        style: TextStyle(color: Colors.red),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void snackbarOfflineByScaffoldKey(GlobalKey<ScaffoldState> key) {
    if (key.currentState == null || !key.currentState.mounted) {
      return;
    }
    final snackBar = new SnackBar(
      content: new Text(
        'CONNESSIONE INTERNET ASSENTE',
        style: TextStyle(color: Colors.red),
      ),
    );
    key.currentState.showSnackBar(snackBar);
  }

  static void serviceUnavailableSnackbar(GlobalKey<ScaffoldState> key) {
    if (key.currentState == null || !key.currentState.mounted) {
      return;
    }
    final snackBar = new SnackBar(
      content: new Text(
        'Servizio momentaneamente non disponibile. Riprovare',
        style: TextStyle(color: Colors.red),
      ),
    );
    key.currentState.showSnackBar(snackBar);
  }

  static void errorSnackBar(GlobalKey<ScaffoldState> key, String message) {
    if (key.currentState == null || !key.currentState.mounted) {
      return;
    }
    final snackBar = new SnackBar(
      content: new Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
    key.currentState.showSnackBar(snackBar);
  }

  static void successSnackBar(GlobalKey<ScaffoldState> key, String message) {
    if (key.currentState == null || !key.currentState.mounted) {
      return;
    }
    final snackBar = new SnackBar(
      content: new Text(
        message,
        style: TextStyle(color: Colors.green),
      ),
    );
    key.currentState.showSnackBar(snackBar);
  }

  static void snackBar(GlobalKey<ScaffoldState> key, String message) {
    if (key.currentState == null || !key.currentState.mounted) {
      return;
    }
    final snackBar = new SnackBar(
      content: new Text(
        message,
//        style: TextStyle(color: Colors.green),
      ),
    );
    key.currentState.showSnackBar(snackBar);
  }

  static String MD5(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  static bool get isInDebugMode {
    bool inDebugMode = false;
    // Assert statements have no effect in production code; they’re for development only.
    // Flutter enables asserts in debug mode
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static Future<bool> isConnected() async {
    try {
      ConnectivityResult result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (error) {}
    return true;
  }

  static Future<bool> isOffline() async {
    try {
      ConnectivityResult result = await Connectivity().checkConnectivity();
      return result == ConnectivityResult.none;
    } catch (error) {}
    return false;
  }
}
