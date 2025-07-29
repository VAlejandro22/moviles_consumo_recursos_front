class AutomovilDTO {
  final int? id;
  final String modelo;
  final double valor;
  final int accidentes;
  final int propietarioId;
  final String? propietarioNombreC;
  final double? costoSeguro;
  final int? seguroId;

  AutomovilDTO({
    this.id,
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
    this.propietarioNombreC,
    this.costoSeguro,
    this.seguroId,
  });

  factory AutomovilDTO.fromJson(Map<String, dynamic> json) {
    return AutomovilDTO(
      id: json['id'],
      modelo: json['modelo'],
      valor: json['valor'].toDouble(),
      accidentes: json['accidentes'],
      propietarioId: json['propietarioId'],
      propietarioNombreC: json['propietarioNombreC'],
      costoSeguro: json['costoSeguro']?.toDouble(),
      seguroId: json['seguroId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'valor': valor,
      'accidentes': accidentes,
      'propietarioId': propietarioId,
      'propietarioNombreC': propietarioNombreC,
      'costoSeguro': costoSeguro,
      'seguroId': seguroId,
    };
  }
}
