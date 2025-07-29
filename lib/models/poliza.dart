class PolizaRequest {
  final String propietario;
  final double valorSeguroAuto;
  final String modeloAuto;
  final int accidentes;
  final int edadPropietario;

  PolizaRequest({
    required this.propietario,
    required this.valorSeguroAuto,
    required this.modeloAuto,
    required this.accidentes,
    required this.edadPropietario,
  });

  Map<String, dynamic> toJson() {
    return {
      'propietario': propietario,
      'valorSeguroAuto': valorSeguroAuto,
      'modeloAuto': modeloAuto,
      'accidentes': accidentes,
      'edadPropietario': edadPropietario,
    };
  }
}

class PolizaResponse {
  final String propietario;
  final String modeloAuto;
  final double valorSeguroAuto;
  final int edadPropietario;
  final int accidentes;
  final double costoTotal;

  PolizaResponse({
    required this.propietario,
    required this.modeloAuto,
    required this.valorSeguroAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory PolizaResponse.fromJson(Map<String, dynamic> json) {
    return PolizaResponse(
      propietario: json['propietario'],
      modeloAuto: json['modeloAuto'],
      valorSeguroAuto: json['valorSeguroAuto'].toDouble(),
      edadPropietario: json['edadPropietario'],
      accidentes: json['accidentes'],
      costoTotal: json['costoTotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propietario': propietario,
      'modeloAuto': modeloAuto,
      'valorSeguroAuto': valorSeguroAuto,
      'edadPropietario': edadPropietario,
      'accidentes': accidentes,
      'costoTotal': costoTotal,
    };
  }
}
