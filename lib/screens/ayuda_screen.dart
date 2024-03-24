import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AyudaScreen extends StatelessWidget {
  final String youtubeVideoUrl =
      'https://drive.google.com/file/d/1RxGBDsJMz48-SI3g5-ND3WVhW91EqCQw/preview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ayuda',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: WebView(
        initialUrl: youtubeVideoUrl,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true, // Habilitar la navegación con gestos
      ),
    );
  }
}
