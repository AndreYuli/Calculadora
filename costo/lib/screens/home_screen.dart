import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/input_form.dart';

/// Página principal de la calculadora de costo por uso.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Si la pantalla es menor a 900px, mostrar en columna
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  const _HeaderSection(),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _ContentSection(isNarrow: true),
                  ),
                ],
              );
            }
            // En pantallas grandes, mostrar en fila
            return Column(
              children: const [
                _HeaderSection(),
                SizedBox(height: 40),
                _ContentSection(isNarrow: false),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Sección superior: título, subtítulo y características.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenido textual del header
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GradientTitle(),
              const SizedBox(height: 8),
              const Text(
                'Descubre el valor real de tus compras analizando su costo por cada uso',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              // Características
              Row(
                children: const [
                  _Feature(
                    icon: 'assets/icon-smile.svg',
                    label: 'Fácil de usar',
                  ),
                  SizedBox(width: 16),
                  _Feature(
                    icon: 'assets/icon-precision.svg',
                    label: 'Cálculos precisos',
                  ),
                  SizedBox(width: 16),
                  _Feature(
                    icon: 'assets/icon-intelligence.svg',
                    label: 'Decisiones inteligentes',
                  ),
                ],
              ),
            ],
          ),
        ),
        // Gráfico decorativo
        Container(
          margin: const EdgeInsets.only(left: 24),
          child: const _CalculatorGraphic(),
        ),
      ],
    );
  }
}

/// Título con gradiente para la palabra "Calculadora".
class _GradientTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          WidgetSpan(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ).createShader(bounds);
              },
              child: const Text(
                'Calculadora ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const TextSpan(text: 'de Costo por Uso'),
        ],
      ),
    );
  }
}

/// Widget para mostrar una característica con ícono y texto.
class _Feature extends StatelessWidget {
  final String icon;
  final String label;

  const _Feature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 32, height: 32),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

/// Gráfico decorativo tipo calculadora.
class _CalculatorGraphic extends StatelessWidget {
  const _CalculatorGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[50],
      ),
      child: const Center(
        child: Text(
          '\$',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }
}

/// Sección inferior: explicación y formulario.
class _ContentSection extends StatelessWidget {
  final bool isNarrow;

  const _ContentSection({this.isNarrow = false});

  @override
  Widget build(BuildContext context) {
    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Explicación
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Cómo funciona?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta herramienta te ayuda a calcular el costo real de un producto dividiendo su precio entre el número de veces que planeas usarlo. Es ideal para evaluar si una compra, como un gadget o una prenda, realmente vale la pena.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simplemente ingresa el precio del producto y el número de usos esperados, y obtendrás el costo por uso.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Ejemplo visual
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Text('Ejemplo:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('Zapatos de \$100'),
                      SizedBox(width: 8),
                      Text('÷'),
                      SizedBox(width: 8),
                      Text('50 usos'),
                      SizedBox(width: 8),
                      Text('='),
                      SizedBox(width: 8),
                      Text('\$2 por uso', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Formulario
          InputForm(), // sin const si no tiene constructor constante
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Cómo funciona?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta herramienta te ayuda a calcular el costo real de un producto dividiendo su precio entre el número de veces que planeas usarlo. Es ideal para evaluar si una compra, como un gadget o una prenda, realmente vale la pena.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Simplemente ingresa el precio del producto y el número de usos esperados, y obtendrás el costo por uso.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      Text('Ejemplo:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('Zapatos de \$100'),
                      SizedBox(width: 8),
                      Text('÷'),
                      SizedBox(width: 8),
                      Text('50 usos'),
                      SizedBox(width: 8),
                      Text('='),
                      SizedBox(width: 8),
                      Text('\$2 por uso', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: InputForm(), // sin const si no tiene constructor const
          ),
        ),
      ],
    );
  }
}
