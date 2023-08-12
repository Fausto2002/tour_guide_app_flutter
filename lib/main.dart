// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'information/information.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Guide App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imagenes/backgroundlogin.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Alineación vertical en el centro
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *
                        0.1), // Espacio superior
                child: Column(
                  children: [
                    Image.asset(
                      'assets/imagenes/grogutour.png',
                      width: 170,
                      height: 170,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '¡Vamos a explorar!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _login(),
              ),
              _botonesAccion(context),
              const SizedBox(height: 20),
              const Text(
                '@Grupo1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _login() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Usuario",
                hintText: "Ingrese su nombre de usuario",
                prefixIcon: Icon(Icons.person),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El campo es requerido";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Contraseña",
                hintText: "Ingrese su contraseña",
                prefixIcon: Icon(Icons.lock),
                border: InputBorder.none,
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El campo es requerido";
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  void _validarDatos(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('usuario', isEqualTo: username)
          .where('contraseña', isEqualTo: password)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: username)),
        );
      } else {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Usuario o contraseña incorrectos.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Widget _botonesAccion(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _validarDatos(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        ),
        child: const Text(
          "Iniciar Sesión",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
