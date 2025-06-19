import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/AdminScreen/ChatPenjual.dart';
import 'package:project2/graphql/query/chat/chat_query.dart';

class ListChatPenjualScreen extends StatefulWidget {
  final int idPenjual;
  const ListChatPenjualScreen({super.key, required this.idPenjual});

  @override
  State<ListChatPenjualScreen> createState() => _ListChatPenjualScreenState();
}

class _ListChatPenjualScreenState extends State<ListChatPenjualScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(ChatQueries.getAllChats),
          pollInterval: const Duration(seconds: 1),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception}"));
          }

          final List chats = result.data?['chats'] ?? [];

          // Ambil hanya chat milik penjual ini
          final filteredChats = chats.where((c) => c['id_penjual'] == widget.idPenjual).toList();

          // Group by user dan hitung jumlah pesan belum dibaca
          final Map<int, Map<String, dynamic>> userMap = {};
          for (var chat in filteredChats.reversed) {
            final userData = chat['user'];
            int idUser = userData['id_user'];
            String sender = chat['sender'];
            bool isRead = chat['is_read'] == true;

            if (!userMap.containsKey(idUser)) {
              userMap[idUser] = {
                'id_user': idUser,
                'nama': userData['nama'],
                'profil': userData['profil'],
                'last_message': chat['chat'],
                'unread': 0,
              };
            }

            if (sender == "user" && !isRead) {
              userMap[idUser]!['unread'] += 1;
            }
          }

          final userList = userMap.values.toList();

          if (userList.isEmpty) {
            return const Center(child: Text("Belum ada chat."));
          }

          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              final String profil = user['profil'] ?? '';
              final int unreadCount = user['unread'] ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: GestureDetector(
                  onTap: () async {
                    final client = GraphQLProvider.of(context).value;

                    // 🔁 Kirim ke backend bahwa chat dari user ke penjual sudah dibaca
                    await client.mutate(MutationOptions(
                      document: gql("""
                        mutation MarkAsRead(\$id_user: Int!, \$id_penjual: Int!, \$role: String!) {
                          markChatAsRead(id_user: \$id_user, id_penjual: \$id_penjual, role: \$role)
                        }
                      """),
                      variables: {
                        "id_user": user['id_user'],
                        "id_penjual": widget.idPenjual,
                        "role": "penjual"
                      },
                    ));

                    // ⬇️ Navigasi ke halaman chat
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPenjualScreen(
                          idPenjual: widget.idPenjual,
                          idUser: user['id_user'],
                        ),
                      ),
                    );

                    // 🔁 Refresh query agar badge notifikasi ikut hilang
                    refetch?.call();
                  },

                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 222, 221, 221),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    // ignore: unrelated_type_equality_checks
                                    child: (profil != true && profil != '')
                                        ? Image.file(
                                            File(profil),
                                            fit: BoxFit.cover,
                                            height: 73,
                                            width: 73,
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 73,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 255,
                                  child: Text(
                                    user['nama'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 264,
                                  child: Text(
                                    user['last_message'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
