import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NivelEnvaseScreen extends StatefulWidget {
  @override
  _NivelEnvaseScreenState createState() => _NivelEnvaseScreenState();
}

class _NivelEnvaseScreenState extends State<NivelEnvaseScreen> {
  late double currentFoodLevel; // Nivel actual de comida

  final DatabaseReference _database = FirebaseDatabase.instance
      .reference()
      .child('Nivel de Comida'); // Referencia a la base de datos Firebase

  @override
  void initState() {
    super.initState();
    currentFoodLevel = 0.9; // Valor inicial del nivel de comida

    // Usar onValue para escuchar cambios en la base de datos
    _database.onValue.listen((DatabaseEvent event) {
      // Acceder al valor del snapshot de la base de datos
      if (event.snapshot.value != null) {
        setState(() {
          // Actualizar el estado del nivel de comida
          currentFoodLevel = (event.snapshot.value as double?) ?? 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nivel de estado del Envase',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3F3F9C), Color(0xFF5A46B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDispensadorIcon(), // Icono del dispensador
              SizedBox(height: 20),
              _buildNivelComidaWidget(), // Widget del nivel de comida
              SizedBox(height: 20),
              _buildProgressBar(), // Barra de progreso del nivel de comida
              SizedBox(height: 20),
              _buildStatusLabel(), // Estado del nivel de comida
              SizedBox(height: 20),
              _buildMessageContainer(), // Mensaje según el nivel de comida
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDispensadorIcon() {
    return Icon(
      Icons.local_dining,
      size: 80,
      color: Colors.white,
    );
  }

  Widget _buildNivelComidaWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        'Porcentaje de comida en el envase',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 300,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(211, 211, 211, 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildColoredProgressBar(), // Barra de progreso coloreada
          Center(
            child: Text(
              '${(100 - currentFoodLevel).toInt()}%', // Mostrar el porcentaje actual de comida
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoredProgressBar() {
    return Container(
      width: 300 *
          currentFoodLevel, // Ancho de la barra de progreso según el nivel actual de comida
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.8),
            Colors.yellow.withOpacity(0.8),
            Colors.green.withOpacity(0.8),
          ],
          stops: [0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildStatusLabel() {
    String statusLabel; // Etiqueta de estado
    Color statusColor; // Color de la etiqueta de estado

    if (currentFoodLevel >= 25) {
      statusLabel = 'Bajo';
      statusColor = Colors.red;
    } else if (currentFoodLevel >= 15) {
      statusLabel = 'Medio';
      statusColor = Colors.orange;
    } else {
      statusLabel = 'Alto';
      statusColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        'Estado: $statusLabel', // Mostrar el estado actual del nivel de comida
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Montserrat',
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMessageContainer() {
    String message; // Mensaje a mostrar
    Color messageColor; // Color del mensaje

    if (currentFoodLevel >= 35) {
      message =
          '¡Recargar el dispensador inmediatamente!\nLa salud de tu mascota está en peligro.';
      messageColor = Colors.red;
    } else if (currentFoodLevel >= 25) {
      message =
          'Alerta: El nivel de comida está bajo.\nConsidera recargar pronto.';
      messageColor = Colors.orange;
    } else if (currentFoodLevel >= 15) {
      message =
          'Información: Nivel de comida moderado.\nTu mascota tiene suficiente, pero considera recargar pronto.';
      messageColor = Colors.orange;
    } else {
      message = '¡Nivel de comida óptimo!\nTu mascota está bien alimentada.';
      messageColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        color: messageColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        message, // Mostrar el mensaje según el nivel de comida
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NivelEnvaseScreen(),
  ));
}
