import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initNotifications() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('Token:');
      print(token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('-------------MENSAJE--------');
      print(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('-------------LAUNCH---------');
      print(message);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('-------------RESUME---------');
      print(message);
    });
  }

  // Método para enviar una notificación con el mensaje deseado
  void enviarNotificacion() {
    // Crear el cuerpo de la notificación con el mensaje deseado
    var notification = {
      'notification': {
        'title': 'Dispensador activado',
        'body': 'Tu mascota tiene comida',
      },
      'priority': 'high',
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
    };

    // Convertir el mapa a Map<String, String> y luego a Map<String, String>?
    var notificationString =
        notification.cast<String, String>().cast<String, String>();

    // Enviar la notificación usando Firebase Messaging
    _firebaseMessaging.sendMessage(
      to: '/topics/all', // Cambia a tu topic o token específico si es necesario
      data: notificationString,
    );
  }
}
