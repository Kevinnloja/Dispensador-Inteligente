import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamingScreen(),
    );
  }
}

class StreamingScreen extends StatelessWidget {
  final String cameraUrl = 'http://10.20.136.199';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Streaming en Tiempo Real',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: WebView(
        initialUrl: cameraUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
