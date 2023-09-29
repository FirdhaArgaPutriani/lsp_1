class IncomeModel {
  final String incomeId;
  final String keterangan;
  final int nominal;
  final DateTime tanggal;

  IncomeModel({
    required this.incomeId,
    required this.keterangan,
    required this.nominal,
    required this.tanggal,
  });

  factory IncomeModel.fromMap(Map<String, dynamic> json) => IncomeModel(
        incomeId: json["incomeId"],
        keterangan: json["keterangan"],
        nominal: json["nominal"],
        tanggal: json["tanggal"],
      );

  Map<String, dynamic> toMap() => {
        "incomeId": incomeId,
        "keterangan": keterangan,
        "nominal": nominal,
        "tanggal": tanggal,
      };
}
