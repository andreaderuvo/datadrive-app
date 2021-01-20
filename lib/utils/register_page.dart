import 'package:flutter/material.dart';
import 'package:obd/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:obd/bottom_navigation_provider.dart';
import 'package:obd/pages/home.dart';
import 'package:obd/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datadrive_rest_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  TextEditingController _nomeController = new TextEditingController();
  TextEditingController _cognomeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nomeController.text = 'Mario';
      _cognomeController.text = 'Mario';
      _usernameController.text = 'mario@rossi.it';
      _passwordController.text = 'password';
    });
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString('publicKey');
    String privateKey = prefs.getString('privateKey');

//    if (publicKey != null && privateKey != null) {
//      Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (context) => LoginPage()));
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.red[500],
              Colors.red[800],
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _registerCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/obd_logo2.jpeg',
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _nomeController,
                      style: TextStyle(fontSize: 20.0),
                      enabled: true,
                      decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.person),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "First Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _cognomeController,
                      style: TextStyle(fontSize: 20.0),
                      enabled: true,
                      decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.person),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Last Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(fontSize: 20.0),
                      enabled: true,
                      decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.person),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      enabled: true,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
//                          prefixIcon: Icon(Icons.lock),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                        elevation: 0,
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        color: Colors.red[500],
                        onPressed: () async {
                          register();
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future register() async {
    Map result = await DatadriveRestService.internal().register();
    String publicKey = result['publicKey'];
    String privateKey = result['privateKey'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('publicKey', publicKey);
    await prefs.setString('privateKey', privateKey);
    showSuccessDialog(publicKey);
  }

  void gotoLogin() {
    var page = ChangeNotifierProvider<BottomNavigationProvider>(
      child: LoginPage(),
      builder: (BuildContext context) => BottomNavigationProvider(),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  void showSuccessDialog(String publicKey) async {
    await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () {},
              child: new AlertDialog(
                content: Text(
                  "Registration Completed.",
                  style: TextStyle(fontSize: 15),
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context, true);
                        gotoLogin();
                      }),
                ],
              ));
        });
  }
}
