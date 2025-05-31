import 'package:flutter/material.dart';
import 'package:project2/checkout.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CartItem {
  final String image;
  final String brand;
  final String name;
  final String size;
  int amount;
  final double price;
  bool isSelected;

  CartItem({
    required this.image,
    required this.brand,
    required this.name,
    required this.size,
    required this.amount,
    required this.price,
    this.isSelected = false,
  });
}

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  List<CartItem> items = [
    CartItem(
      image: 'assets/images/Baju.png',
      brand: 'Adidas',
      name: 'Tshirt Oversize ',
      size: 'M',
      amount: 2,
      price: 125.000,
    ),
    CartItem(
      image: 'assets/images/Polo.png',
      brand: 'Polo King',
      name: 'Kaos Polo',
      size: 'L',
      amount: 1,
      price: 150.000,
    ),
    CartItem(
      image: 'assets/images/Tas.png',
      brand: 'SmithBerlin',
      name: 'Tas Ransel',
      size: 'Black',
      amount: 1,
      price: 200.000,
    ),
    CartItem(
      image: 'assets/images/Celana.png',
      brand: 'Jeans',
      name: 'Celana Panjang',
      size: 'M',
      amount: 1,
      price: 175.000,
    ),
    CartItem(
      image: 'assets/images/Sepatu.png',
      brand: 'Nike',
      name: 'Produk Tambahan',
      size: 'L',
      amount: 1,
      price: 250.000,
    ),
  ];

  bool selectAll = false;

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var item in items) {
        item.isSelected = selectAll;
      }
    });
  }

  Widget _cartItem(int index) {
    final item = items[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          item.isSelected = !item.isSelected;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.brand, 
                    style: TextStyle(
                      fontSize: 15, 
                      color: Colors.grey[600]
                    )
                  ),
                  Text(
                    item.name, 
                    style: const TextStyle( fontSize: 17)
                  ),
                  Text(
                    item.size, 
                    style: const TextStyle(fontSize: 17)
                  ),
                  Text(
                    'Jumlah : ${item.amount}', 
                    style: const TextStyle(fontSize: 17)
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (item.amount > 1) item.amount--;
                          });
                        },
                        icon: const Icon(Icons.remove, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text('${item.amount}'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            item.amount++;
                          });
                        },
                        icon: const Icon(Icons.add, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text('Rp ${item.price.toStringAsFixed(3)}'),
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

  Widget _summaryRow(
    String label, 
    String value, 
    {bool isBold = false}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: isBold ? 
              const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            value, 
            style: isBold ? 
              const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = items.where((e) => e.isSelected).toList();
    final subtotal = selectedItems.fold(0.0, (sum, e) => sum + (e.amount * e.price));
    final total = subtotal + 15.000;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Keranjang', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Pilih Semua', 
                  style: TextStyle(
                    fontSize: 15, 
                    fontWeight: FontWeight.bold
                    )
                ),

                Checkbox(
                  value: selectAll,
                  onChanged: toggleSelectAll,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text('ITEMS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 3),
                Expanded(
                  flex: 4,
                  child: Text('DESCRIPTION', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('PRICE', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (context, index) => _cartItem(index),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _summaryRow(
                  'Subtotal (${selectedItems.length})', 
                  'Rp ${subtotal.toStringAsFixed(3)}',
                ),
                _summaryRow(
                  'Biaya Ongkir',
                  'Free'
                ),
                _summaryRow(
                  'Jasa Aplikasi', 
                  'Rp 15.000'
                ),
                const SizedBox(height: 5),

                const Divider(),
                _summaryRow(
                  'Total', 
                  'Rp ${total.toStringAsFixed(3)}', 
                  isBold: true
                ),
                const SizedBox(height: 20),
                
                SizedBox(
                  height: 58,
                  width: double.infinity,
                  child: SlideAction(
                    sliderButtonIconSize: 16,
                    text: ">>>>>> Swipe",
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    outerColor: const Color(0xFF7A8AD7),
                    innerColor: Colors.white,
                    elevation: 0,
                    borderRadius: 35,
                    onSubmit: () {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Checkout(),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}