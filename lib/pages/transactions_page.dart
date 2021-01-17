import 'package:flutter/material.dart';
import 'package:obd/commons_widgets.dart';
import 'package:obd/datadrive_rest_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final Icon icon;

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Map> _values = new List();
  bool _loading = false;
  String _errorMessage;

  String _publicKey;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString('publicKey');
    setState(() {
      _values.clear();
      _publicKey = publicKey;
    });
    _searchItems();
  }

  _searchItems() async {
    if (!_loading) {
      setState(() {
        _loading = true;
        _errorMessage = null;
        _values.clear();
      });
    }
    List<dynamic> _searchResult = await _search();
    _searchResult.forEach((i) {
      Map map = {
        'id': i['transaction_id'],
        'isExpanded': false,
        'transaction': null
      };
      _values.add(map);
    });
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<List<dynamic>> _search() async {
    List items = await DatadriveRestService.internal().output();
    if (items == null) {
      _errorMessage = 'Servizio momentaneamente non disponibile. Riprovare';
      return null;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var body = (context) {
      if (_errorMessage != null) {
        return CommonsWidgets.errorBody(_errorMessage);
      }
      if (_loading && _values.isEmpty) {
        return CommonsWidgets.loadingBody('Caricamento...', '');
      }
      return createListView(context);
    };

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: ListTile(
          leading: Icon(Icons.linear_scale),
          title: Text(
            widget.title,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.refresh),
        onPressed: _searchItems,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'My Public Key',
                  style: TextStyle(fontSize: 18),
                ),
                SelectableText(
                  '$_publicKey',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(child: body(context)),
        ],
      ),
    );
  }

  Widget createListView(BuildContext context) {
    var bodyBuilder = () {
      if (_values.isEmpty) {
        return Center(
            child: new Text(
          'No Items',
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
      }
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _values[index]['isExpanded'] = !isExpanded;
                });
                loadDetail(index);
              },
              children: _values.map<ExpansionPanel>((item) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      leading: Icon(
                        Icons.linear_scale,
                        size: 40,
                        color: Colors.green,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['id']),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: item['transaction'] != null
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item['transaction']['asset'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                item['transaction']['metadata'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          )
                        : CommonsWidgets.loadingBody('', ''),
                  ),
//                body: item['transaction'] != null
//                    ? ListTile(
//                        title: Text(item['transaction']['asset'].toString()),
//                        subtitle: Text(item['transaction']['asset'].toString()),
//                      )
//                    : CommonsWidgets.loadingBody('', ''),
                  isExpanded: item['isExpanded'],
                );
              }).toList(),
            ),
          ),
        ),
      );
    };

    return Column(
      children: <Widget>[
        new Expanded(child: bodyBuilder()),
      ],
    );
  }

  Future<void> loadDetail(int index) async {
    if (_values[index]['transaction'] == null && _values[index]['isExpanded']) {
      dynamic transaction = await DatadriveRestService.internal()
          .getTransaction(_values[index]['id']);

      setState(() {
        _values[index]['transaction'] = transaction;
      });
    }
  }
}
