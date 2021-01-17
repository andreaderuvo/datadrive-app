import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:obd/bottom_navigation_provider.dart';
import 'package:obd/pages/home.dart';
import 'package:obd/user_repository.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController =
      new TextEditingController(text: 'admin');
  TextEditingController _passwordController =
      new TextEditingController(text: 'admin');

  @override
  void initState() {
    super.initState();
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
                _loginCard(),
                MaterialButton(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginCard() {
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
                'images/obd_logo.jpeg',
                height: 150,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(fontSize: 20.0),
                      enabled: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
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
                          prefixIcon: Icon(Icons.lock),
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
                          'SIGN IN',
                          style: TextStyle(fontSize: 18),
                        ),
                        color: Colors.red[500],
                        onPressed: () async {
                          login(_usernameController.text,
                              _passwordController.text);
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

  Future login(String username, String password) async {
    var home = ChangeNotifierProvider<BottomNavigationProvider>(
      child: Home(),
      builder: (BuildContext context) => BottomNavigationProvider(),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => home));
  }
}
