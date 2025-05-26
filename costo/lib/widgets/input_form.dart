import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_widget.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> with TickerProviderStateMixin {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController usesController = TextEditingController();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode usesFocusNode = FocusNode();
  
  String? costPerUse;
  final _formKey = GlobalKey<FormState>();
  bool _isCalculating = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void handleSubmit() async {
    // Ocultar teclado
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCalculating = true;
      });

      // Pequeña pausa para mostrar el loading
      await Future.delayed(const Duration(milliseconds: 500));

      final price = double.parse(priceController.text);
      final uses = int.parse(usesController.text);

      final cost = price / uses;
      
      setState(() {
        costPerUse = cost.toStringAsFixed(2);
        _isCalculating = false;
      });

      // Vibración háptica
      HapticFeedback.lightImpact();
      _animationController.forward().then((_) => _animationController.reverse());
    }
  }

  void _clearForm() {
    priceController.clear();
    usesController.clear();
    setState(() {
      costPerUse = null;
    });
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    priceController.dispose();
    usesController.dispose();
    priceFocusNode.dispose();
    usesFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de precio
          _CustomTextField(
            controller: priceController,
            focusNode: priceFocusNode,
            label: 'Precio del producto',
            hintText: 'Ej: 100.00',
            prefixIcon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final price = double.tryParse(value ?? '');
              if (price == null || price <= 0) {
                return 'Ingresa un precio válido mayor que 0';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(usesFocusNode);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Campo de usos
          _CustomTextField(
            controller: usesController,
            focusNode: usesFocusNode,
            label: 'Número de usos',
            hintText: 'Ej: 50',
            prefixIcon: Icons.repeat,
            keyboardType: TextInputType.number,
            validator: (value) {
              final uses = int.tryParse(value ?? '');
              if (uses == null || uses <= 0) {
                return 'Ingresa un número de usos válido mayor que 0';
              }
              return null;
            },
            onFieldSubmitted: (_) => handleSubmit(),
          ),
          
          const SizedBox(height: 24),
          
          // Botones de acción
          Row(
            children: [
              // Botón limpiar
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: costPerUse != null || 
                           priceController.text.isNotEmpty || 
                           usesController.text.isNotEmpty
                      ? _clearForm
                      : null,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Limpiar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Botón calcular
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animationController.value * 0.05),
                      child: ElevatedButton.icon(
                        onPressed: _isCalculating ? null : handleSubmit,
                        icon: _isCalculating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.calculate),
                        label: Text(_isCalculating ? 'Calculando...' : 'Calcular'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Resultado con animación
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticOut,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: costPerUse != null
                ? Padding(
                    key: ValueKey(costPerUse),
                    padding: const EdgeInsets.only(top: 24),
                    child: ResultWidget(costPerUse: costPerUse!),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Campo de texto personalizado con diseño móvil
class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final void Function(String)? onFieldSubmitted;

  const _CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.validator,
    this.onFieldSubmitted,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _isFocused ? Colors.blue : Colors.black87,
            ),
          ),
        ),
        
        // Campo de texto
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isFocused ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused ? Colors.blue : Colors.grey[600],
                size: 20,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}