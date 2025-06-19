// ignore: file_names
class ProfilUserQueries {
  static const String getById = """
    query GetUserById(\$id_user: Int) {
      usersbyid(id_user: \$id_user) {
        id_user
        nama
        email
        telepon
        profil
      }
    }
  """;
}