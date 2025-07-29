import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'poliza_form_screen.dart';
import 'poliza_search_screen.dart';
import 'propietarios_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Pólizas'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            key: const ValueKey('logout_button'),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final viewModel = context.read<LoginViewModel>();
              await viewModel.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Bienvenido al Sistema de Pólizas de Seguros',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Seleccione una opción para continuar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    key: const ValueKey('create_poliza_button'),
                    title: 'Crear Póliza',
                    subtitle: 'Registrar nueva póliza de seguro',
                    icon: Icons.add_circle,
                    color: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PolizaFormScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    key: const ValueKey('search_poliza_button'),
                    title: 'Buscar Póliza',
                    subtitle: 'Consultar póliza existente',
                    icon: Icons.search,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PolizaSearchScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    key: const ValueKey('propietarios_button'),
                    title: 'Propietarios',
                    subtitle: 'Ver lista de propietarios',
                    icon: Icons.people,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PropietariosScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    key: const ValueKey('about_button'),
                    title: 'Acerca de',
                    subtitle: 'Información del sistema',
                    icon: Icons.info,
                    color: Colors.teal,
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required ValueKey key,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      key: key,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca del Sistema'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sistema de Pólizas de Seguros'),
            SizedBox(height: 8),
            Text('Versión: 1.0.0'),
            SizedBox(height: 8),
            Text('Desarrollado con Flutter y arquitectura MVVM'),
            SizedBox(height: 8),
            Text('API REST: Spring Boot'),
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
}
