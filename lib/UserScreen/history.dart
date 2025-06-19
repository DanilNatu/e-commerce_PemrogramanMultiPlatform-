import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/detail.dart';
import 'package:project2/graphql/query/UserScreen/history.dart';

class HistoryScreen extends StatefulWidget {
  final int idUser;
  const HistoryScreen({super.key, required this.idUser});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  Widget _cardItems(Map item, VoidCallback refetch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                product: item['product'], 
                                idUser: widget.idUser, 
                                refetch: refetch,
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 8, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Detail Produk Pembelian',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Icon(
                                size: 17,
                                color: Color.fromARGB(255, 129, 129, 129),
                                Icons.arrow_forward_ios,
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 2),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                item['product']['deskripsi'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 140,
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    height: 140,
                    child: Center(
                      child: item['product']?['image'] != null 
                        ? Image.file(
                            File(item['product']['image']),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 120,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                          ),
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['product']?['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            [
                              item['product']['warna'],
                              if (item['sizeH'] != null && item['sizeH'] != '' && item['sizeH'] != 'null') item['sizeH']
                            ].join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 129, 128, 128)
                            )
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Text(
                                'Rp',
                                style: TextStyle(
                                  color: Color(0xFF7A8AD7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatter.format(item['product']['price'] * item['jumlah']).replaceAll('Rp', ''),
                                style: const TextStyle(
                                  color: Color(0xFF7A8AD7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '(x ${item['jumlah']})',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
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
          document: gql(HistoryQueries.getAll),
          variables: {"id_user": widget.idUser},
          pollInterval: const Duration(seconds: 5),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(
              child: Container(
                color: const Color.fromARGB(202, 0, 0, 0),
                padding: const EdgeInsets.all(8),
                child: Text("Gagal upload history: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
              )
            );
          }

          final List history = result.data?['historys'] ?? [];

          final List userHistorys = history.where((item) {
            return item['id_user'] == widget.idUser;
          }).toList();

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemCount: userHistorys.length,
            itemBuilder: (context, index) => _cardItems(userHistorys[index], refetch!),
          );
        }
      ),
    );
  }
}