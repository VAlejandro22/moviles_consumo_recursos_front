import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';

class PolizaSearchScreen extends StatefulWidget {
  const PolizaSearchScreen({super.key});

  @override
  State<PolizaSearchScreen> createState() => _PolizaSearchScreenState();
}

class _PolizaSearchScreenState extends State<PolizaSearchScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Póliza'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
      ),
      body: Consumer<PolizaViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.search,
                    size: isSmallScreen ? 48 : 64,
                    color: Colors.orange,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Text(
                    'Buscar Póliza por Nombre',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      key: const ValueKey('search_nombre_field'),
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Propietario',
                        prefixIcon: Icon(Icons.person_search),
                        border: OutlineInputBorder(),
                        hintText: 'Ingrese el nombre a buscar',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio para la búsqueda';
                        }
                        return null;
                      },
                    ),
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
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    key: const ValueKey('search_poliza_button'),
                    onPressed: viewModel.isLoading ? null : _handleSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Buscar Póliza',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  if (viewModel.currentPoliza != null)
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: isSmallScreen ? 20 : 24,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Póliza Encontrada',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Propietario:', viewModel.currentPoliza!.propietario, isSmallScreen: isSmallScreen),
                            _buildDetailRow('Edad:', '${viewModel.currentPoliza!.edadPropietario} años', isSmallScreen: isSmallScreen),
                            _buildDetailRow('Modelo del Vehículo:', viewModel.currentPoliza!.modeloAuto, isSmallScreen: isSmallScreen),
                            _buildDetailRow('Valor del Vehículo:', '\$${viewModel.currentPoliza!.valorSeguroAuto.toStringAsFixed(2)}', isSmallScreen: isSmallScreen),
                            _buildDetailRow('Accidentes:', '${viewModel.currentPoliza!.accidentes}', isSmallScreen: isSmallScreen),
                            const Divider(thickness: 2),
                            _buildDetailRow(
                              'Costo Total:',
                              '\$${viewModel.currentPoliza!.costoTotal.toStringAsFixed(2)}',
                              isTotal: true,
                              isSmallScreen: isSmallScreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSearch() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<PolizaViewModel>();
      await viewModel.buscarPolizaPorNombre(_nombreController.text.trim());
    }
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false, bool isSmallScreen = false}) {
    final labelFontSize = isTotal ? (isSmallScreen ? 15.0 : 16.0) : (isSmallScreen ? 13.0 : 14.0);
    final valueFontSize = isTotal ? (isSmallScreen ? 15.0 : 16.0) : (isSmallScreen ? 13.0 : 14.0);
    final labelWidth = isSmallScreen ? 90.0 : 130.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: isSmallScreen && label.length > 15
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
