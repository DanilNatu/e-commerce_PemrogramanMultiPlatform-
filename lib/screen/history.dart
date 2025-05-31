import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project2/screen/detail.dart';

class CartItem {
  final String image;
  final String name;
  final String size;
  final String warna;
  int amount;
  final double price;
  final String descripsi;

  CartItem({
    required this.image,
    required this.name,
    required this.size,
    required this.warna,
    required this.amount,
    required this.price,
    required this.descripsi,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  List<CartItem> items = [
    CartItem(
      image: 'assets/images/Baju.png',
      name: 'Tshirt Oversize sdvnaovav aiovaiovnav adovni vioadv ja ',
      size: 'M',
      warna: 'Hitam',
      amount: 2,
      price: 125000,
      descripsi: 'Material : cotton 24 s, Plastisol ink, Oversize Regular, Unisex \n \nSpesifikasi'
    ),
    CartItem(
      image: 'assets/images/Polo.png',
      name: 'Kaos Polo',
      size: 'L',
      warna: 'Coklat Muda',
      amount: 3,
      price: 150000,
      descripsi: ';dflmedp[lfbv]'
    ),
    CartItem(
      image: 'assets/images/Sepatu.png',
      name: 'Produk Tambahan',
      size: 'L',
      warna: 'Hitam',
      amount: 1,
      price: 250000,
      descripsi: 'e[]fghkpt]e[tkhj]'
    ),
  ];

  Widget _cardItems(int index) {
    final item = items[index];
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
                heightFactor: 0.35,
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
                              builder: (context) => DetailScreen(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 18, bottom: 8, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detail Produk Pembelian',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                      
                      const SizedBox(height: 10),
                      Text(
                        item.descripsi,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                        ),
                      )
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
                      child: Image.asset(
                        item.image,
                        fit: BoxFit.contain,
                        alignment: Alignment.topLeft,  
                      ),
                    )
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name, 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${item.warna}, ${item.size}',
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
                              formatter.format(item.price * item.amount).replaceAll('Rp', ''),
                              style: const TextStyle(
                                color: Color(0xFF7A8AD7),
                                fontWeight: FontWeight.w700,
                                fontSize: 23,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '(x ${item.amount})',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
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

      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: items.length,
        itemBuilder: (context, index) => _cardItems(index),
      ),
    );
  }
}