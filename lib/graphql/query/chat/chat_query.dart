class ChatQueries {
  static const String getChatQuery = """
  query GetChat(
    \$id_user: Int!,
    \$id_penjual: Int!
  ) {
    chatsByUserPenjual(
      id_user: \$id_user,
      id_penjual: \$id_penjual
    ) {
      id_chat
      id_user
      id_penjual
      chat
      sender
      is_read
      created_at
    }
  }
  """;

  static const String getAllChats = """
  query {
    chats {
      id_chat
      id_user
      id_penjual
      chat
      sender
      is_read
      created_at
      user {
        id_user
        nama
        profil
      }
      penjual {
        id_penjual
        nama
        profil
      }
    }
  }
  """;
    static const String countUnreadChatByUser = """
  query CountUnreadChatByUser(\$id_user: Int!) {
    countUnreadChatByUser(id_user: \$id_user)
  }
  """;

  static const String countUnreadChatByPenjual = """
  query CountUnreadChatByPenjual(\$id_penjual: Int!) {
    countUnreadChatByPenjual(id_penjual: \$id_penjual)
  }
  """;

}
