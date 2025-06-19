class ProfilUserMutations {
  static const String updateFoto = """
    mutation UpdateUserProfil(
      \$id_user: Int!, 
      \$profil: String!
    ) {
      updateUserProfil(
        id_user: \$id_user, 
        profil: \$profil
      ) {
        id_user
        profil
      }
    }
  """;
  static const String updateNama = """
    mutation UpdateUser(
      \$id_user: Int!, 
      \$nama: String
    ) {
      updateUser(
        id_user: \$id_user, 
        nama: \$nama
      ) {
        id_user
        nama
      }
    }
  """;
  static const String updateTelepon = """
    mutation UpdateUser(
      \$id_user: Int!, 
      \$telepon: String
    ) {
      updateUser(
        id_user: \$id_user, 
        telepon: \$telepon
      ) {
        id_user
        telepon
      }
    }
  """;
  static const String updatePassword = """
    mutation UpdateUser(
      \$id_user: Int!, 
      \$password: String,
      \$old_password: String
    ) {
      updateUser(
        id_user: \$id_user, 
        password: \$password,
        old_password: \$old_password
      ) {
        id_user
      }
    }
  """;
}