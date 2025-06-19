// ignore: file_names
class ProfilPenjualQueries {
  static const String getById = """
    query GetPenjualById(\$id_penjual: Int) {
      penjualsbyid(id_penjual: \$id_penjual) {
        id_penjual
        nama
        email
        telepon
        profil
      }
    }
  """;
}