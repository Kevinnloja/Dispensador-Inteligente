import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Función para navegar a la pantalla de registro
  void _navigateToRegister() {
    Navigator.pushNamed(context, 'register');
  }

  // Función para realizar el inicio de sesión
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Imprimir el usuario que inició sesión
      print("Logged in user: ${userCredential.user}");

      // Utilizar directamente el UID como ruta en la base de datos
      DatabaseReference userNodeRef =
          FirebaseDatabase.instance.reference().child('UID ACTUAL');
      userNodeRef.set(userCredential.user!.uid);

      // Navegar a la pantalla de inicio solo si el inicio de sesión es exitoso
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, 'home');
      }

      // Limpiar los campos después del inicio de sesión
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      print("Login error: $e");

      String errorMessage =
          "Error durante el inicio de sesión. Por favor, inténtalo de nuevo.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage =
                'Usuario no encontrado. Verifica tu correo electrónico.';
            break;
          case 'wrong-password':
            errorMessage =
                'Contraseña incorrecta. Por favor, inténtalo de nuevo.';
            break;
          case 'invalid-email':
            errorMessage =
                'Correo electrónico no válido. Ingresa un correo electrónico válido.';
            break;
          default:
            // Manejar otros errores FirebaseAuthException según sea necesario
            break;
        }
      }

      // Mostrar un mensaje de error utilizando un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Evita que el teclado ajuste la interfaz de usuario
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Stack(
            children: [
              // Fondo púrpura
              Cajapurpura(size),
              // Icono de mascota
              iconomascota(),
              // Contenedor para el formulario de inicio de sesión
              cajalogin(context),

              // Texto flotante de Ayuda a la izquierda del botón
              Positioned(
                bottom: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ayuda',
                      style: TextStyle(color: Colors.purple),
                    ),
                    SizedBox(
                        width:
                            4), // Ajusta el espacio entre el texto y el botón
                    FloatingActionButton(
                      onPressed: () {
                        // Navegar a la pantalla de ayuda
                        Navigator.pushNamed(context, 'ayuda');
                      },
                      backgroundColor: Colors.purple,
                      tooltip: 'Ayuda',
                      child: Icon(Icons.help_outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Contenedor para el formulario de inicio de sesión
  SingleChildScrollView cajalogin(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
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
                  // Campo de texto para el correo electrónico
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                      hintText: 'ejemplo@gmail.com',
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.alternate_email_rounded,
                          color: Colors.purple),
                    ),
                    validator: (value) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'Ingrese un correo válido';
                    },
                  ),
                  const SizedBox(height: 30),
                  // Campo de texto para la contraseña
                  TextFormField(
                    controller: _passwordController,
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
                      hintText: '******',
                      labelText: 'Contraseña',
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
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : 'La contraseña debe ser mayor o igual a 6 caracteres';
                    },
                  ),
                  const SizedBox(height: 30),
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
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: _login,
                  ),
                  const SizedBox(height: 30),
                  // Botón para navegar a la pantalla de registro
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                    onPressed: _navigateToRegister,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // Widget para el icono de la mascota
  SafeArea iconomascota() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.pets_sharp, color: Colors.white, size: 100),
      ),
    );
  }

  // Widget para el fondo púrpura
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

  // Widget para las burbujas decorativas en el fondo
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
