import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';

class PolizaResultScreen extends StatelessWidget {
  const PolizaResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de la Póliza'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PolizaViewModel>(
        builder: (context, viewModel, child) {
          final poliza = viewModel.currentPoliza;

          if (poliza == null) {
            return const Center(
              child: Text(
                'No hay información de póliza disponible',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: isSmallScreen ? 60 : 80,
                    color: Colors.green,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Text(
                    '¡Póliza Creada Exitosamente!',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Detalles de la Póliza',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Propietario:', poliza.propietario, isSmallScreen: isSmallScreen),
                          _buildDetailRow('Edad:', '${poliza.edadPropietario} años', isSmallScreen: isSmallScreen),
                          _buildDetailRow('Modelo del Vehículo:', poliza.modeloAuto, isSmallScreen: isSmallScreen),
                          _buildDetailRow('Valor del Vehículo:', '\$${poliza.valorSeguroAuto.toStringAsFixed(2)}', isSmallScreen: isSmallScreen),
                          _buildDetailRow('Accidentes:', '${poliza.accidentes}', isSmallScreen: isSmallScreen),
                          const Divider(thickness: 2),
                          _buildDetailRow(
                            'Costo Total del Seguro:',
                            '\$${poliza.costoTotal.toStringAsFixed(2)}',
                            isTotal: true,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isSmallScreen
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const ValueKey('nueva_poliza_button'),
                              onPressed: () {
                                viewModel.clearCurrentPoliza();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Crear Nueva Póliza'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              key: const ValueKey('ir_inicio_button'),
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text('Ir al Inicio'),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              key: const ValueKey('nueva_poliza_button'),
                              onPressed: () {
                                viewModel.clearCurrentPoliza();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Crear Nueva Póliza'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              key: const ValueKey('ir_inicio_button'),
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              child: const Text('Ir al Inicio'),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false, bool isSmallScreen = false}) {
    final labelFontSize = isTotal ? (isSmallScreen ? 16.0 : 18.0) : (isSmallScreen ? 14.0 : 16.0);
    final valueFontSize = isTotal ? (isSmallScreen ? 16.0 : 18.0) : (isSmallScreen ? 14.0 : 16.0);
    final labelWidth = isSmallScreen ? 100.0 : 150.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: isSmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: labelFontSize,
                  color: isTotal ? Colors.green : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? Colors.green : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: labelFontSize,
                    color: isTotal ? Colors.green : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: isTotal ? Colors.green : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
    );
  }
}
