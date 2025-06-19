import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/checkout.dart';
import 'package:project2/graphql/mutation/UserScreen/checkout.dart';
import 'package:project2/graphql/mutation/UserScreen/keranjang.dart';
import 'package:project2/graphql/query/UserScreen/keranjang.dart';
import 'package:slide_to_act/slide_to_act.dart';

class KeranjangScreen extends StatefulWidget {
  final int idUser;
  const KeranjangScreen({super.key, required this.idUser});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  late Future<QueryResult<Object?>> Function()? refetchQuery;

  bool isEditMode = true;
  Map<int, bool> selectedMap = {}; // id_keranjang -> isSelected
  Map<int, int> jumlahMap = {}; // id_keranjang -> jumlah (local state)

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0
  );

  void toggleSelectAll(bool? value, List keranjangList) {
    setState(() {
      bool newValue = value ?? false;
      for (var item in keranjangList) {
        selectedMap[item['id_keranjang']] = newValue;
      }
    });
  }

  Future<void> updateJumlah(int idKeranjang, int newJumlah) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
        document: gql(KeranjangMutations.updateJumlah),
        variables: {
          "id_keranjang": idKeranjang,
          "jumlah": newJumlah
        },
      ),
    );
  }

  Future<void> deleteKeranjang(int idKeranjang) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
        document: gql(KeranjangMutations.delete),
        variables: {"id_keranjang": idKeranjang},
      ),
    );
  }

  Future<void> tambahkCheckout(List userKeranjang, VoidCallback refetch) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userKeranjang) {
      if (selectedMap[item['id_keranjang']] ?? false) {
        final result = await client.mutate(
          MutationOptions(
            document: gql(CheckoutMutations.create),
            variables: {
              "id_user": widget.idUser,
              "id_product": item['id_product'],  // tambahkan ID Product
              "id_keranjang": item['id_keranjang'],         // ambil ID Keranjang
              "jumlah": jumlahMap[item['id_keranjang']] ?? item['jumlah'],
            },
          ),
        );

        if (result.hasException) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              padding: const EdgeInsets.all(8),
              content: Text(
                "Gagal checkout product: ${result.exception.toString()}",
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(202, 0, 0, 0),
            ),
          );
          return;
        }
      }
    }

    refetch(); 

    setState(() => selectedMap.clear());
  }

  Widget buildCartItem(Map item) {
    int idKeranjang = item['id_keranjang'];
    int jumlah = jumlahMap[idKeranjang] ?? (item['jumlah'] as int);
    bool isSelected = selectedMap[idKeranjang] ?? false;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (bool? newValue) {
                setState(() {
                  selectedMap[idKeranjang] = newValue ?? false;
                });
              },
            ),
            SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item['product']['image'] != null
                    ? Image.file(File(item['product']['image']), fit: BoxFit.contain)
                    : const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product']['brand'] ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600])
                ),

                SizedBox(
                  width: 235,
                  child: Text(
                    item['product']['name'] ?? '',
                    maxLines: 1, overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17)
                  ),
                ),
                if (item['sizeK'] != 'null' && item['sizeK'].toString().isNotEmpty)
                  Text(item['sizeK'], style: const TextStyle(fontSize: 17)),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 90,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                                if (jumlah > 1) {
                                  int newJumlah = jumlah - 1;
                                  updateJumlah(idKeranjang, newJumlah);
                                  setState(() {
                                    jumlahMap[idKeranjang] = newJumlah;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove, size: 16),
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          SizedBox(
                            width: 17,
                            child: Center(
                              child: Text('$jumlah')
                            )
                          ),

                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                                int newJumlah = jumlah + 1;
                                updateJumlah(idKeranjang, newJumlah);
                                setState(() {
                                  jumlahMap[idKeranjang] = newJumlah;
                                });
                              },
                              icon: const Icon(Icons.add, size: 16),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 145,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Rp', 
                            style: TextStyle(
                              color: Color(0xFF7A8AD7),
                              fontWeight: FontWeight.w700,
                              fontSize: 16
                            )
                          ),
                          Text(
                            formatter.format(jumlah * (item['product']['price'] ?? 0)).replaceAll('Rp', ''),
                            style: const TextStyle(
                              fontSize: 23, 
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A8AD7)
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: Query(
          options: QueryOptions(
            document: gql(KeranjangQueries.getAll),
            variables: {"id_user": widget.idUser},
            pollInterval: const Duration(seconds: 5),
            fetchPolicy: FetchPolicy.noCache, 
          ),
          builder: (result, {fetchMore, refetch}) {
            final List keranjang = result.data?['keranjangs'] ?? [];
            final userKeranjang = keranjang.where((e) => e['id_user'] == widget.idUser).toList();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Keranjang (${userKeranjang.length})', 
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditMode = !isEditMode;
                    });
                  },
                  child: Text(isEditMode ? 'Ubah' : 'Selesai'),
                )
              ],
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.grey.shade300)
        ),
      ),

      body: Query(
        options: QueryOptions(
          document: gql(KeranjangQueries.getAll),
          variables: {"id_user": widget.idUser},
          pollInterval: const Duration(seconds: 5),
          fetchPolicy: FetchPolicy.noCache, 
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) return const Center(child: CircularProgressIndicator());
          if (result.hasException) return Center(child: Text(result.exception.toString()));

          final List keranjang = result.data?['keranjangs'] ?? [];
          final userKeranjang = keranjang.where((e) => e['id_user'] == widget.idUser).toList();

          for (var item in userKeranjang) {
            jumlahMap.putIfAbsent(item['id_keranjang'], () => item['jumlah'] as int);
          }

          double totalHarga = 0;
          int totalQty = 0;

          for (var item in userKeranjang) {
            if (selectedMap[item['id_keranjang']] ?? false) {
              int jumlah = jumlahMap[item['id_keranjang']] ?? (item['jumlah'] as int);
              totalHarga += (jumlah * (item['product']['price'] ?? 0));
              totalQty += jumlah;
            }
          }

          bool selectAllActive = userKeranjang.isNotEmpty &&
              userKeranjang.every((item) => selectedMap[item['id_keranjang']] == true);

          return Column(
            children: [
              Expanded(
                child: userKeranjang.isEmpty
                    ? const Center(child: Text("Keranjang kosong"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemCount: userKeranjang.length,
                        itemBuilder: (context, index) => buildCartItem(userKeranjang[index]),
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -5)
                      )
                    ]
                  ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: selectAllActive,
                                onChanged: (val) => toggleSelectAll(val, userKeranjang),
                              ),
                              const Text('Pilih Semua', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Total ($totalQty)',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                              ),

                              const SizedBox(width: 5,),

                              const Text(
                                'Rp',
                                style: TextStyle(
                                  color: Color(0xFF7A8AD7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16
                                )
                              ),
                              Text(
                                formatter.format(totalHarga).replaceAll('Rp', ''),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23, 
                                  color: Color(0xFF7A8AD7)
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: AbsorbPointer(
                          absorbing: totalQty == 0,
                          child: Opacity(
                            opacity:  totalQty > 0 ? 1.0 : 0.5,
                            child: SlideAction(
                              height: 58, 
                              sliderButtonIconSize: 16,
                              text: isEditMode ? ">>>>>> Checkout" : ">>>>>> Hapus",
                              textStyle: const TextStyle(
                                color: Colors.white, 
                                fontSize: 20, 
                                fontWeight: FontWeight.bold
                              ),
                              outerColor: isEditMode ? const Color(0xFF7A8AD7) : Colors.red,
                              innerColor: Colors.white,
                              elevation: 0,
                              borderRadius: 35,
                              onSubmit: () async {
                                if (isEditMode) {
                                  if (totalQty == 0) return;
                                  await tambahkCheckout(userKeranjang, refetch!);
                                  Navigator.push(
                                    // ignore: use_build_context_synchronously
                                    context, 
                                    MaterialPageRoute(builder: 
                                      (context) => CheckoutScreen(idUser: widget.idUser,)
                                    )
                                  );
                                } else {
                                  for (var item in userKeranjang) {
                                    if (selectedMap[item['id_keranjang']] ?? false) {
                                      await deleteKeranjang(item['id_keranjang']);
                                    }
                                  }
                                  refetch!();
                                  setState(() => selectedMap.clear());
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
