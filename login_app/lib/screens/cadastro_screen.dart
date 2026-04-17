import 'package:flutter/material.dart';
import 'package:login_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
  @override
  State<CadastroScreen> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroScreen> {
  Color corNome = Colors.grey;
  String mensagemErro = "";
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController senhaConfirmaController = TextEditingController();

  bool nomeValido(String nome) {
    final regex = RegExp(r'^[A-Za-zÀ-ÿ ]+$');

    return nome.trim().length >= 3 && regex.hasMatch(nome);
  }

  bool emailValido(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!regex.hasMatch(email)) return false;
    if (email.length < 6) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mensagemErro,
              style: TextStyle(
                color: mensagemErro.contains("válido")
                    ? Colors.green
                    : Colors.red,
                fontSize: 16,
              ),
            ),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: corNome),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: dataNascimentoController,
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: telefoneController,
              decoration: InputDecoration(
                labelText: 'Telefone (DDD e Número)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaConfirmaController,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                mensagemErro = '';
                print('Clicou no botão');
                
                if (senhaController.text != senhaConfirmaController.text) {
                  setState(() {
                    mensagemErro = 'Senhas não coincidem';
                  });
                } else if (senhaController.text.length < 8) {
                  setState(() {
                  mensagemErro = 'Senha inválida, menos de 8 carácteres';
                  });
                } else if (!emailValido(emailController.text)) {
                  setState(() {
                  mensagemErro = 'E-mail inválido';
                  });
                } else if (!nomeValido(nomeController.text)) {
                  setState(() {
                  corNome = AppColors.error;
                  });
                } else {
                  await FirebaseFirestore.instance.collection('clientes').add({
                    'nome': nomeController.text,
                    'email': emailController.text,
                    'senha_hash': senhaController.text,
                  });
                  setState(() {
                  mensagemErro = 'Cadastrado com sucesso!';
                  });
                }
              },
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
