import 'package:flutter/material.dart';
import 'package:kintone_flutter/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

final Map<String, String> postHeader = {
  'X-Cybozu-API-Token': apiToken!,
  'Content-Type': 'application/json'
};

final Map<String, String> getHeader = {
  'X-Cybozu-API-Token': apiToken!,
};

Future<Map<String, dynamic>> postRecord(int number) async {
  final Map<String, dynamic> postRecord = {
    'app': id,
    'record': {
      'number': {'value': number},
    }
  };

  return await http
      .post(Uri.parse('$baseUrl/record.json'),
          headers: postHeader, body: jsonEncode(postRecord))
      .then(((response) {
    Map<String, dynamic> rec = jsonDecode(response.body);
    return rec;
  }));
}

Future<Map<String, dynamic>> fetchRecords(String query) async {
  String encodedQuery = Uri.encodeFull(query);
  return await http
      .get(
          Uri.parse(
            '$baseUrl/records.json?app=$id&query=$encodedQuery',
          ),
          headers: getHeader)
      .then(((response) {
    Map<String, dynamic> rec = jsonDecode(response.body);
    return rec;
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      fetchRecords('');
      postRecord(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
