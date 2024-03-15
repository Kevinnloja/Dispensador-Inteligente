#include <FirebaseESP8266.h>
#include <ESP8266WiFi.h>
#include <Wire.h>

// Definición de las credenciales de WiFi y de Firebase
#define WIFI_SSID "Internet_UNL"
#define WIFI_PASSWORD "UNL1859WiFi"
#define FIREBASE_HOST "................................"
#define FIREBASE_AUTH "................................"

// Definición de los pines del sensor de ultrasonido y de los LEDs
#define PIN_TRIG 14
#define PIN_ECHO 12
#define LED_RED_PIN 4
#define LED_YELLOW_PIN 5
#define LED_GREEN_PIN 16

FirebaseData firebaseData; // Objeto para manejar la conexión con Firebase
bool dispensadorActivo = false; // Variable para almacenar el estado del dispensador
bool automaticaActivo = false; // Variable para almacenar el estado automático
bool ledEncendido = false; // Variable para almacenar el estado del LED

// Definición de pines para el motor paso a paso
#define STEP 0    // pin STEP de A4988 a pin D3 (GPIO3)
#define DIR 2     // pin DIR de A4988 a pin D4 (GPIO4)

void setup() {
  Serial.begin(115200); // Iniciar la comunicación serial a 115200 baudios
  pinMode(PIN_TRIG, OUTPUT); // Configurar el pin del sensor de ultrasonido como salida
  pinMode(PIN_ECHO, INPUT); // Configurar el pin del sensor de ultrasonido como entrada
  pinMode(LED_RED_PIN, OUTPUT); // Configurar el pin del LED rojo como salida
  pinMode(LED_YELLOW_PIN, OUTPUT); // Configurar el pin del LED amarillo como salida
  pinMode(LED_GREEN_PIN, OUTPUT); // Configurar el pin del LED verde como salida

  // Conexión a la red WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  // Esperar hasta que se establezca la conexión WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  // Inicializar la conexión con Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  // Reconectar WiFi si la conexión se pierde
  Firebase.reconnectWiFi(true);

  // Configuración de pines del motor paso a paso
  pinMode(STEP, OUTPUT);
  pinMode(DIR, OUTPUT);
}

void loop() {
  // Código para medir distancia y enviar a Firebase
  float tiempo;
  float distancia;

  // Generar un pulso en el pin TRIG del sensor de ultrasonido
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(4);
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);

  // Medir la duración del pulso de eco en el pin ECHO y calcular la distancia
  tiempo = pulseIn(PIN_ECHO, HIGH);
  distancia = tiempo / 58.3;

  // Enviar la distancia medida a Firebase en el nodo "Nivel de Comida"
  if (Firebase.setFloat(firebaseData, "/Nivel de Comida", distancia)) {
    Serial.println("Dato enviado a Firebase: " + String(distancia));
  } else {
    Serial.println("Error al enviar el dato a Firebase");
  }

  // Lógica para encender el LED correspondiente según la distancia medida
  if (distancia >= 25) {
    digitalWrite(LED_RED_PIN, HIGH);
    digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_GREEN_PIN, LOW);
  } else if (distancia >= 15) {
    digitalWrite(LED_RED_PIN, LOW);
    digitalWrite(LED_YELLOW_PIN, HIGH);
    digitalWrite(LED_GREEN_PIN, LOW);
  } else {
    digitalWrite(LED_RED_PIN, LOW);
    digitalWrite(LED_YELLOW_PIN, LOW);
    digitalWrite(LED_GREEN_PIN, HIGH);
  }

  // Controlar el motor paso a paso según los datos de Firebase
  if (Firebase.getInt(firebaseData, "/Alimentación Manual/dispensador_estado")) {
    int dispensadorEstado = firebaseData.intData();
    Serial.print("Estado del dispensador: ");
    Serial.println(dispensadorEstado);

    if (dispensadorEstado == 1) {
      activarMotor();
      // Actualizar el estado del dispensador en Firebase
      dispensadorActivo = !dispensadorActivo; // Cambiar el estado del dispensador
      if (Firebase.setInt(firebaseData, "/Alimentación Manual/dispensador_estado", dispensadorActivo ? 0 : 1)) {
        Serial.println("Estado del dispensador actualizado en Firebase");
      } else {
        Serial.println("Error al actualizar el estado del dispensador en Firebase");
      }
    }
  } else {
    Serial.println("Error al obtener el estado del dispensador");
  }

  if (Firebase.getBool(firebaseData, "/automatica_activo")) {
    automaticaActivo = firebaseData.boolData();
    Serial.print("Estado de automatica_activo: ");
    Serial.println(automaticaActivo);

    if (automaticaActivo) {
      activarMotor();
      // Cambiar el estado de AUTOMATICA_ACTIVO a false después de 10 segundos
      Firebase.setBool(firebaseData, "/automatica_activo", false);
      Serial.println("automatica_activo cambiado a false después de 10 segundos");
    }
  } else {
    Serial.println("Error al obtener el estado de AUTOMATICA_ACTIVO");
  }

  delay(1000); // Esperar 1 segundo antes de repetir el bucle
}

void activarMotor() {
  digitalWrite(DIR, HIGH); // Girar en un sentido
  for (int i = 0; i < 300; i++) { // 300 iteraciones * 20 ms = 6 segundos
    digitalWrite(STEP, HIGH); // Nivel alto
    delay(10); // Por 10 ms
    digitalWrite(STEP, LOW); // Nivel bajo
    delay(10); // Por 10 ms
    dispensadorActivo = false;
  }
}
