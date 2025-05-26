import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

/// Widget principal de la aplicación.
/// Configura el tema y la pantalla inicial.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Costo por Uso',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Formulario para calcular el costo por uso.
/// Se recomienda mover este widget a un archivo separado si crece más.
class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController usesController = TextEditingController();
  String? costPerUse;

  /// Calcula el costo por uso y actualiza el estado.
  void handleSubmit() {
    final price = double.tryParse(priceController.text);
    final uses = int.tryParse(usesController.text);

    if (price != null && uses != null && uses > 0) {
      final cost = price / uses;
      setState(() {
        costPerUse = cost.toStringAsFixed(2);
      });
    } else {
      setState(() {
        costPerUse = 'Datos inválidos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo para el precio del producto
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio del producto',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Campo para el número de usos
          TextField(
            controller: usesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de usos',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          // Botón para calcular
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSubmit,
              child: const Text('Calcular'),
            ),
          ),
          // Resultado
          if (costPerUse != null) ...[
            const SizedBox(height: 24),
            Result(costPerUse: costPerUse!),
          ],
        ],
      ),
    );
  }
}

/// Widget para mostrar el resultado del cálculo.
/// Muestra un ícono y el mensaje correspondiente.
class Result extends StatelessWidget {
  final String costPerUse;
  const Result({super.key, required this.costPerUse});

  @override
  Widget build(BuildContext context) {
    final bool isError = costPerUse == 'Datos inválidos';
    final String iconPath = isError
        ? 'assets/icon-error.svg'
        : 'assets/icon-success.svg';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? Colors.red : Colors.green,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isError ? 'Error' : 'Resultado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isError ? Colors.red : Colors.green[800],
                  ),
                ),
                Text(
                  isError ? 'Datos inválidos' : '\$${costPerUse}',
                  style: const TextStyle(fontSize: 16),
                ),
                if (!isError)
                  const Text(
                    'Costo por cada uso del producto',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
