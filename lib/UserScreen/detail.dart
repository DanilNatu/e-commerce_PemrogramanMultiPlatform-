// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/chatUser.dart';
import 'package:project2/UserScreen/checkout.dart';
import 'package:project2/graphql/mutation/UserScreen/checkout.dart';
import 'package:project2/graphql/mutation/UserScreen/favorite.dart';
import 'package:project2/graphql/mutation/UserScreen/keranjang.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  final int? idFavorite;
  final int idUser;
  Map product;
  final bool isInitiallyFavorite;
  final VoidCallback refetch;

  DetailScreen({
    super.key,
    this.isInitiallyFavorite = false,
    required this.product,
    required this.idUser,
    this.idFavorite,
    required this.refetch}
  );

  @override
  // ignore: library_private_types_in_public_api
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  
  String selectedSize = 'null';
  late bool _isfavorite;
  late int? _currentIdFavorite;
  int amount = 1;

  @override
  void initState() {
    super.initState();
    _isfavorite = widget.isInitiallyFavorite;
    _currentIdFavorite = widget.idFavorite;
  }

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  void _flashyFlushbar ({required String message})
  {
    return FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error_outline,
        color: Colors.black,
        size: 24,
      ),
      message: message,
      duration: const Duration(seconds: 2),
      trailingWidget: const IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
          size: 24,
        ),
        onPressed: FlashyFlushbar.cancel,
      ), 
      isDismissible: false,
    ).show();
  }

  Widget detailproduk(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> tambahkKeranjang() async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(KeranjangMutations.create),
        variables: {
          "jumlah": amount,
          "id_user": widget.idUser,
          "id_product": widget.product['id_product'],
          "sizeK": selectedSize
        },
      ),
    );

    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal menambahkan ke keranjang: ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
      return;
    }

    widget.refetch();

    _flashyFlushbar(message: "Berhasil ditambahkan ke keranjang");
  }

  Future<void> tambahkCheckout() async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(CheckoutMutations.create),
        variables: {
          "jumlah": amount,
          "id_user": widget.idUser,
          "id_product": widget.product['id_product'],
          "sizeP": selectedSize,
        },
      ),
    );

    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal checkout ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
      return;
    }

    widget.refetch();
  }


  @override
  Widget build(BuildContext context) {
    final int total = (widget.product['price']) * amount;
    final List<String> sizes = widget.product['size'] != null
      ? widget.product['size'].toString().split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
      : [];
    final bool isSizeSelected = sizes.isEmpty || (selectedSize != '' && selectedSize != 'null');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text('Detail Produk'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.file(
                        File(widget.product['image']),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                    child: Text(
                      widget.product['name'] ?? '',
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Spesifikasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                          )
                        ),
                    ),

                    detailproduk('Kategori', widget.product['kategori'] ?? ''),
                              
                    detailproduk('Brand', widget.product['brand'] ?? ''),
                              
                    if (widget.product['size'] != null && widget.product['size']  != '') detailproduk('Size', widget.product['size'] ?? ''),
                              
                    if (widget.product['warna'] != null && widget.product['warna'] != '') detailproduk('Warna', widget.product['warna'] ?? ''),
                              
                    detailproduk('Stok', widget.product['stok'].toString()),
                  ],
                ),
              ),
            ),
                        
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi', 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['deskripsi'] ?? '', 
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.grey[600]
                      )
                    ),
                  ],
                ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
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
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sizes.isNotEmpty
                      ? const Text(
                          'Pilih Ukuran:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                    IconButton(
                      icon: Icon(
                        _isfavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isfavorite
                            ? const Color.fromARGB(255, 242, 15, 83)
                            : Colors.grey,
                      ),
                      onPressed: () async {
                        final client = GraphQLProvider.of(context).value;

                        if (!_isfavorite) {
                          // Create Favorite
                          final result = await client.mutate(
                            MutationOptions(
                              document: gql(FavoriteMutations.create),
                              variables: {
                                "id_user": widget.idUser,
                                "id_product": widget.product['id_product'],
                              },
                            ),
                          );

                          if (result.hasException) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                padding: const EdgeInsets.all(8),
                                content: Text("Gagal menambahkan ke favorite: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
                                backgroundColor: const Color.fromARGB(202, 0, 0, 0)
                              ),
                            );
                            return;
                          }

                          final newFavoriteId = result.data?['createFavorite']['id_favorite'];

                          // Update state SETELAH berhasil
                          setState(() {
                            _currentIdFavorite = newFavoriteId;
                            _isfavorite = true;
                          });

                          widget.refetch();
                          _flashyFlushbar(message: "Berhasil ditambahkan ke favorite");
                        } else {
                        // Delete Favorite
                          if (_currentIdFavorite != null) {   //<--- gunakan variabel state idFavorite
                            final result = await client.mutate(
                              MutationOptions(
                                document: gql(FavoriteMutations.delete),
                                variables: {"id_favorite": _currentIdFavorite}, //<--- pakai idFavorite dari state
                              ),
                            );

                            if (result.hasException) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: const EdgeInsets.all(8),
                                  content: Text("Gagal hapus produk: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
                                  backgroundColor: const Color.fromARGB(202, 0, 0, 0)
                                ),
                              );
                            } else {
                              setState(() {
                                _currentIdFavorite = null;
                                _isfavorite = false;
                              });

                              widget.refetch();
                              _flashyFlushbar(message: "Produk berhasil dihapus dari favorite!");
                            }
                          }
                        }
                      }
                    ),
                  ],
                ),
                if (sizes.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      children: sizes.map((size) {
                        final isSelected = selectedSize == size;
                        return ChoiceChip(
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF7A8AD7),
                          label: Text(
                            size,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          checkmarkColor: Colors.white,
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (isSelected) {
                                selectedSize = '';
                              } else {
                                selectedSize = size;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Jumlah:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 33,
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              iconSize: 18,
                              onPressed: () {
                                if (amount > 1) {
                                  setState(() {
                                    amount--;
                                  });
                                }
                              },
                            ),
                          ),
                          Text(
                            '$amount',
                            style: const TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            width: 35,
                            height: 33,
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              iconSize: 18,
                              onPressed: () {
                                setState(() {
                                  amount++;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          formatter.format(total).replaceAll('Rp', ''),
                          style: const TextStyle(
                            fontSize: 23,
                            color: Color.fromRGBO(122, 138, 215, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatUserScreen(
                                idUser: widget.idUser,       // <-- ini ambil dari sesi user login kamu
                                idPenjual: widget.product['id_penjual'], // <-- ini dari data list penjuals yang kamu looping
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.chat_outlined)
                      )
                    ),
                    SizedBox(
                      width: 45,
                      child: AbsorbPointer(
                        absorbing: !isSizeSelected,
                        child: Opacity(
                          opacity: isSizeSelected ? 1.0 : 0.5,
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart, size: 27),
                            onPressed: isSizeSelected ? tambahkKeranjang : null
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: !isSizeSelected,
                        child: Opacity(
                          opacity: isSizeSelected ? 1.0 : 0.5,
                          child: SlideAction(
                            height: 58,
                            sliderButtonIconSize: 15,
                            text: ">>>>>> Swipe",
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            outerColor: const Color(0xFF7A8AD7),
                            innerColor: Colors.white,
                            onSubmit: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 500), () {
                                    
                                    tambahkCheckout();
                                Navigator.push(
                                  // ignore: duplicate_ignore
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutScreen(idUser: widget.idUser,),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
