import 'package:flutter/material.dart';
import '../models/poliza.dart';
import '../models/propietario_dto.dart';

class FakePolizaViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  PolizaResponse? _currentPoliza;
  List<PropietarioDTO> _propietarios = [];

  // Datos simulados para las pruebas
  final List<PropietarioDTO> _mockPropietarios = [
    PropietarioDTO(
      id: 1,
      nombreCompleto: 'Juan Pérez',
      edad: 30,
      automovilIds: [1],
    ),
    PropietarioDTO(
      id: 2,
      nombreCompleto: 'María García',
      edad: 25,
      automovilIds: [2],
    ),
    PropietarioDTO(
      id: 3,
      nombreCompleto: 'Carlos López',
      edad: 35,
      automovilIds: [3],
    ),
  ];

  final Map<String, PolizaResponse> _mockPolizas = {
    'Juan Pérez': PolizaResponse(
      propietario: 'Juan Pérez',
      modeloAuto: 'Toyota Corolla',
      valorSeguroAuto: 25000.0,
      edadPropietario: 30,
      accidentes: 0,
      costoTotal: 2500.0,
    ),
    'María García': PolizaResponse(
      propietario: 'María García',
      modeloAuto: 'Honda Civic',
      valorSeguroAuto: 20000.0,
      edadPropietario: 25,
      accidentes: 1,
      costoTotal: 2400.0,
    ),
  };

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PolizaResponse? get currentPoliza => _currentPoliza;
  List<PropietarioDTO> get propietarios => _propietarios;

  Future<bool> crearPoliza({
    required String propietario,
    required double valorSeguroAuto,
    required String modeloAuto,
    required int accidentes,
    required int edadPropietario,
  }) async {
    // Validaciones
    if (propietario.isEmpty) {
      _errorMessage = 'El nombre del propietario es obligatorio';
      notifyListeners();
      return false;
    }

    if (valorSeguroAuto <= 0) {
      _errorMessage = 'El valor del seguro debe ser mayor a 0';
      notifyListeners();
      return false;
    }

    if (modeloAuto.isEmpty) {
      _errorMessage = 'El modelo del automóvil es obligatorio';
      notifyListeners();
      return false;
    }

    if (edadPropietario < 18) {
      _errorMessage = 'La edad del propietario debe ser mayor a 18 años';
      notifyListeners();
      return false;
    }

    if (accidentes < 0) {
      _errorMessage = 'El número de accidentes no puede ser negativo';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Calcular costo simulado basado en reglas de negocio
      double costoBase = valorSeguroAuto * 0.1; // 10% del valor del auto

      // Ajustes por edad
      if (edadPropietario < 25) {
        costoBase *= 1.2; // 20% más caro para menores de 25
      } else if (edadPropietario > 60) {
        costoBase *= 1.1; // 10% más caro para mayores de 60
      }

      // Ajustes por accidentes
      costoBase += (accidentes * 200); // $200 por cada accidente

      _currentPoliza = PolizaResponse(
        propietario: propietario,
        modeloAuto: modeloAuto,
        valorSeguroAuto: valorSeguroAuto,
        edadPropietario: edadPropietario,
        accidentes: accidentes,
        costoTotal: costoBase,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear póliza: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> buscarPolizaPorNombre(String nombre) async {
    if (nombre.isEmpty) {
      _errorMessage = 'El nombre es obligatorio para la búsqueda';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (_mockPolizas.containsKey(nombre)) {
        _currentPoliza = _mockPolizas[nombre];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'No se encontró póliza para el usuario: $nombre';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al buscar póliza: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarPropietarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      _propietarios = List.from(_mockPropietarios);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar propietarios: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCurrentPoliza() {
    _currentPoliza = null;
    notifyListeners();
  }

  // Métodos específicos para testing
  void setMockError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void setMockPoliza(PolizaResponse poliza) {
    _currentPoliza = poliza;
    notifyListeners();
  }

  void addMockPropietario(PropietarioDTO propietario) {
    _mockPropietarios.add(propietario);
  }
}
