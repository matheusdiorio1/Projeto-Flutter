import 'package:flutter/material.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String mensagemCadastro = '';
  String? erroNome;
  String? erroTelefone;
  String? erroDataNascimento;
  String? erroEmail;
  String? erroSenha;
  String? erroConfirmaSenha;

  bool isLoading = false;

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
        return Colors.black;
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
        erroNome = null;
      } else {
        nomeEstado = EstadoCampo.invalido;
        erroNome = 'Nome Inválido';
      }
    });
  }

  void validarData(DateTime data) {
    setState(() {
      final hoje = DateTime.now();

      // não pode ser no futuro
      if (data.isAfter(hoje)) {
        dataEstado = EstadoCampo.invalido;
        erroDataNascimento = 'Data no futuro';
        return;
      }

      // se chegou aqui, é válida
      dataEstado = EstadoCampo.valido;
      erroDataNascimento = null;
    });
  }

  void validarTelefone() {
    setState(() {
      if (telefoneValido(telefoneController.text)) {
        telefoneEstado = EstadoCampo.valido;
        erroTelefone = null;
      } else {
        telefoneEstado = EstadoCampo.invalido;
        erroTelefone = 'Número Inválido';
      }
    });
  }

  void validarEmail() {
    setState(() {
      if (emailValido(emailController.text)) {
        emailEstado = EstadoCampo.valido;
        erroEmail = null;
      } else {
        emailEstado = EstadoCampo.invalido;
        erroEmail = 'Email Inválido';
      }
    });
  }

  void validarSenha() {
    setState(() {
      if (senhaController.text.length >= 8) {
        senhaEstado = EstadoCampo.valido;
        erroSenha = null;
      } else {
        senhaEstado = EstadoCampo.invalido;
        erroSenha = 'Senha muito curta';
      }
    });
  }

  void validarConfirmaSenha() {
    setState(() {
      if (senhaController.text == senhaConfirmaController.text) {
        confirmaSenhaEstado = EstadoCampo.valido;
        erroConfirmaSenha = null;
      } else {
        confirmaSenhaEstado = EstadoCampo.invalido;
        erroConfirmaSenha = 'Senhas não coincidem';
      }
    });
  }

  bool confirmaDados() {
    if (nomeEstado == EstadoCampo.valido &&
        emailEstado == EstadoCampo.valido &&
        senhaEstado == EstadoCampo.valido &&
        confirmaSenhaEstado == EstadoCampo.valido &&
        telefoneEstado == EstadoCampo.valido &&
        dataEstado == EstadoCampo.valido) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro",
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 1.5,
            color: Colors.black,
          ),
        ),
        centerTitle: true,

        backgroundColor: AppColors.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mensagemCadastro,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: nomeController,
              onChanged: (_) => validarNome(),
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                errorText: erroNome,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(nomeEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(nomeEstado),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
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
                    erroDataNascimento = 'Data Vazia';
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
                errorText: erroDataNascimento,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(dataEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(dataEstado),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: telefoneController,
              onChanged: (_) => validarTelefone(),
              decoration: InputDecoration(
                labelText: 'Telefone (DDD e Número)',
                errorText: erroTelefone,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(telefoneEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(telefoneEstado),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              onChanged: (_) => validarEmail(),
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: erroEmail,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(emailEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(emailEstado),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: senhaController,
              onChanged: (_) => {validarSenha(), validarConfirmaSenha()},
              decoration: InputDecoration(
                labelText: 'Senha',
                errorText: erroSenha,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: corDoCampo(senhaEstado)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: corDoCampo(senhaEstado),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
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
                errorText: erroConfirmaSenha,
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
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                        mensagemCadastro = 'Cadastrando...';
                      });
                      if (confirmaDados()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: senhaController.text,
                              );

                          String uid = userCredential.user!.uid;

                          await FirebaseFirestore.instance
                              .collection('clientes')
                              .doc(uid)
                              .set({
                                'nome': nomeController.text,
                                'email': emailController.text,
                                'dataNascimento': dataNascimentoController.text,
                                'telefone': telefoneController.text,
                              });

                          if (!mounted) return;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: const Text('Sucesso'),
                              content: const Text(
                                'Cadastro realizado com sucesso!',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            setState(() {
                              erroEmail = 'Email já cadastrado.';
                            });
                          } else {
                            print('Erro: ${e.code}');
                          }
                        } finally {
                          setState(() {
                            isLoading = false;
                            mensagemCadastro = '';
                          });
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                          mensagemCadastro = '';
                        });
                      }
                    },
              child: const Text(
                'Criar Conta',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
