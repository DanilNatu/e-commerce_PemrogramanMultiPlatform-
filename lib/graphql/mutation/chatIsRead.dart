class ChatMutation {
  static const String markChatAsRead = """
    mutation MarkChatAsRead(
      \$id_user: Int!,
      \$id_penjual: Int!,
      \$role: String!
    ) {
      markChatAsRead(
        id_user: \$id_user,
        id_penjual: \$id_penjual,
        role: \$role)
    }
  """;
}
