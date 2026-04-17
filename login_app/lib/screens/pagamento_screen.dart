import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

class PagamentoScreen extends StatefulWidget {
  const PagamentoScreen({super.key});

  @override
  State<PagamentoScreen> createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  // Variável para controlar o método selecionado
  String _metodoPagamento = 'pix';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantendo o fundo vermelho escuro do seu Login
      backgroundColor: const Color.fromARGB(255, 173, 17, 6),
      appBar: AppBar(
        title: const Text('Pagamento', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- ESPAÇO EM BRANCO (PLACEHOLDER DO FILME) ---
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Fundo quase branco
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_creation_outlined, size: 60, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    "Capa do Filme",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // --- OPÇÕES DE PAGAMENTO ---
            const Text(
              "SELECIONE A FORMA DE PAGAMENTO",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildRadioOption("Pix", "pix"),
                  _buildRadioOption("Cartão de Crédito", "cartao"),
                  _buildRadioOption("Cartão de Débito", "debito"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- VALOR TOTAL ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("TOTAL:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("R\$ 25,00", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- BOTÃO FINALIZAR (ESTILO DO SEU LOGIN) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Finalizando pagamento via $_metodoPagamento');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return const Color.fromARGB(255, 202, 200, 200);
                    }
                    return Colors.black; // Cor normal preta igual seu botão de login
                  }),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
                ),
                child: const Text('FINALIZAR PAGAMENTO', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            // --- BOTÃO CANCELAR ---
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para criar as opções de rádio personalizadas
  Widget _buildRadioOption(String title, String value) {
    return RadioListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _metodoPagamento,
      activeColor: Colors.black, // Cor do círculo quando selecionado
      onChanged: (String? newValue) {
        setState(() {
          _metodoPagamento = newValue!;
        });
      },
    );
  }
}