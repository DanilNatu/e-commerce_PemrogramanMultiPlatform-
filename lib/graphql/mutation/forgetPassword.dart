class ForgetPasswordMutation {
  static const String forgetPassword = """
    mutation ForgetPassword(
      \$email: String!, 
      \$new_password: String!
    ) {
      forgetPassword(
        email: \$email, 
        new_password: \$new_password
      ) {
        message
        role
      }
    }
  """;
}
