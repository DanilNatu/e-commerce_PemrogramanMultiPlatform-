class RegisterMutationPenjual {
  static const String register = """
    mutation CreatePenjual(
      \$nama: String!,
      \$email: String!, 
      \$password: String!,
      \$telepon: String
    ) {
      createPenjual(
        nama: \$nama,
        email: \$email, 
        password: \$password,
        telepon: \$telepon
      ) {
        id_penjual
        nama
        email
        password
        telepon
      }
    }
  """;
}
