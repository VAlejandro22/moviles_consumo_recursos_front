import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import '../models/propietario_dto.dart';

class PropietariosScreen extends StatefulWidget {
  const PropietariosScreen({super.key});

  @override
  State<PropietariosScreen> createState() => _PropietariosScreenState();
}

class _PropietariosScreenState extends State<PropietariosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PolizaViewModel>().cargarPropietarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Propietarios'),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            key: const ValueKey('refresh_propietarios_button'),
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PolizaViewModel>().cargarPropietarios();
            },
          ),
        ],
      ),
      body: Consumer<PolizaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando propietarios...'),
                ],
              ),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.cargarPropietarios();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.propietarios.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay propietarios registrados',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people,
                      color: Colors.purple,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: ${viewModel.propietarios.length} propietarios',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.propietarios.length,
                  itemBuilder: (context, index) {
                    final propietario = viewModel.propietarios[index];
                    return _buildPropietarioCard(propietario, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPropietarioCard(PropietarioDTO propietario, int index) {
    return Card(
      key: ValueKey('propietario_card_$index'),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Text(
            propietario.nombreCompleto.isNotEmpty
                ? propietario.nombreCompleto[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: Colors.purple[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          propietario.nombreCompleto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Edad: ${propietario.edad} años',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (propietario.automovilIds != null && propietario.automovilIds!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${propietario.automovilIds!.length} auto${propietario.automovilIds!.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información Detallada:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('ID:', '${propietario.id ?? 'N/A'}'),
                _buildInfoRow('Nombre Completo:', propietario.nombreCompleto),
                _buildInfoRow('Edad:', '${propietario.edad} años'),
                _buildInfoRow(
                  'Automóviles:',
                  propietario.automovilIds != null && propietario.automovilIds!.isNotEmpty
                      ? propietario.automovilIds!.join(', ')
                      : 'Sin automóviles registrados',
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      key: ValueKey('buscar_poliza_${propietario.id}'),
                      onPressed: () => _buscarPolizaPropietario(propietario.nombreCompleto),
                      icon: const Icon(Icons.search),
                      label: const Text('Ver Póliza'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buscarPolizaPropietario(String nombre) async {
    final viewModel = context.read<PolizaViewModel>();

    // Mostrar diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Buscando póliza...'),
          ],
        ),
      ),
    );

    try {
      final success = await viewModel.buscarPolizaPorNombre(nombre);

      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga

        if (success) {
          _mostrarPolizaDialog(viewModel.currentPoliza!);
        } else {
          _mostrarErrorDialog('No se encontró póliza para $nombre');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
        _mostrarErrorDialog('Error al buscar póliza: $e');
      }
    }
  }

  void _mostrarPolizaDialog(poliza) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Póliza Encontrada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propietario: ${poliza.propietario}'),
            Text('Modelo: ${poliza.modeloAuto}'),
            Text('Valor: \$${poliza.valorSeguroAuto.toStringAsFixed(2)}'),
            Text('Edad: ${poliza.edadPropietario} años'),
            Text('Accidentes: ${poliza.accidentes}'),
            const Divider(),
            Text(
              'Costo Total: \$${poliza.costoTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarErrorDialog(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
