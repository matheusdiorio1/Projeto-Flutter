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

enum EstadoCampo { neutro, valido, invalido }

class _CadastroPageState extends State<CadastroScreen> {
  String mensagemErro = "";

  EstadoCampo nomeEstado = EstadoCampo.neutro;
  EstadoCampo emailEstado = EstadoCampo.neutro;
  EstadoCampo senhaEstado = EstadoCampo.neutro;
  EstadoCampo telefoneEstado = EstadoCampo.neutro;
  EstadoCampo dataEstado = EstadoCampo.neutro;
  EstadoCampo confirmaSenhaEstado = EstadoCampo.neutro;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController senhaConfirmaController = TextEditingController();

  Color corDoCampo(EstadoCampo estado) {
    switch (estado) {
      case EstadoCampo.valido:
        return Colors.green;
      case EstadoCampo.invalido:
        return Colors.red;
      case EstadoCampo.neutro:
      default:
        return Colors.grey;
    }
  }

  bool nomeValido(String nome) {
    final regex = RegExp(r'^[A-Za-zÀ-ÿ ]+$');

    return nome.trim().length >= 3 && regex.hasMatch(nome);
  }

  bool telefoneValido(String telefone) {
  final apenasNumeros = telefone.replaceAll(RegExp(r'[^0-9]'), '');

  return apenasNumeros.length == 10 || apenasNumeros.length == 11;
}

  bool emailValido(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!regex.hasMatch(email)) return false;
    if (email.length < 6) return false;

    return true;
  }

  void validarNome() {
    setState(() {
      if (nomeValido(nomeController.text)) {
        nomeEstado = EstadoCampo.valido;
      } else {
        nomeEstado = EstadoCampo.invalido;
      }
    });
  }

  void validarData(DateTime data) {
    setState(() {
      final hoje = DateTime.now();

      // não pode ser no futuro
      if (data.isAfter(hoje)) {
        dataEstado = EstadoCampo.invalido;
        return;
      }

      // se chegou aqui, é válida
      dataEstado = EstadoCampo.valido;
    });
  }

   void validarTelefone() {
    setState(() {
      if (telefoneValido(telefoneController.text)) {
        telefoneEstado = EstadoCampo.valido;
      } else {
        telefoneEstado = EstadoCampo.invalido;
      }
    });
  }

  void validarEmail() {
    setState(() {
      if (emailValido(emailController.text)) {
        emailEstado = EstadoCampo.valido;
      } else {
        emailEstado = EstadoCampo.invalido;
      }
    });
  }

  void validarSenha() {
    setState(() {
      if (senhaController.text.length >= 8) {
        senhaEstado = EstadoCampo.valido;
      } else {
        senhaEstado = EstadoCampo.invalido;
      }
    });
  }

  void validarConfirmaSenha() {
    setState(() {
      if (senhaController.text == senhaConfirmaController.text) {
        confirmaSenhaEstado = EstadoCampo.valido;
      } else {
        confirmaSenhaEstado = EstadoCampo.invalido;
      }
    });
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
            TextField(
              controller: nomeController,
              onChanged: (_) => validarNome(),
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(nomeEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(nomeEstado),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: dataNascimentoController,
              readOnly: true,
              onTap: () async {
                DateTime? data = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (data == null) {
                  setState(() {
                    dataEstado = EstadoCampo.invalido;
                    dataNascimentoController.clear();
                  });
                  return;
                }
                setState(() {
                  dataNascimentoController.text =
                      "${data.day}/${data.month}/${data.year}";
                });

                validarData(data);
              },
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(dataEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(dataEstado),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: telefoneController,
              onChanged: (_) => validarTelefone(),
              decoration: InputDecoration(
                labelText: 'Telefone (DDD e Número)',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(telefoneEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(telefoneEstado),
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              onChanged: (_) => validarEmail(),
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(emailEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(emailEstado),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaController,
              onChanged: (_) => validarSenha(),
              decoration: InputDecoration(
                labelText: 'Senha',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(senhaEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(senhaEstado),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaConfirmaController,
              onChanged: (_) => validarConfirmaSenha(),
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(confirmaSenhaEstado),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(confirmaSenhaEstado),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                mensagemErro = '';
                print('Clicou no botão');
                validarNome();
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
