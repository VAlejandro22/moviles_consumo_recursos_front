class PropietarioDTO {
  final int? id;
  final String nombreCompleto;
  final int edad;
  final List<int>? automovilIds;

  PropietarioDTO({
    this.id,
    required this.nombreCompleto,
    required this.edad,
    this.automovilIds,
  });

  factory PropietarioDTO.fromJson(Map<String, dynamic> json) {
    return PropietarioDTO(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'],
      edad: json['edad'],
      automovilIds: json['automovilIds'] != null
          ? List<int>.from(json['automovilIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'edad': edad,
      'automovilIds': automovilIds,
    };
  }
}
