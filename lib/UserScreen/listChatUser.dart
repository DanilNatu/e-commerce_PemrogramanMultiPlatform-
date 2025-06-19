import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/UserScreen/chatUser.dart';
import 'package:project2/graphql/query/chat/chat_query.dart';

class ListChatUserScreen extends StatefulWidget {
  final int idUser;
  const ListChatUserScreen({super.key, required this.idUser});

  @override
  State<ListChatUserScreen> createState() => _ListChatUserScreenState();
}

class _ListChatUserScreenState extends State<ListChatUserScreen> {
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

          final filteredChats = chats.where((c) => c['id_user'] == widget.idUser).toList();

          final Map<int, Map<String, dynamic>> penjualMap = {};
          for (var chat in filteredChats.reversed) {
            final penjualData = chat['penjual'];
            int idPenjual = penjualData['id_penjual'];
            String sender = chat['sender'];
            bool isRead = chat['is_read'] == true;

            if (!penjualMap.containsKey(idPenjual)) {
              penjualMap[idPenjual] = {
                'id_penjual': idPenjual,
                'nama': penjualData['nama'],
                'profil': penjualData['profil'],
                'last_message': chat['chat'],
                'unread': 0,
              };
            }

            if (sender == "penjual" && !isRead) {
              penjualMap[idPenjual]!['unread'] += 1;
            }
          }


          final penjualList = penjualMap.values.toList();

          if (penjualList.isEmpty) {
            return const Center(child: Text("Belum ada chat."));
          }

          return ListView.builder(
            itemCount: penjualList.length,
            itemBuilder: (context, index) {
              final penjual = penjualList[index];
              final String profil = penjual['profil'] ?? '';
              final int unreadCount = penjual['unread'] ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatUserScreen(
                          idUser: widget.idUser,
                          idPenjual: penjual['id_penjual'],
                        ),
                      ),
                    );

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
                            padding: const EdgeInsets.symmetric(horizontal: 17),
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
                                    penjual['nama'],
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
                                    penjual['last_message'] ?? '',
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
