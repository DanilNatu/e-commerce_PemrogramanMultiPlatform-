import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project2/UserScreen/alamat.dart';
import 'package:project2/UserScreen/detail.dart';
import 'package:project2/UserScreen/favorite.dart';
import 'package:project2/UserScreen/history.dart';
import 'package:project2/UserScreen/listChatUser.dart';
import 'package:project2/graphql/query/UserScreen/product.dart';
import 'package:project2/graphql/query/chat/chat_query.dart';

class HomeScreen extends StatefulWidget {
  final int idUser;
  const HomeScreen({super.key, required this.idUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  String selectedKategori = 'All';

  Widget navBottom ({
    required IconData icon, 
    required String title, 
    required VoidCallback onTap,
    required Color? contentColor,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: contentColor
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10)
      ],
    );
  }

  Widget kategoriItem(String image, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedKategori = title;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: selectedKategori == title ? const Color(0xFF7A8AD7) : const Color.fromARGB(255, 214, 213, 213) ,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  image, 
                  fit: BoxFit.contain
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15
            ),
          ),
        ],
      ),
    );
  }

  Widget productItem(Map item, VoidCallback refetch) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              product: item, 
              idUser: widget.idUser, 
              idFavorite: item['id_favorite'],
              isInitiallyFavorite: item['id_favorite'] != null,
              refetch: refetch,
              )
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, 
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: item['image'] != null 
                ? Image.file(
                    File(item['image']),
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
                    item['name'] ?? '',
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
                        formatter.format(item['price']).replaceAll('Rp', ''),
                        style: const TextStyle(
                          color: Color(0xFF7A8AD7),
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Stok : ${item['stok'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  )
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/BAKULOS.png',
                    width: 100,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 232, 232),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color.fromARGB(255, 123, 138, 215)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchQuery = '';
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF7B8AD7),
                                  fontSize: 20
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              
                  Query(
                    options: QueryOptions(
                      document: gql(ChatQueries.countUnreadChatByUser),
                      variables: {
                        "id_user": widget.idUser,
                      },
                      pollInterval: const Duration(seconds: 1),
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      final int unreadCount = result.data?['countUnreadChatByUser'] ?? 0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListChatUserScreen(idUser: widget.idUser),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: 50,
                              height: 60,
                              child: Icon(
                                Icons.chat,
                                color: Color(0xFF7B8AD7),
                                size: 33,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                top: 5,
                                right: 3,
                                child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),

            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                  FocusScope.of(context).unfocus();
                },
                child: Query(
                  options: QueryOptions(
                    document: gql(ProductQueries.getAll),
                    variables: {"id_user": widget.idUser},
                    pollInterval: const Duration(seconds: 5), // Otomatis refresh 5 detik (opsional)
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
                          child: Text("Gagal upload produk: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
                        )
                      );
                    }
                
                    final List products = result.data?['products'] ?? [];
                
                    // Filter kategori & search (tetap seperti semula)
                    List filtered = products.where((item) {
                      if (selectedKategori != 'All' && item['kategori'] != selectedKategori) return false;
                      if (_searchQuery.isNotEmpty && !(item['name']?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase())) return false;
                      return true;
                    }).toList();

                  return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        navBottom(
                                          icon: Icons.favorite, 
                                          contentColor: Colors.red,
                                          title: 'Favorites', 
                                          onTap: () {
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(builder: (context) => FavoriteScreen(idUser: widget.idUser)),
                                            );
                                          }
                                        ),  
                                    
                                        navBottom(
                                          icon: Icons.history, 
                                          contentColor: Colors.black,
                                          title: 'History', 
                                          onTap: () {
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(builder: (context) => HistoryScreen(idUser: widget.idUser,)),
                                            );
                                          }
                                        ),
                                    
                                        navBottom(
                                          icon: Icons.location_on,
                                          contentColor: Colors.red,
                                          title: 'Alamat',
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AlamatScreen(idUser: widget.idUser)),
                                            );
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 3),
                      
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              color: Colors.white,
                              child: SizedBox(
                                height: 200,
                                child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                            
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/Banner.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                      
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/diskon.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                            
                                  ],
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 3),
                      
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                              
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kategori',
                                            style: TextStyle(
                                                fontSize: 17, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                              
                                      const SizedBox(height: 15),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedKategori = 'All';
                                                  });
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: selectedKategori == 'All' ? const Color(0xFF7A8AD7) : const Color.fromARGB(255, 214, 213, 213),
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        'ALL',
                                                        style: TextStyle(
                                                          color: selectedKategori == 'All' ? Colors.white : Colors.black,
                                                          fontSize: 23,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    )
                                                    ),
                                                  ),
                                                ),
                                            ),
                      
                                            kategoriItem('assets/images/Baju.png', 'Baju'),
                                            kategoriItem('assets/images/Celana.png', 'Celana'),
                                            kategoriItem('assets/images/Tas.png', 'Tas'),
                                            kategoriItem('assets/images/Sepatu.png', 'Sepatu'),
                                          ],
                                        ),
                                      ),
                                              
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.white, Color.fromARGB(255, 222, 221, 221)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Product',
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                      
                                      Text(
                                        selectedKategori == 'All' ? '' : 'Kategori : $selectedKategori',
                                        style: const TextStyle(
                                          fontSize: 17, 
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7A8AD7),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: filtered.isEmpty 
                                    ? const Center(
                                        child: Text(
                                          'Belum ada produk yang tersedia',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : MasonryGridView.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        itemCount: filtered.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) => productItem(filtered[index], refetch!),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    );
                  }
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}
