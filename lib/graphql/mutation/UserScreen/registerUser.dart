class RegisterMutationUser {
  static const String register = """
    mutation CreateUser(
      \$nama: String!,
      \$email: String!, 
      \$password: String!,
      \$telepon:String,
    ) {
      createUser(
        nama: \$nama,
        email: \$email, 
        password: \$password,
        telepon: \$telepon
      ) {
        id_user
        nama
        email
        password
        telepon
      }
    }
  """;
}