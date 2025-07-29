import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import 'poliza_result_screen.dart';

class PolizaFormScreen extends StatefulWidget {
  const PolizaFormScreen({super.key});

  @override
  State<PolizaFormScreen> createState() => _PolizaFormScreenState();
}

class _PolizaFormScreenState extends State<PolizaFormScreen> {
  final TextEditingController _propietarioController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _accidentesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _propietarioController.dispose();
    _valorController.dispose();
    _modeloController.dispose();
    _edadController.dispose();
    _accidentesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Póliza'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PolizaViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.assignment,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Complete los datos para crear la póliza',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const ValueKey('propietario_field'),
                    controller: _propietarioController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Propietario',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: Juan Pérez',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre del propietario es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('edad_field'),
                    controller: _edadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Edad del Propietario',
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 30',
                      suffixText: 'años',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La edad es obligatoria';
                      }
                      final edad = int.tryParse(value);
                      if (edad == null) {
                        return 'Ingrese una edad válida';
                      }
                      if (edad < 18) {
                        return 'La edad debe ser mayor a 18 años';
                      }
                      if (edad > 100) {
                        return 'Ingrese una edad válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('modelo_field'),
                    controller: _modeloController,
                    decoration: const InputDecoration(
                      labelText: 'Modelo del Automóvil',
                      prefixIcon: Icon(Icons.directions_car),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: Toyota Corolla',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El modelo del automóvil es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('valor_field'),
                    controller: _valorController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Valor del Automóvil',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 25000',
                      suffixText: 'USD',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El valor del automóvil es obligatorio';
                      }
                      final valor = double.tryParse(value);
                      if (valor == null) {
                        return 'Ingrese un valor válido';
                      }
                      if (valor <= 0) {
                        return 'El valor debe ser mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('accidentes_field'),
                    controller: _accidentesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número de Accidentes',
                      prefixIcon: Icon(Icons.warning),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 0',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El número de accidentes es obligatorio';
                      }
                      final accidentes = int.tryParse(value);
                      if (accidentes == null) {
                        return 'Ingrese un número válido';
                      }
                      if (accidentes < 0) {
                        return 'El número de accidentes no puede ser negativo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      key: const ValueKey('create_poliza_submit_button'),
                      onPressed: viewModel.isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Crear Póliza',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    key: const ValueKey('clear_form_button'),
                    onPressed: _clearForm,
                    child: const Text('Limpiar Formulario'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<PolizaViewModel>();

      final success = await viewModel.crearPoliza(
        propietario: _propietarioController.text.trim(),
        valorSeguroAuto: double.parse(_valorController.text),
        modeloAuto: _modeloController.text.trim(),
        accidentes: int.parse(_accidentesController.text),
        edadPropietario: int.parse(_edadController.text),
      );

      if (success && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PolizaResultScreen(),
          ),
        );
      }
    }
  }

  void _clearForm() {
    _propietarioController.clear();
    _valorController.clear();
    _modeloController.clear();
    _edadController.clear();
    _accidentesController.clear();

    final viewModel = context.read<PolizaViewModel>();
    viewModel.clearError();
    viewModel.clearCurrentPoliza();
  }
}
