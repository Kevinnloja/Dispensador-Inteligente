import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _nombreMascotaController =
      TextEditingController();
  final TextEditingController _edadMascotaController = TextEditingController();
  final TextEditingController _razaMascotaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _mostrarContrasena = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _navegarAInicio() async {
    if (!_formKey.currentState!.validate()) {
      // No continuar con el registro si la validación falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Por favor, llena todos los campos para completar el registro.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _correoController.text,
        password: _contrasenaController.text,
      );

      String uid = userCredential.user!.uid; // Obtén el UID del usuario
      String nombreUsuario = _nombreUsuarioController.text;
      String nombreMascota = _nombreMascotaController.text;
      int edadMascota = int.parse(_edadMascotaController.text);
      String razaMascota = _razaMascotaController.text;
      DatabaseReference databaseRef = FirebaseDatabase.instance
          .ref()
          .child('Datos de Registro')
          .child(uid); // Utiliza el UID como clave
      databaseRef.set({
        'Nombre Usuario': nombreUsuario,
        'Nombre Mascota': nombreMascota,
        'Edad Mascota': edadMascota,
        'Raza Mascota': razaMascota,
      });
      DatabaseReference userNodeRef =
          FirebaseDatabase.instance.reference().child('UID ACTUAL');
      userNodeRef.set(userCredential.user!.uid);
      print("Usuario registrado: ${userCredential.user}");

      Navigator.pushReplacementNamed(
        context,
        'home', // AQUI SE DEIRIGUE AL SCREEN DE WIFI O AL INICIO
        arguments: {
          'nombreUsuario': nombreUsuario,
          'nombreMascota': nombreMascota,
          'edadMascota': edadMascota,
          'razaMascota': razaMascota,
        },
      );
    } catch (e) {
      print("Error durante el registro: $e");
      String errorMessage =
          "Error durante el registro. Por favor, inténtalo de nuevo.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          // código de manejo de errores
        }
      }

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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, 'login');
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Cajapurpura(size),
              iconomascota(),
              formularioRegistro(context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView formularioRegistro(BuildContext context) {
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
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Registro', style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombreUsuarioController,
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
                          hintText: 'Nombre del dueño',
                          labelText: 'Nombre del dueño',
                          prefixIcon: Icon(Icons.person, color: Colors.purple),
                        ),
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor, ingresa un nombre de usuario válido';
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nombreMascotaController,
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
                          hintText: 'Nombre de la Mascota',
                          labelText: 'Nombre de la Mascota',
                          prefixIcon: Icon(Icons.pets, color: Colors.purple),
                        ),
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor, ingresa el nombre de la mascota';
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _edadMascotaController,
                        keyboardType: TextInputType.number,
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
                          hintText: 'Edad en meses',
                          labelText: 'Edad de la Mascota',
                          prefixIcon: Icon(Icons.timer, color: Colors.purple),
                        ),
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor, ingresa la edad de la mascota';
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _razaMascotaController,
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
                          hintText: 'Pequeña, mediana o grande',
                          labelText: 'Raza de la mascota',
                          prefixIcon: Icon(Icons.pets, color: Colors.purple),
                        ),
                        validator: (value) {
                          return (value != null && value.isNotEmpty)
                              ? null
                              : 'Por favor, ingresa la raza de la mascota';
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
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
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.alternate_email_rounded,
                              color: Colors.purple),
                        ),
                        validator: (value) {
                          String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          RegExp regExp = new RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                              ? null
                              : 'Por favor, ingresa un correo electrónico válido';
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _contrasenaController,
                        obscureText: !_mostrarContrasena,
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
                              _mostrarContrasena
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple,
                            ),
                            onPressed: () {
                              setState(() {
                                _mostrarContrasena = !_mostrarContrasena;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          return (value != null && value.length >= 6)
                              ? null
                              : 'La contraseña debe tener al menos 6 caracteres';
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.purple,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: _navegarAInicio,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  SafeArea iconomascota() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.pets_sharp, color: Colors.white, size: 100),
      ),
    );
  }

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
