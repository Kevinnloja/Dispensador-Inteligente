// Importar los paquetes necesarios
import 'package:intl/intl.dart'; // Para manejo de fechas y horas
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_dispenser/screens/home_screen.dart';
import 'package:smart_dispenser/screens/login_screen.dart';
import 'package:smart_dispenser/screens/ayuda_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smart_dispenser/screens/network_screen.dart';
import 'package:smart_dispenser/screens/register_screen.dart';
import 'package:smart_dispenser/screens/automatica_screen.dart';
import 'package:smart_dispenser/screens/rendimiento_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_dispenser/screens/nivel_envase_screen.dart';
import 'package:smart_dispenser/screens/recomendaciones_screen.dart';

void main() async {
  // Asegurar que Flutter esté inicializado correctamente
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Configurar idioma predeterminado a español
  Intl.defaultLocale = 'es';

  // Ejecutar la aplicación Flutter
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Instancia de Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Inicializar notificaciones
    initNotifications();
  }

  void initNotifications() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    // Suscribir a todos los dispositivos al tema "/topics/all"
    _firebaseMessaging.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Ocultar banner de depuración
      debugShowCheckedModeBanner: false,
      // Título de la aplicación
      title: 'Dispensador de Comida',
      // Página de inicio de la aplicación (página de inicio de sesión si no hay usuario autenticado, de lo contrario, página principal)
      home: _auth.currentUser == null ? LoginScreen() : HomeScreen(),
      // Definir rutas para la navegación entre pantallas
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'register': (_) => RegisterScreen(),
        'automatica': (_) => AutomaticaScreen(),
        'nivel_envase': (_) => NivelEnvaseScreen(),
        'recomendaciones': (_) => RecomendacionesScreen(),
        'network': (_) => NetworkScreen(),
        'ayuda': (_) => AyudaScreen(),
        'rendimiento': (_) => RendimientoScreen(),
      },
      // Configurar delegados de localización global
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Configurar locales admitidos (solo español)
      supportedLocales: [
        const Locale('es', ''),
      ],
    );
  }
}
