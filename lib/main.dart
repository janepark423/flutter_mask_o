import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mask/model/store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//final stores = List<Store>();
  final stores = <Store>[];
  var isLoading = true;

  Future fetch() async {
    setState(() {
      isLoading = true;
    });

//async와 await는 future 함수 안에서만 사용가능하다.
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    // 'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat=37.266389&lng=126.999333&m=5000';

    var response = await http.get(Uri.parse(url));

    final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));
    final jsonStores = jsonResult['stores'];

    setState(() {
      stores.clear();
      jsonStores.forEach((e) {
        stores.add(Store.fromJson(e));
      });
      isLoading = false;
    });
    print('fetch 완료');
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${stores.length}곳'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetch,
          )
        ],
      ),
      body: isLoading
          ? loadingWidget()
          : ListView(
              children: stores.map((e) {
                return ListTile(
                  title: Text(e.name ?? ''),
                  subtitle: Text(e.addr ?? ''),
                  trailing: _buildRemainStatWidget(e),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    return Column(
      children: <Widget>[
        Text(store.remainStat ?? '매진'),
        Text('100개'),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
