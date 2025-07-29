class SeguroDTO {
  final int? id;
  final double costoTotal;
  final int automovilId;

  SeguroDTO({
    this.id,
    required this.costoTotal,
    required this.automovilId,
  });

  factory SeguroDTO.fromJson(Map<String, dynamic> json) {
    return SeguroDTO(
      id: json['id'],
      costoTotal: json['costoTotal'].toDouble(),
      automovilId: json['automovilId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'costoTotal': costoTotal,
      'automovilId': automovilId,
    };
  }
}
