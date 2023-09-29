class OutcomeModel {
  final int? outcomeId;
  final String keterangan;
  final int nominal;
  final DateTime tanggal;

  OutcomeModel({
    this.outcomeId,
    required this.keterangan,
    required this.nominal,
    required this.tanggal,
  });

  factory OutcomeModel.fromMap(Map<String, dynamic> json) => OutcomeModel(
        outcomeId: json["outcomeId"],
        keterangan: json["keterangan"],
        nominal: json["nominal"],
        tanggal: json["tanggal"],
      );

  Map<String, dynamic> toMap() => {
        "outcomeId": outcomeId,
        "keterangan": keterangan,
        "nominal": nominal,
        "tanggal": tanggal,
      };
}
