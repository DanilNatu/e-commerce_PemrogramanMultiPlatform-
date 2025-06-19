class ProfilPenjualMutations {
  static const String updateFoto = """
    mutation UpdatePenjualProfil(
      \$id_penjual: Int!, 
      \$profil: String!
    ) {
      updatePenjualProfil(
        id_penjual: \$id_penjual, 
        profil: \$profil
      ) {
        id_penjual
        nama
        email
        telepon
        profil
      }
    }
  """;
  static const String updateNama = """
    mutation UpdatePenjual(
      \$id_penjual: Int!, 
      \$nama: String
    ) {
      updatePenjual(
        id_penjual: \$id_penjual,
        nama: \$nama
      ) {
        id_penjual
        nama
      }
    }
  """;
  static const String updateTelepon = """
    mutation UpdatePenjual(
      \$id_penjual: Int!,
      \$telepon: String
    ) {
      updatePenjual(
        id_penjual: \$id_penjual,
        telepon: \$telepon
      ) {
        id_penjual
        telepon
      }
    }
  """;
  static const String updatePassword = """
    mutation UpdatePenjual(
      \$id_penjual: Int!,
      \$password: String,
      \$old_password: String
    ) {
      updatePenjual(
        id_penjual: \$id_penjual,
        password: \$password,
        old_password: \$old_password
      ) {
        id_penjual
      }
    }
  """;
}
