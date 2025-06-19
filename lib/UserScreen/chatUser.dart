import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/graphql/mutation/chatIsRead.dart';
import 'package:project2/graphql/query/AdminScreen/profilAdmin.dart';
import 'package:project2/graphql/query/chat/chat_query.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatUserScreen extends StatefulWidget {
  final int idUser;
  final int idPenjual;

  const ChatUserScreen({super.key, required this.idUser, required this.idPenjual});

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late WebSocketChannel channel;
  List<Map<String, dynamic>> messages = [];

  bool isFetching = false;
  String namaPenjual = '';
  String? fotoPenjual;

  @override
  void initState() {
    super.initState();
    connectWebSocket();

    Future.delayed(Duration.zero, () {
      final client = GraphQLProvider.of(context).value;
      client.mutate(
        MutationOptions(
          document: gql(ChatMutation.markChatAsRead),
          variables: {
            'id_user': widget.idUser,
            'id_penjual': widget.idPenjual,
            'role': 'user',
          },
        ),
      );
    });
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.9:8080/ws'),
    );

    channel.stream.listen(
      (data) {
        try {
          final decoded = jsonDecode(data);
          final chatData = decoded['data'] ?? decoded;

          print("📨 Realtime chat masuk: $chatData");

          addMessage({
            'id_user': int.tryParse(chatData['id_user'].toString()) ?? 0,
            'id_penjual': int.tryParse(chatData['id_penjual'].toString()) ?? 0,
            'chat': chatData['chat'].toString(),
            'sender': chatData['sender'].toString(),
            'created_at': chatData['created_at'],
          });
        } catch (e) {
          print("❌ WebSocket parsing error: $e");
        }
      },
      onDone: () {
        print("⚠️ WebSocket closed. Attempting reconnect...");
        reconnectWebSocket();
      },
      onError: (error) {
        print("❌ WebSocket error: $error");
        reconnectWebSocket();
      },
    );
  }

  void reconnectWebSocket() async {
    await Future.delayed(const Duration(seconds: 3));
    connectWebSocket();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isFetching) {
      isFetching = true;
      fetchPenjual();
      loadInitialMessages();
    }
  }

  Future<void> fetchPenjual() async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(
        document: gql(ProfilPenjualQueries.getById),
        variables: {"id_penjual": widget.idPenjual},
      ),
    );

    if (!result.hasException) {
      final data = result.data?['penjualsbyid'];
      setState(() {
        namaPenjual = data?["nama"] ?? '';
        fotoPenjual = data?["profil"] ?? '';
      });
    }
  }

  void addMessage(Map<String, dynamic> chatData) {
    setState(() {
      messages.insert(0, chatData);
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> loadInitialMessages() async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(
        document: gql(ChatQueries.getChatQuery),
        variables: {
          "id_user": widget.idUser,
          "id_penjual": widget.idPenjual,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      print("❌ GraphQL Error: ${result.exception.toString()}");
      return;
    }

    final List chatList = result.data?['chatsByUserPenjual'] ?? [];
    print("📦 Chat history: $chatList");

    setState(() {
      messages = chatList.map<Map<String, dynamic>>((e) => {
        'id_user': e['id_user'],
        'id_penjual': e['id_penjual'],
        'chat': e['chat'],
        'sender': e['sender'],
        'created_at': e['created_at'],
      }).toList().reversed.toList();
    });
    scrollToBottom();
  }
  

  void sendMessage() {
    if (textController.text.trim().isEmpty) return;

    final message = {
      "id_user": widget.idUser,
      "id_penjual": widget.idPenjual,
      "chat": textController.text.trim(),
      "sender": "user",
    };

    channel.sink.add(jsonEncode(message));
    textController.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget buildMessage(String message, bool isMe, String time) {
  return Align(
    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: isMe 
            ? const EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 10)
            : const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 50),
          decoration: BoxDecoration(
            color: isMe ? const Color.fromARGB(255, 123, 138, 215) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 18, color: isMe ? Colors.white : Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        )
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 222, 221, 221),
                shape: BoxShape.circle
              ),
              child: ClipOval(
                child: (fotoPenjual != null && fotoPenjual != '')
                  ? Image.file(
                      File(fotoPenjual!),
                      fit: BoxFit.cover,
                      height: 60,
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: 230,
                child: Text(
                  namaPenjual.isNotEmpty ? namaPenjual : 'Loading...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,  // jangan reverse, karena pakai sorting dari DB
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final chat = messages[index];
                  final isMe = chat['sender'] == "user";
                  final chatText = (chat['chat'] ?? '').toString();
                  final createdAtRaw = chat['created_at'];
                  final createdAt = DateTime.tryParse(createdAtRaw ?? '')?.toLocal();
                  final timeFormatted = createdAt != null
                      ? "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}"
                      : '';
                  return buildMessage(chatText, isMe, timeFormatted);
                },
              ),
            ),
            const SizedBox(height: 7)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, -1))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.start,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Tulis Pesan...',
                      fillColor: const Color.fromARGB(255, 224, 224, 224),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: sendMessage,
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 123, 138, 215),
                      foregroundColor: Colors.white,
                      child: Icon(Icons.send_rounded),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
