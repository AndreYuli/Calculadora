import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResultWidget extends StatelessWidget {
  final String costPerUse;

  const ResultWidget({super.key, required this.costPerUse});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => Icon(
                isError ? Icons.error : Icons.check_circle,
                color: isError ? Colors.red : Colors.green,
                size: 40,
              ),
            ),
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
                const SizedBox(height: 4),
                Text(
                  isError ? 'Por favor ingresa valores válidos.' : '\$${costPerUse}',
                  style: TextStyle(
                    fontSize: 16,
                    color: isError ? Colors.red[700] : Colors.black87,
                  ),
                ),
                if (!isError) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Este es el costo por cada uso del producto.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
