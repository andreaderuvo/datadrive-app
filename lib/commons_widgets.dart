import 'package:flutter/material.dart';

class CommonsWidgets {
  static Widget loadingBody(String title, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(child: CircularProgressIndicator()),
        Container(height: 20.0),
        title.isNotEmpty ? Text(title) : Container(),
        Container(height: 5.0),
        Text(subtitle)
      ],
    );
  }

  static Widget errorBody(String title, {String message}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title ?? '',
            style: TextStyle(color: Colors.red, fontSize: 16.0),
          ),
          Container(height: 5.0),
          Text(
            message ?? '',
            style: TextStyle(color: Colors.red, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
