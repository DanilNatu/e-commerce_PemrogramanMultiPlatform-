// ignore: file_names
import 'dart:io';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/AdminScreen/tambahProduk.dart';
import 'package:project2/graphql/mutation/AdminScreen/product.dart';

class DetailProdukAdminScreen extends StatefulWidget {
  final Map product;

  const DetailProdukAdminScreen({super.key, required this.product});

  Future<void> _deleteProduct(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProductMutations.delete),
        variables: {"idProduct": product['id_product']},
      ),
    );

    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text("Gagal hapus produk: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
          backgroundColor: const Color.fromARGB(202, 0, 0, 0)
        ),
      );
    } else {
      FlashyFlushbar(
        leadingWidget: const Icon(
          Icons.error_outline,
          color: Colors.black,
          size: 24,
        ),
        message: "Produk berhasil dihapus!",
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
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  // ignore: library_private_types_in_public_api
  _DetailProdukAdminScreenState createState() => _DetailProdukAdminScreenState();
}

class _DetailProdukAdminScreenState extends State<DetailProdukAdminScreen> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp', 
    decimalDigits: 0
  );

  Widget _buildDetailRow(String label, String value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text('Detail Produk'),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300, 
                    width: double.infinity, 
                    child: Image.file(
                      File(widget.product['image']),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product['name'] ?? '',
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
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
                        formatter.format(widget.product['price'] ?? 0).replaceAll('Rp', ''),
                        style: const TextStyle(
                          color: Color(0xFF7A8AD7), 
                          fontWeight: FontWeight.w700, 
                          fontSize: 25
                        ),
                      ),
                    ],
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
                    const Text(
                      'Spesifikasi', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold
                        )
                      ),
              
                    const SizedBox(height: 5),
                    _buildDetailRow('Kategori', widget.product['kategori']),
              
                    _buildDetailRow('Brand', widget.product['brand']),
              
                    if (widget.product['size'] != null && widget.product['size']  != '') _buildDetailRow('Size', widget.product['size']),
              
                    if (widget.product['warna'] != null && widget.product['warna'] != '') _buildDetailRow('Warna', widget.product['warna']),
              
                    _buildDetailRow('Stok', widget.product['stok'].toString()),
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
                offset: Offset(0, -5)
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      backgroundColor: const Color(0xFF7A8AD7),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TambahProdukScreen(
                            isEdit: true,
                            product: widget.product,
                            idPenjual: int.parse(widget.product['id_penjual'].toString()),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w900
                      )
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            'Apa Anda Yakin Menghapus Produk?', 
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.w500
                            )
                          ),
                          content: Text('Produk "${widget.product['name']}" akan dihapus permanen.'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    textStyle: const TextStyle(fontSize: 16),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Batal'),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 16),
                                    fixedSize: const Size(100, 40),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget._deleteProduct(context);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Hapus', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w900
                      )
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
}
