import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/propietario_dto.dart';
import '../models/automovil_dto.dart';
import '../models/seguro_dto.dart';
import '../models/poliza.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:9090/bdd_dto/api';

  // Headers por defecto
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // PROPIETARIOS
  Future<PropietarioDTO> crearPropietario(PropietarioDTO propietario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/propietarios'),
      headers: _headers,
      body: jsonEncode(propietario.toJson()),
    );

    if (response.statusCode == 201) {
      return PropietarioDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear propietario: ${response.body}');
    }
  }

  Future<List<PropietarioDTO>> obtenerTodosPropietarios() async {
    final response = await http.get(
      Uri.parse('$baseUrl/propietarios'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => PropietarioDTO.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener propietarios: ${response.body}');
    }
  }

  Future<PropietarioDTO> obtenerPropietarioPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/propietarios/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return PropietarioDTO.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Propietario no encontrado');
    } else {
      throw Exception('Error al obtener propietario: ${response.body}');
    }
  }

  Future<PropietarioDTO> actualizarPropietario(int id, PropietarioDTO propietario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/propietarios/$id'),
      headers: _headers,
      body: jsonEncode(propietario.toJson()),
    );

    if (response.statusCode == 200) {
      return PropietarioDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar propietario: ${response.body}');
    }
  }

  Future<void> eliminarPropietario(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/propietarios/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar propietario: ${response.body}');
    }
  }

  // AUTOMÓVILES
  Future<AutomovilDTO> crearAutomovil(AutomovilDTO automovil) async {
    final response = await http.post(
      Uri.parse('$baseUrl/automoviles'),
      headers: _headers,
      body: jsonEncode(automovil.toJson()),
    );

    if (response.statusCode == 201) {
      return AutomovilDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear automóvil: ${response.body}');
    }
  }

  Future<List<AutomovilDTO>> obtenerTodosAutomoviles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/automoviles'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AutomovilDTO.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener automóviles: ${response.body}');
    }
  }

  Future<AutomovilDTO> obtenerAutomovilPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/automoviles/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return AutomovilDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener automóvil: ${response.body}');
    }
  }

  // SEGUROS
  Future<SeguroDTO> obtenerSeguroPorAutomovilId(int automovilId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/seguros/automovil/$automovilId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return SeguroDTO.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Seguro no encontrado para este automóvil');
    } else {
      throw Exception('Error al obtener seguro: ${response.body}');
    }
  }

  Future<SeguroDTO> recalcularSeguro(int automovilId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/seguros/recalcular/$automovilId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return SeguroDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al recalcular seguro: ${response.body}');
    }
  }

  // PÓLIZAS
  Future<PolizaResponse> crearPolizaCompleta(PolizaRequest polizaRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/poliza'),
      headers: _headers,
      body: jsonEncode(polizaRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return PolizaResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear póliza: ${response.body}');
    }
  }

  Future<PolizaResponse> obtenerPolizaPorNombre(String nombre) async {
    final response = await http.get(
      Uri.parse('$baseUrl/poliza/usuario?nombre=${Uri.encodeComponent(nombre)}'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return PolizaResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('No se encontró póliza para este usuario');
    } else {
      throw Exception('Error al obtener póliza: ${response.body}');
    }
  }
}
