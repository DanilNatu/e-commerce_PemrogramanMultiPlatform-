import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:project2/screen/alamat.dart';
import 'package:project2/screen/detail.dart';
import 'package:project2/screen/favorite.dart';
import 'package:project2/screen/history.dart';

class ProdukItem {
  final String kategori;
  final String image;
  final String name;
  final double price;

  ProdukItem({
    required this.kategori,
    required this.image,
    required this.name,
    required this.price,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  List<ProdukItem> items = [
    ProdukItem(
      kategori: 'Baju',
      image: 'assets/images/Baju.png',
      name: 'Tshirt Oversize ',
      price: 125000,
    ),
    ProdukItem(
      kategori: 'Baju',
      image: 'assets/images/Polo.png',
      name: 'Kaos Polo',
      price: 150000,
    ),
    ProdukItem(
      kategori: 'Tas',
      image: 'assets/images/Tas.png',
      name: 'Tas Ransel',
      price: 200000,
    ),
    ProdukItem(
      kategori: 'Celana',
      image: 'assets/images/Celana.png',
      name: 'Celana Panjang',
      price: 175000,
    ),
    ProdukItem(
      kategori: 'Sepatu',
      image: 'assets/images/Sepatu.png',
      name: 'Sepatu',
      price: 250000,
    ),
  ];

  String selectedKategori = 'All';
  List<ProdukItem> get filteredItems {
    if (selectedKategori == 'All') return items;
    return items.where((item) => item.kategori == selectedKategori).toList();
  }

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

  Widget productItem (ProdukItem item){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailScreen(isInitiallyFavorite: false)),
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 7, right: 10),
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
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Color.fromARGB(255, 123, 138, 215)),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 123, 138, 215),
                                    fontSize: 20
                                  ),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                                
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
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
                                        MaterialPageRoute(builder: (context) => const FavoriteScreen()),
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
                                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
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
                                        MaterialPageRoute(builder: (context) => const AlamatScreen()),
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
                        child: SizedBox(
                          height: 200,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: [
                                      
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/Banner.png',
                                  fit: BoxFit.contain,
                                ),
                              ),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/diskon.jpg',
                                  fit: BoxFit.contain,
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
                              child: MasonryGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                itemCount: filteredItems.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => productItem(filteredItems[index]),
                              ),
                            ),
                          ],
                        ),
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
  }
}
