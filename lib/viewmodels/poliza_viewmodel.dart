import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/poliza.dart';
import '../models/propietario_dto.dart';

class PolizaViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  PolizaResponse? _currentPoliza;
  List<PropietarioDTO> _propietarios = [];

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

    try {
      final polizaRequest = PolizaRequest(
        propietario: propietario,
        valorSeguroAuto: valorSeguroAuto,
        modeloAuto: modeloAuto,
        accidentes: accidentes,
        edadPropietario: edadPropietario,
      );

      _currentPoliza = await _apiService.crearPolizaCompleta(polizaRequest);
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

    try {
      _currentPoliza = await _apiService.obtenerPolizaPorNombre(nombre);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'No se encontró póliza para el usuario: $nombre';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> cargarPropietarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _propietarios = await _apiService.obtenerTodosPropietarios();
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
}
