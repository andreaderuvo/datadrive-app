import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'package:obd/commons_widgets.dart';
import 'package:obd/obd_rest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OBDPage extends StatefulWidget {
  OBDPage({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final Icon icon;

  @override
  _OBDPageState createState() => _OBDPageState();
}

class _OBDPageState extends State<OBDPage> {
  FlutterMdnsPlugin _mdnsPlugin;
  List<String> messageLog = <String>[];
  DiscoveryCallbacks discoveryCallbacks;

  bool _connected = false;

  TextEditingController _vehicleController = new TextEditingController();
  TextEditingController _serialController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    testMDNS();
  }

  Future<void> testMDNS() async {
    discoveryCallbacks = new DiscoveryCallbacks(
      onDiscovered: (ServiceInfo info) {
//        print("Discovered ${info.toString()}");
      },
      onDiscoveryStarted: () {
//        print("Discovery started");
      },
      onDiscoveryStopped: () {
//        print("Discovery stopped");
      },
      onResolved: (ServiceInfo info) {
        if (info.name == 'datadrive') {
          _mdnsPlugin.stopDiscovery();
          testOBD(info.hostName);
        }
        setState(() {
//          messageLog.insert(0, "DISCOVERY: Resolved ${info.toString()}");
        });
      },
    );
    startMdnsDiscovery("_http._tcp");
  }

  Future<void> testOBD(String hostName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString('publicKey');
    OBDRestService.internal().configuration(hostName, publicKey);
  }

  startMdnsDiscovery(String serviceType) {
    _mdnsPlugin = new FlutterMdnsPlugin(discoveryCallbacks: discoveryCallbacks);
    // cannot directly start discovery, have to wait for ios to be ready first...
    Timer(Duration(seconds: 3), () => _mdnsPlugin.startDiscovery(serviceType));
  }

  void reassemble() {
    super.reassemble();
    if (null != _mdnsPlugin) {
      _mdnsPlugin.restartDiscovery();
    }
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
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        elevation: 0.0,
//        child: new Icon(Icons.refresh),
//      ),
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
                  children: <Widget>[
                    Center(
                      child: _connected ? _connectedCard() : _setupCard(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _setupCard() {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _vehicleController,
                      style: TextStyle(fontSize: 20.0),
                      enabled: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.directions_car),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Vehicle Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _serialController,
                      enabled: true,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Serial Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0))),
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                        elevation: 0,
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'CONNECT',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        color: Colors.red[500],
                        onPressed: () async {
                          setState(() {
                            _connected = true;
                          });
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

  Widget _connectedCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text('CONNECTED',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Vehicle Name', style: TextStyle(fontSize: 20.0)),
                    Text('${_vehicleController.text}',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Serial Number', style: TextStyle(fontSize: 20.0)),
                    Text('${_serialController.text}',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
