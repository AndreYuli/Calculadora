import 'package:flutter/material.dart';
import 'result_widget.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController usesController = TextEditingController();
  String? costPerUse;
  final _formKey = GlobalKey<FormState>();

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final price = double.parse(priceController.text);
      final uses = int.parse(usesController.text);

      final cost = price / uses;
      setState(() {
        costPerUse = cost.toStringAsFixed(2);
      });
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores
    priceController.dispose();
    usesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = double.tryParse(value ?? '');
                  if (price == null || price <= 0) {
                    return 'Ingresa un precio válido mayor que 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: usesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de usos',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final uses = int.tryParse(value ?? '');
                  if (uses == null || uses <= 0) {
                    return 'Ingresa un número de usos válido mayor que 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text('Calcular'),
                ),
              ),
              if (costPerUse != null) ...[
                const SizedBox(height: 24),
                ResultWidget(costPerUse: costPerUse!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
