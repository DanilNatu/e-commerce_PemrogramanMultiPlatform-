import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/Widget/bottomNavUser.dart';
import 'package:project2/UserScreen/alamat.dart';
import 'package:project2/UserScreen/history.dart';
import 'package:project2/graphql/mutation/AdminScreen/product.dart';
import 'package:project2/graphql/mutation/UserScreen/checkout.dart';
import 'package:project2/graphql/query/UserScreen/alamat.dart';
import 'package:project2/graphql/query/UserScreen/checkout.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CheckoutScreen extends StatefulWidget {
  final int idUser;

  const CheckoutScreen({super.key, required this.idUser});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List userCheckoutData = [];

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  Map<String, dynamic>? selectedAlamat;
  List<Map<String, dynamic>> alamatUser = [];
  bool isLoadingAlamat = true;


  Future<void> getAlamat() async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.query(
      QueryOptions(
        document: gql(AlamatQueries.getAll),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.noCache, 
      )
    );

    if (result.hasException) {
      setState(() { isLoadingAlamat = false; });
      return;
    }

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result.data?['alamats'] ?? []);

    setState(() {
      alamatUser = data.where((e) => e['id_user'] == widget.idUser).toList();

      // AUTO SET default alamat utama (hanya 1x di awal)
      if (selectedAlamat == null && alamatUser.isNotEmpty) {
        final utama = alamatUser.firstWhere(
          (e) => e['alamat_utama'] == true,
          orElse: () => alamatUser.first
        );
        selectedAlamat = utama;
      }

      isLoadingAlamat = false;
    });
  }



  Future<void> updateAlamatUtama({
    required int idUser,
    required List userCheckout,
    required int idAlamat,
  }) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userCheckout) {
      final result = await client.mutate(
        MutationOptions(
          document: gql(CheckoutMutations.update),
          variables: {
            "id_checkout": item['id_checkout'],
            "id_alamat": idAlamat,
          },
        ),
      );

      if (result.hasException) {
        debugPrint("Update gagal: ${result.exception.toString()}");
      } else {
        debugPrint("Update berhasil");
      }
    }
  }


  List<String> metodePembayaran = ['Bank BCA (232362543254)', 'Bank BRI (1654745468)', 'Bank BNI (451414676)'];
  String selectedPembayaran = '';
  Future<void> updatePembayaran({
    required int idUser,
    required List userCheckout,
    required String pembayaran,
  }) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userCheckout) {
      final result = await client.mutate(
        MutationOptions(
          document: gql(CheckoutMutations.update),
          variables: {
            "id_checkout": item['id_checkout'],
            "pembayaran": pembayaran,
          },
        ),
      );

      if (result.hasException) {
        debugPrint("Update gagal: ${result.exception.toString()}");
      } else {
        debugPrint("Update berhasil");
      }
    }
  }


  List<String> metodePengiriman = ['Jnt Standard | 3-4 days', 'SiCepat | 5-6 days', 'JnE | 3-5 days'];
  String selectedPengiriman = '';
  Future<void> updatePengiriman({
    required int idUser,
    required List userCheckout,
    required String metodePengiriman,
  }) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userCheckout) {
      final result = await client.mutate(
        MutationOptions(
          document: gql(CheckoutMutations.update),
          variables: {
            "id_checkout": item['id_checkout'],
            "metode_pengiriman": metodePengiriman,
          },
        ),
      );

      if (result.hasException) {
        debugPrint("Update gagal: ${result.exception.toString()}");
      } else {
        debugPrint("Update berhasil");
      }
    }
  }


  Future<void> confirmAllCheckout(List userCheckout) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userCheckout) {
      // Update stok produk dulu sebelum checkout diproses
      final product = item['product'];
      if (product == null) {
        debugPrint("Product data null, skip stok update");
        continue;
      }

      final int idProduct = product['id_product'];
      final int jumlahCheckout = item['jumlah'] as int? ?? 0;
      final int stokSekarang = product['stok'] as int? ?? 0;

      final int updatedStok = stokSekarang - jumlahCheckout;

      final stockResult = await client.mutate(
        MutationOptions(
          document: gql(ProductMutations.updateStok),
          variables: {
            "id_product": idProduct,
            "stok": updatedStok,
          },
        ),
      );

      if (stockResult.hasException) {
        debugPrint("Gagal update stok product id $idProduct: ${stockResult.exception.toString()}");
      } else {
        debugPrint("Stok product id $idProduct berhasil diupdate");
      }

      // Setelah stok diupdate, baru lakukan ConfirmCheckout
      final idCheckout = item['id_checkout'];
      final result = await client.mutate(
        MutationOptions(
          document: gql(CheckoutMutations.ConfirmCheckout),
          variables: {
            "id_checkout": idCheckout,
          },
        ),
      );

      if (result.hasException) {
        debugPrint("Gagal konfirmasi checkout id $idCheckout: ${result.exception.toString()}");
      } else {
        debugPrint("Berhasil konfirmasi checkout id $idCheckout");
      }
    }
  }



  Future<void> deleteAllCheckout(List userCheckout) async {
    final client = GraphQLProvider.of(context).value;

    for (var item in userCheckout) {
      final idCheckout = item['id_checkout'];

      final result = await client.mutate(
        MutationOptions(
          document: gql(CheckoutMutations.delete),
          variables: {
            "id_checkout": idCheckout,
          },
        ),
      );

      if (result.hasException) {
        debugPrint("Gagal hapus checkout id $idCheckout: ${result.exception.toString()}");
      } else {
        debugPrint("Berhasil hapus checkout id $idCheckout");
      }
    }
  }


  List<String> metodeVoucher = ['Gratis Ongkir', 'Potongan Rp20.000'];
  List<String> selectedVouchers = [];
  bool get isFreeShipping => selectedVouchers.contains('Gratis Ongkir');
  bool get hasDiscount => selectedVouchers.contains('Potongan Rp20.000');
  double get potonganVoucher {
    if (selectedVouchers.contains('Potongan Rp20.000')) {
      return 20000;
    }
    return 0;
  }
  String get selectedVoucher {
    return selectedVouchers.isNotEmpty ? selectedVouchers.first : '';
  }

  Map<String, dynamic> calculateTotals(List checkoutData, bool isFreeShipping, double potonganVoucher) {
    double totalHargaproduct = 0;
    int totalItemCount = 0;

    for (var item in checkoutData) {
      final price = (item['product']['price'] as num? ?? 0).toDouble();
      final jumlah = (item['jumlah'] as num? ?? 1).toInt();

      totalHargaproduct += price * jumlah;
      totalItemCount += jumlah;
    }

    int jasaAplikasi = 15000;
    int ongkir = isFreeShipping ? 0 : 20000;
    double totalCheckout = totalHargaproduct + jasaAplikasi + ongkir - potonganVoucher;

    return {
      "totalHargaproduct": totalHargaproduct,
      "totalItemCount": totalItemCount,
      "totalCheckout": totalCheckout,
      "jasaAplikasi": jasaAplikasi,
      "ongkir": ongkir
    };
  }


  Widget _itemcheckout({
    required String label,
    required Widget text,
    required Color? contentColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        label, 
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const Spacer(),
                      const Icon(
                        size: 17,
                        color: Color.fromARGB(255, 129, 129, 129),
                        Icons.arrow_forward_ios,
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: contentColor, 
                      fontSize: 16
                    ), 
                    child: text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  

  Widget _cardItems(Map item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
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
                    child: item['product']['image'] != null 
                      ? Image.file(
                          File(item['product']['image']),
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                          item['product']['name'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          [
                            item['product']['warna'] ?? '',
                            if ((item['keranjang']?['sizeK'] ?? item['sizeP']) != null && (item['keranjang']?['sizeK'] ?? item['sizeP']) != 'null')
                              (item['keranjang']?['sizeK'] ?? item['sizeP'])
                          ].where((e) => e != '').join(', '),
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
    );
  }

  Widget _summaryRow(
    String label, 
    String value
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(fontSize: 16)
          ),
          Text(
            value, 
            style: const TextStyle(fontSize: 16)
          ),
        ],
      ),
    );
  }

  void showSelectionModal({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String) onItemSelected,
    IconData? icon,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.45,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    IconButton(
                      onPressed: () async{
                        await Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => AlamatScreen(idUser: widget.idUser,))
                        );

                        getAlamat();
                      }, 
                      icon: Icon(icon, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 2),
              Expanded(
                child: ListView(
                  children: items.map((item) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        onItemSelected(item);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getAlamat();
    });
  }



  @override
  Widget build(BuildContext context) {

    return Query(
      options: QueryOptions(
        document: gql(CheckoutQueries.getAll),
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
              child: Text("Gagal upload checkout: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
            )
          );
        }

        final List checkout = result.data?['checkouts'] ?? [];

        final userCheckout = checkout.where((item) {
          return item['id_user'] == widget.idUser;
        }).toList();
        userCheckoutData = userCheckout;

        final totals = calculateTotals(
          userCheckout,
          isFreeShipping,
          potonganVoucher
        );

        // Nah semua total tinggal ambil dari totals map
        final totalHargaproduct = totals['totalHargaproduct'];
        final totalItemCount = totals['totalItemCount'];
        final totalCheckout = totals['totalCheckout'];
        final jasaAplikasi = totals['jasaAplikasi'];
        final ongkir = totals['ongkir'];

      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async{
          await deleteAllCheckout(userCheckoutData);
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 222, 221, 221),
          appBar: AppBar(
            title: const Text(
              'Checkout', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1), 
              child: Container(
                color: Colors.grey.shade300,
                height: 1,
              ),
            ),
          ),
          body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _itemcheckout(
                          label: 'Alamat',
                          text: selectedAlamat != null
                            ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 30,
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 340,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              selectedAlamat!['namaA'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 21,
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 7),
                                            child: Text(
                                              '|',
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 129, 129, 129),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            selectedAlamat!['teleponA'],
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 129, 129, 129),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 340,
                                      child: Text(
                                        selectedAlamat!['alamat'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ) : const Text('Tambahkan Alamat Pengiriman'),
                          contentColor: selectedAlamat != null ? Colors.black : Colors.grey,
                          onTap: () {
                            showSelectionModal(
                              context: context,
                              title: 'Pilih Alamat Pengiriman',
                              items: alamatUser.map((a) => '${a['namaA']}\n${a['teleponA']}\n${a['alamat']}').toList(),
                              onItemSelected: (selected) async{
                                final alamat = alamatUser.firstWhere((a) =>
                                    '${a['namaA']}\n${a['teleponA']}\n${a['alamat']}' == selected);
                                setState(() {
                                  selectedAlamat = alamat;
                                });
      
                                if (userCheckout.isNotEmpty) {
                                  await  updateAlamatUtama(
                                    idUser: widget.idUser,
                                    userCheckout: userCheckout,
                                    idAlamat: alamat['id_alamat']
                                  );
                                }
                              },
                              icon: Icons.add,
                            );
                          },
                        ),
                  
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          itemCount: userCheckout.length,
                          itemBuilder: (context, index) => _cardItems(userCheckout[index])
                        ),
                  
                        _itemcheckout(
                          label: 'Metode Pembayaran', 
                          text: selectedPembayaran.isEmpty ? const Text('Pilih Metode Pembayaran') : Text(selectedPembayaran), 
                          contentColor: selectedPembayaran.isEmpty ? Colors.grey : Colors.black, 
                          onTap: () {
                            showSelectionModal(
                              context: context, 
                              title: 'Pilih Metode Pembayaran', 
                              items: metodePembayaran, 
                              onItemSelected: (metode) async{
                                setState(() {
                                  selectedPembayaran = metode;
                                });
      
                                if (userCheckout.isNotEmpty) {
                                  await updatePembayaran(
                                    idUser: widget.idUser,
                                    userCheckout: userCheckout,
                                    pembayaran: selectedPembayaran
                                  );
                                }
                              }
                            );
                          }
                        ),
                  
                        _itemcheckout(
                          label: 'Metode Pengiriman', 
                          text: selectedPengiriman.isEmpty ? const Text('Pilih Metode Pengiriman') : Text(selectedPengiriman), 
                          contentColor: selectedPengiriman.isEmpty ? Colors.grey : Colors.black, 
                          onTap: () {
                            showSelectionModal(
                              context: context, 
                              title: 'Pilih Metode Pengiriman', 
                              items: metodePengiriman, 
                              onItemSelected: (metode) async{
                                setState(() {
                                  selectedPengiriman = metode;
                                });
      
                                if (userCheckout.isNotEmpty) {
                                  await updatePengiriman(
                                    idUser: widget.idUser, 
                                    userCheckout: userCheckout, 
                                    metodePengiriman: selectedPengiriman
                                  );
                                }
                              }
                            );
                          }
                        ),
                  
                        _itemcheckout(
                          label: 'Voucher', 
                          text: selectedVouchers.isNotEmpty ? Text(selectedVouchers.join('\n')) : const Text('Pilih Voucher'), 
                          contentColor: selectedVouchers.isNotEmpty ? Colors.black : const Color.fromARGB(255, 129, 129, 129),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor:  const Color.fromARGB(255, 222, 221, 221),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                final List<String> tempSelected = List.from(selectedVouchers);
                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.35,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: Text(
                                              'Pilih Voucher',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          const Divider(thickness: 2),
                                          Expanded(
                                            child: ListView(
                                              children: metodeVoucher.map((voucher) {
                                                final isSelected = tempSelected.contains(voucher);
                                                return Card(
                                                  color: Colors.white,
                                                  margin:
                                                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  child: CheckboxListTile(
                                                    title: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Text(
                                                        voucher,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    value: isSelected,
                                                    onChanged: (value) {
                                                      setModalState(() {
                                                        if (value == true) {
                                                          tempSelected.add(voucher);
                                                        } else {
                                                          tempSelected.remove(voucher);
                                                        }
                                                      });
                                                    },
                                                    controlAffinity: ListTileControlAffinity.leading,
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context, tempSelected);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFF7A8AD7),
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Pilih',
                                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ).then((value) {
                              if (value != null && value is List<String>) {
                                setState(() {
                                  selectedVouchers = value;
                                });
                              }
                            });
                          }
                        ),
                  
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Rincian Pembayaran', 
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      children: [
                                        _summaryRow(
                                          'Subtotal ($totalItemCount)', 
                                          formatter.format(totalHargaproduct),
                                        ),
                                        _summaryRow(
                                          'Biaya Ongkir',
                                          isFreeShipping ? 'Free' : formatter.format(ongkir),
                                        ),
                                        if (hasDiscount)
                                          _summaryRow(
                                            'Voucher Diskon',
                                            '- ${formatter.format(potonganVoucher)}',
                                          ),
                                        _summaryRow(
                                          'Jasa Aplikasi', 
                                          formatter.format(jasaAplikasi)
                                        ),
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            const SizedBox(width: 10),
                
                            const Text(
                              'Rp',
                              style: TextStyle(
                                color: Color(0xFF7A8AD7),
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formatter.format(totalCheckout).replaceAll('Rp', ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 23, 
                                color: Color(0xFF7A8AD7)
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AbsorbPointer(
                            absorbing: selectedPembayaran.isEmpty || selectedPengiriman.isEmpty,
                            child: Opacity(
                              opacity: selectedPembayaran.isEmpty || selectedPengiriman.isEmpty ? 0.5 : 1.0,
                              child: SlideAction(
                                height: 58,
                                sliderButtonIconSize: 16,
                                text: ">>>>>> Swipe",
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                outerColor: const Color(0xFF7A8AD7),
                                innerColor: Colors.white,
                                borderRadius: 35,
                                onSubmit: () async {
                                  await Future.delayed(const Duration(milliseconds: 500)); 
      
                                  await confirmAllCheckout(userCheckout);
      
                                    showDialog(
                                      barrierColor: const Color.fromARGB(240, 236, 236, 236),
                                      barrierDismissible: false,
                                      // ignore: use_build_context_synchronously
                                      context: context, 
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 50),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 123, 138, 215),
                                              borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/Sukses.png',
                                                  height: 150,
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Pembelian\nSukses',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                                const SizedBox(height: 35),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    minimumSize: const Size(250, 50),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(13),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushAndRemoveUntil(
                                                      context, 
                                                      MaterialPageRoute(builder: (context) => BottonNavigation(idUser: widget.idUser)),
                                                      (route) => false,
                                                    );
                                                  }, 
                                                  child: const Text(
                                                    'Lanjut Belanja',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(255, 123, 138, 215),
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ),
                                                const SizedBox(height: 15),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => HistoryScreen(idUser: widget.idUser,),
                                                      ),
                                                      (route) => route.isFirst,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Lihat Detail Belanja',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        );
      }
    );
  }
}
