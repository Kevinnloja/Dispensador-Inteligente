import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamingScreen extends StatefulWidget {
  @override
  _StreamingScreenState createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  late String cameraUrl;

  @override
  void initState() {
    super.initState();
    cameraUrl = ''; // Inicializa cameraUrl con un valor vacío al inicio

    // Inicializa la conexión a Firebase
    final DatabaseReference _database =
        FirebaseDatabase.instance.reference().child('IP_Address');

    // Escucha los cambios en la dirección IP en Firebase
    _database.onValue.listen((event) {
      setState(() {
        // Actualiza la dirección IP del streaming
        cameraUrl = "http://${event.snapshot.value}";
      });
    });
  }

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
      body: cameraUrl
              .isNotEmpty // Verifica si cameraUrl no está vacío antes de cargar el WebView
          ? WebView(
              initialUrl: cameraUrl,
              javascriptMode: JavascriptMode.unrestricted,
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Muestra un indicador de carga mientras se recupera la dirección IP
    );
  }
}

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
