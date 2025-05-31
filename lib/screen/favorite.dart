import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:project2/screen/detail.dart';

class CartItem {
  final String image;
  final String name;
  final double price;

  CartItem({
    required this.image,
    required this.name,
    required this.price,
  });
}

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  List<CartItem> items = [
    CartItem(
      image: 'assets/images/Baju.png',
      name: 'Tshirt Oversize ',
      price: 125000,
    ),
    CartItem(
      image: 'assets/images/Polo.png',
      name: 'Kaos Polo',
      price: 150000,
    ),
    CartItem(
      image: 'assets/images/Tas.png',
      name: 'Tas Ransel',
      price: 200000,
    ),
    CartItem(
      image: 'assets/images/Celana.png',
      name: 'Celana Panjang',
      price: 175000,
    ),
    CartItem(
      image: 'assets/images/Sepatu.png',
      name: 'Produk Tambahan',
      price: 250000,
    ),
  ];

  Widget favProduk(int index) {
    final item = items[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DetailScreen(isInitiallyFavorite: true)),
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
              child: Image.asset(
                item.image,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
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
                        formatter.format(item.price).replaceAll('Rp', ''),
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
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 60, 60, 60),
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                          fixedSize: const Size(100, 40)),
                                      child: const Text('Batal'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    const SizedBox(width: 10),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 16),
                                          fixedSize: const Size(100, 40)),
                                      child: const Text('Hapus'),
                                      onPressed: () {
                                        setState(() {
                                          items.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: items.length,
          itemBuilder: (context, index) => favProduk(index),
        ),
      ),
    );
  }
}
