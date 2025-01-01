class Lari {
  final String judul;
  final String hari;
  final String bulan;
  final String tahun;
  final String jarak;
  final String waktu;
  final String deskripsi;
  final String type;

  Lari({
    required this.judul,
    required this.hari,
    required this.bulan,
    required this.tahun,
    required this.jarak,
    required this.waktu,
    required this.deskripsi,
    required this.type,
  });

  factory Lari.fromJson(Map<String, dynamic> json) {
    return Lari(
      judul: json['judul'],
      hari: json['hari'],
      bulan: json['bulan'],
      tahun: json['tahun'],
      jarak: json['jarak'],
      waktu: json['waktu'],
      deskripsi: json['deskripsi'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'hari': hari,
      'bulan': bulan,
      'tahun': tahun,
      'jarak': jarak,
      'waktu': waktu,
      'deskripsi': deskripsi,
      'type': type,
    };
  }
}