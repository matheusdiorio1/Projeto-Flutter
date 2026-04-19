import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:login_app/screens/cadastro_screen.dart';
import 'package:login_app/screens/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 20, 7),
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_cine2.png',
              height: 180, // Ajuste a altura conforme necessário
              fit: BoxFit.contain, // Garante que a imagem não seja cortada
            ),

            const SizedBox(
              height: 30,
            ), // Espaço entre a imagem e o campo de Email

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Senha',
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: senhaController.text,
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  String mensagem = 'Erro ao fazer login';

                  if (e.code == 'user-not-found') {
                    mensagem = 'Usuário não encontrado';
                  } else if (e.code == 'wrong-password') {
                    mensagem = 'Senha incorreta';
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(mensagem)));
                }
              },
              style: ButtonStyle(
                // 1. Cor padrão do botão (Fundo Vermelho)
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color.fromARGB(
                      255,
                      50,
                      48,
                      48,
                    ); // Cor quando o mouse está em cima
                  }
                  return const Color.fromARGB(255, 0, 0, 0); // Cor normal
                }),
              ),
              child: Text(
                'Entrar',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Não tem conta? ',
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: 'Cadastre-se',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CadastroScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
