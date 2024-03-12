import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dispenser/screens/streaming_screen.dart';

class HomeScreen extends StatelessWidget {
  static const double offsetVerticalSuperior = 20;
  static const double offsetVerticalInferior = 60;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dispensadorRef =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('Alimentación Manual');
  void _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, 'login');
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  void _sendRequestToFirebase(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('buttonPressCount') ?? 0;
    count++;
    prefs.setInt('buttonPressCount', count);

    _dispensadorRef.set({'dispensador_estado': int.parse(value)});
    print('Se envió el valor $value a Firebase.');
  }

  void _navigateToStreamingScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StreamingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(63, 63, 156, 1),
                  Color.fromRGBO(90, 70, 178, 1),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              children: [
                Positioned(
                  top: 90,
                  left: 30,
                  child: Burbujas(),
                ),
                Positioned(top: 90, left: 30, child: Burbujas()),
                Positioned(top: -40, left: -30, child: Burbujas()),
                Positioned(top: -10, right: -20, child: Burbujas()),
                Positioned(bottom: 10, left: 10, child: Burbujas()),
                Positioned(bottom: 100, right: 25, child: Burbujas()),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 105),
                    width: double.infinity,
                    child: Icon(
                      Icons.pets_sharp,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Transform.translate(
                      offset: Offset(0, offsetVerticalSuperior),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BotonIcono(
                            icono: Icons.videocam,
                            leyenda: 'Streaming en tiempo real',
                            onPressed: () {
                              _navigateToStreamingScreen(context);
                            },
                          ),
                          BotonIcono(
                            icono: Icons.album,
                            leyenda: 'Alimentación Manual',
                            onPressed: () {
                              _sendRequestToFirebase('1');
                            },
                          ),
                          BotonIcono(
                            icono: Icons.access_time,
                            leyenda: 'Alimentación Automática',
                            onPressed: () {
                              Navigator.pushNamed(context, 'automatica');
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 45),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BotonIcono(
                          icono: Icons.traffic,
                          leyenda: 'Nivel de estado del Envase',
                          onPressed: () {
                            Navigator.pushNamed(context, 'nivel_envase');
                          },
                        ),
                        BotonIcono(
                          icono: Icons.article,
                          leyenda: 'Recomendaciones de Alimentación',
                          onPressed: () {
                            Navigator.pushNamed(context, 'recomendaciones');
                          },
                        ),
                        BotonIcono(
                          icono: Icons.show_chart,
                          leyenda: 'Rendimiento',
                          onPressed: () {
                            Navigator.pushNamed(context, 'rendimiento');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _signOut(context);
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

class Burbujas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 225, 225, 0.05),
      ),
    );
  }
}

class BotonIcono extends StatelessWidget {
  final IconData icono;
  final String leyenda;
  final VoidCallback? onPressed;

  const BotonIcono({
    Key? key,
    required this.icono,
    required this.leyenda,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple,
            child: IconButton(
              icon: Icon(
                icono,
                size: 30,
                color: Colors.white,
              ),
              onPressed: onPressed,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            leyenda,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple),
          ),
        ],
      ),
    );
  }
}
