class AlamatQueries {
  static const String getAll = """
    query{
      alamats{
        id_alamat
        id_user
        alamat
        teleponA
        namaA
        alamat_utama
      }
    }
  """;

  static const String getAlamatByUser = """
    query GetAlamat(\$id_alamat: Int) {
      alamats(id_alamat: \$id_alamat) {
        id_alamat
        namaA
        teleponA
        alamat
        alamat_utama
      }
    }
  """;
}