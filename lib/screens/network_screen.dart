import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({Key? key}) : super(key: key);

  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  // Controladores para los campos de texto
  final TextEditingController _wifiNameController = TextEditingController();
  final TextEditingController _wifiPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para navegar a la pantalla de registro
  void _navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, 'home');
  }

  // Método para iniciar sesión
  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_wifiNameController.text.isEmpty ||
          _wifiPasswordController.text.isEmpty) {
        // Mostrar mensaje de error si falta algún campo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, complete todas las casillas'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Obtener UID del usuario actual
      String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        // Enviar credenciales WiFi a Firebase utilizando UID como clave
        DatabaseReference _wifiCredentialsRef = FirebaseDatabase.instance
            .reference()
            .child('Credenciales Wifi')
            .child(uid);

        _wifiCredentialsRef.set({
          'Nombre de la Red': _wifiNameController.text,
          'Contraseña': _wifiPasswordController.text,
        });

        // Limpiar los campos después del intento de conexión
        _wifiNameController.clear();
        _wifiPasswordController.clear();

        // Navegar a la pantalla de registro
        _navigateToRegister(context);
      } else {
        // No se pudo obtener el UID del usuario actual
        print("No se pudo obtener el UID del usuario actual.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        // Limpiar campos al retroceder
        _wifiNameController.clear();
        _wifiPasswordController.clear();
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Fondo púrpura con burbujas
              Cajapurpura(size),
              // Icono de mascota en la parte superior
              iconomascota(),
              // Formulario de inicio de sesión
              cajalogin(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el formulario de inicio de sesión
  SingleChildScrollView cajalogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            // Contenedor blanco con sombra para el formulario
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Campo de texto para el nombre de la red WiFi
                  TextFormField(
                    controller: _wifiNameController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                      hintText: 'Nombre de la red WiFi',
                      labelText: 'Nombre de la red WiFi',
                      prefixIcon: Icon(Icons.wifi, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Campo de texto para la contraseña de la red WiFi
                  TextFormField(
                    controller: _wifiPasswordController,
                    autocorrect: false,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                      hintText: 'Contraseña de la red WiFi',
                      labelText: 'Contraseña de la red WiFi',
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.purple),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Botón para iniciar sesión
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledColor: Colors.grey,
                    color: Colors.purple,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onPressed: () => _login(context),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Widget para el icono de mascota
  SafeArea iconomascota() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.pets, color: Colors.white, size: 100),
      ),
    );
  }

  // Widget para el fondo púrpura con burbujas
  Container Cajapurpura(Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]),
      ),
      width: double.infinity,
      height: size.height * 0.4,
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
        ],
      ),
    );
  }

  // Widget para las burbujas decorativas
  Container Burbujas() {
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
