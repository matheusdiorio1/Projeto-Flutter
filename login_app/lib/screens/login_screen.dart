import 'package:flutter/material.dart';
import 'package:login_app/screens/cadastro_screen.dart';

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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 17, 6),
      appBar: AppBar(
        title: const Text('Login', style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cine_preto.png',
              height: 150, // Ajuste a altura conforme necessário
              fit: BoxFit.contain, // Garante que a imagem não seja cortada
            ),

            const SizedBox(
              height: 30,
            ), // Espaço entre a imagem e o campo de Email

            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
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
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
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
              onPressed: () {
                print('Validar e-mail e senha com o banco de dados');
              },
              child: const Text('Entrar', style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0))),
                            style: ButtonStyle(
                // 1. Cor padrão do botão (Fundo Vermelho)
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color.fromARGB(255, 202, 200, 200); // Cor quando o mouse está em cima
                  }
                  return const Color.fromARGB(255, 0, 0, 0); // Cor normal
                }),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroScreen()),
                );
              },

              child: const Text("Cadastrar-se", style: const TextStyle(color: Color.fromARGB(255, 255, 0, 0))),
              
              style: ButtonStyle(
                // 1. Cor padrão do botão (Fundo Vermelho)
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color.fromARGB(255, 202, 200, 200); // Cor quando o mouse está em cima
                  }
                  return const Color.fromARGB(255, 0, 0, 0); // Cor normal
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}