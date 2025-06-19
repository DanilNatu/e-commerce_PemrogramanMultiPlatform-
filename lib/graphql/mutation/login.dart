class LoginMutation {
  static const String login = """
    mutation Login(
      \$email: String!, 
      \$password: String!
    ) {
      login(
        email: \$email, 
        password: \$password
      ) {
        message
        role
        id_user
        id_penjual
        token
      }
    }
  """;
}
