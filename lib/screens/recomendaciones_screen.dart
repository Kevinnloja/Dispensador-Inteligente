import 'package:flutter/material.dart';

// Pantalla de recomendaciones de alimentación
class RecomendacionesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de aplicación
      appBar: AppBar(
        title: Text(
          'Recomendaciones de Alimentación', // Título de la pantalla
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            Colors.deepPurple, // Color de fondo de la barra de aplicación
      ),
      // Contenido de la pantalla
      body: Container(
        // Decoración con gradiente de colores
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3F3F9C),
              Color(0xFF5A46B2)
            ], // Colores del gradiente
            begin: Alignment.topLeft, // Inicio del gradiente
            end: Alignment.bottomRight, // Fin del gradiente
          ),
        ),
        // Contenido centrado y desplazable
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Construye un título de categoría
                _buildCategoriaTitulo('Razas Pequeñas', Colors.blue,
                    'Ejemplos de razas pequeñas: Chihuahua, Pomerania, Yorkshire'),
                // Construye una recomendación para razas pequeñas
                _buildRecomendacion(
                  'Croquetas especiales, 3 veces al día.', // Título de la recomendación
                  [
                    '🐶 Edad: De 45 días a 1 año.',
                    '🍽 Porción: Aprox. 30-60g por comida.', // Lista de recomendaciones
                    '⏰ Intervalo: Mañana y tarde.',
                    '🥕 Además, proporcione snacks saludables como 10-20g de zanahorias pequeñas.',
                    '🐾 Para cachorros, inicie con alimentos para cachorros y ajuste la cantidad según el crecimiento.',
                    '👴🏽 Para mascotas mayores, considere alimentos para perros mayores ricos en antioxidantes y nutrientes para la salud cognitiva y articular.',
                    '📌 Pautas adicionales: Introduzca cambios en la dieta gradualmente para evitar problemas digestivos.',
                  ],
                  Icons.pets, // Icono de la recomendación
                  Colors.blue, // Color de fondo
                ),
                // Construye un título de categoría
                _buildCategoriaTitulo('Razas Medianas', Colors.green,
                    'Ejemplos de razas medianas: Bulldog Francés, Beagle, Cocker Spaniel'),
                // Construye una recomendación para razas medianas
                _buildRecomendacion(
                  'Croquetas balanceadas, 2 comidas al día.', // Título de la recomendación
                  [
                    '🐶 Edad: De más de 1 año a 7 años.',
                    '🍽  Porción: Aprox. 60-120g por comida.', // Lista de recomendaciones
                    '⏰ Intervalo: Mañana, tarde y noche.',
                    '🥩 Incluya alimentos frescos como 50-100g de carne magra y verduras.',
                    '👴🏽 A medida que envejece, ajuste la dieta según la actividad física.',
                    '👴🏽 Para mascotas mayores, adapte la dieta según la actividad física y considere alimentos para perros mayores que apoyen la salud general.',
                    '📌 Pautas adicionales: Monitoree el peso y ajuste las porciones según sea necesario. Consulte a un veterinario regularmente.',
                  ],
                  Icons.pets, // Icono de la recomendación
                  Colors.green, // Color de fondo
                ),
                // Construye un título de categoría
                _buildCategoriaTitulo('Razas Grandes', Colors.orange,
                    'Ejemplos de razas grandes: Labrador Retriever, Pastor Alemán, Golden Retriever'),
                // Construye una recomendación para razas grandes
                _buildRecomendacion(
                  'Croquetas con glucosamina, 2 veces al día.', // Título de la recomendación
                  [
                    '🐶 Edad: De 7 años en adelante.',
                    '🍽  Porción: Aprox. 100-200g por comida.', // Lista de recomendaciones
                    '⏰ Intervalo: Mañana y noche.',
                    '🥩 Asegúrese de proporcionar suficientes suplementos de calcio para el desarrollo óseo.',
                    '🐶 En pacientes geriátricos se recomienda balanceado menor en grasa, con glucosamina y contraprotectores.',
                    '👴🏽 Ajuste la dieta según la edad y considere alimentos para la salud de las articulaciones.',
                    '👴🏽 Para mascotas mayores, considere alimentos para perros mayores y suplementos que apoyen la salud de las articulaciones y la movilidad.',
                    '📌 Pautas adicionales: Controle la ingesta calórica para prevenir el aumento de peso. Consulte a un veterinario para pautas específicas de salud articular.',
                  ],
                  Icons.pets, // Icono de la recomendación
                  Colors.orange, // Color de fondo
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Construye un título de categoría
  Widget _buildCategoriaTitulo(
      String title, Color backgroundColor, String razasEjemplos) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: backgroundColor, // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Sombra
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Título de la categoría
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          // Ejemplos de razas
          Text(
            razasEjemplos,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Construye una recomendación
  Widget _buildRecomendacion(String titulo, List<String> recomendaciones,
      IconData icon, Color backgroundColor) {
    return Container(
      width: 320,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white, // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Sombra
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono y título de la recomendación
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: backgroundColor,
              ),
              SizedBox(width: 12),
              Text(
                'Recomendación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Título de la recomendación
          Container(
            width: 280,
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Detalles de la recomendación
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: backgroundColor,
              ),
              SizedBox(width: 12),
              Text(
                'Detalles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Lista de recomendaciones
          Container(
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recomendaciones
                  .map(
                    (recomendacion) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '• $recomendacion',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Función principal
void main() {
  runApp(MaterialApp(
    home:
        RecomendacionesScreen(), // Ejecuta la pantalla de recomendaciones al iniciar la aplicación
  ));
}
