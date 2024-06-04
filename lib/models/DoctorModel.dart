class Doctor {
  final String id;
  final String alumni;
  final String deskripsi;
  final String imageUrl;
  final String lokasi;
  final String lokasiDetail;
  final String nama;
  final String pengalaman;
  final String posisi;
  final String price;
  final double rating;

  Doctor({
    required this.id,
    required this.alumni,
    required this.deskripsi,
    required this.imageUrl,
    required this.lokasi,
    required this.lokasiDetail,
    required this.nama,
    required this.pengalaman,
    required this.posisi,
    required this.price,
    required this.rating,
  });

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      alumni: map['alumni'],
      deskripsi: map['deskripsi'],
      imageUrl: map['imageUrl'],
      lokasi: map['lokasi'],
      lokasiDetail: map['lokasiDetail'],
      nama: map['nama'],
      pengalaman: map['pengalaman'],
      posisi: map['posisi'],
      price: map['price'],
      rating: map['rating'],
    );
  }
}

class AvailableDate {
  final String doctorId;
  final DateTime date;
  final List<String> slots;

  AvailableDate({
    required this.doctorId,
    required this.date,
    required this.slots,
  });

  factory AvailableDate.fromMap(Map<String, dynamic> map) {
    return AvailableDate(
      doctorId: map['doctor_id'],
      date: DateTime.parse(map['date']),
      slots: List<String>.from(map['slots']),
    );
  }
}