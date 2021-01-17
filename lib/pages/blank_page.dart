import 'package:flutter/material.dart';

class BlankPage extends StatefulWidget {
  BlankPage({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final Icon icon;

  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: ListTile(
          leading: this.widget.icon,
          title: Text(
            widget.title,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
