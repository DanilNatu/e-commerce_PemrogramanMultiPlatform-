import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/detail.dart';
import 'package:project2/graphql/mutation/UserScreen/favorite.dart';
import 'package:project2/graphql/query/UserScreen/favorite.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';

class FavoriteScreen extends StatefulWidget {
  final int idUser;
  const FavoriteScreen({super.key, required this.idUser});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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

  Future<void> deleteFavorite(BuildContext context,int idFavoriteToDelete,) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(FavoriteMutations.delete),
        variables: {"id_favorite": idFavoriteToDelete},
      ),
    );

    if (!mounted) return;

    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal hapus produk: ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
    } else {
      _flashyFlushbar(message: "Produk berhasil dihapus dari favorite!");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Widget favProduk(Map item, VoidCallback refetch) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
              DetailScreen(
                isInitiallyFavorite: true, 
                idUser: widget.idUser, 
                product: item['product'], 
                idFavorite: item['id_favorite'],
                refetch: refetch,
              )
          ),
          (route) => route.isFirst
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['product']?['name'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 3),
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
                        formatter.format(item['product']?['price'] ?? 0).replaceAll('Rp', ''),
                        style: const TextStyle(
                          color: Color(0xFF7A8AD7),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 242, 15, 83),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'Hapus Produk dari Favorit?',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
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
                                      child: const Text('Batal'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          textStyle:const TextStyle(fontSize: 16),
                                          fixedSize: const Size(100, 40),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                          ),
                                        ),
                                      child: const Text('Hapus'),
                                      onPressed: () async{
                                        final int idFavorite = item['id_favorite'];
                                        await deleteFavorite(context, idFavorite);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
        title: const Text('Favorite'),
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
          document: gql(FavoriteQueries.getAll),
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
                child: Text("Gagal upload produk favorite: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
              )
            );
          }

          final List favorite = result.data?['favorites'] ?? [];

          final List userFavorites = favorite.where((item) {
            return item['id_user'] == widget.idUser;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: userFavorites.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada produk favorite',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: userFavorites.length,
                  itemBuilder: (context, index) => favProduk(userFavorites[index], refetch!),
                ),
          );
        }
      ),
    );
  }
}
