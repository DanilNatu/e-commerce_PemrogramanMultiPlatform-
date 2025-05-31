import 'package:flutter/material.dart';
import 'package:project2/screen/checkout.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';

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
  bool isEditMode = true;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  List<CartItem> items = [
    CartItem(
      image: 'assets/images/Baju.png',
      brand: 'Adidas',
      name: 'Tshirt Oversize ',
      size: 'M',
      amount: 2,
      price: 125000,
    ),
    CartItem(
      image: 'assets/images/Polo.png',
      brand: 'Polo King',
      name: 'Kaos Polo',
      size: 'L',
      amount: 1,
      price: 150000,
    ),
    CartItem(
      image: 'assets/images/Tas.png',
      brand: 'SmithBerlin',
      name: 'Tas Ransel',
      size: 'Black',
      amount: 1,
      price: 200000,
    ),
    CartItem(
      image: 'assets/images/Celana.png',
      brand: 'Jeans',
      name: 'Celana Panjang',
      size: 'M',
      amount: 1,
      price: 175000,
    ),
    CartItem(
      image: 'assets/images/Sepatu.png',
      brand: 'Nike',
      name: 'Produk Tambahan',
      size: 'L',
      amount: 1,
      price: 250000,
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
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (bool? newValue) {
                setState(() {
                  item.isSelected = newValue ?? false;
                });
              },
            ),
        
            SizedBox(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(item.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 7),
            Column(
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
                                setState(() {
                                  if (item.amount > 1) item.amount--;
                                });
                              },
                              icon: const Icon(Icons.remove, size: 16),
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          SizedBox(
                            width: 17,
                            child: Center(child: Text('${item.amount}'))
                          ),

                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  item.amount++;
                                  }
                                );
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
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatter.format(item.amount * item.price).replaceAll('Rp', ''),
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7A8AD7),
                            ),
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

  Widget _summaryRow(
    String label, 
    double price,
  ) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),

        const SizedBox(width: 10),
        const Text(
          'Rp',
          style: TextStyle(
            color: Color(0xFF7A8AD7),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Text(
          formatter.format(price).replaceAll('Rp', ''),
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 23, 
            color: Color(0xFF7A8AD7),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = items.where((e) => e.isSelected).toList();
    final int totalQuantity = selectedItems.fold(0, (sum, item) => sum + item.amount);
    final subtotal = selectedItems.fold(0.0, (sum, e) => sum + (e.amount * e.price));
    final total = subtotal;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Keranjang (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold)),

            GestureDetector(
              onTap: () {
                setState(() {
                  isEditMode = !isEditMode;
                });
              },
              child: Text(isEditMode ? 'Ubah' : 'Selesai' ),
            )

          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2), 
          child: Container(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              itemCount: items.length,
              itemBuilder: (context, index) => _cartItem(index),
            ),
          ),
        ],
      ),

      bottomNavigationBar: isEditMode
        ? Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: selectAll,
                            onChanged: toggleSelectAll,
                          ),
                          const Text(
                            'Pilih Semua',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      _summaryRow(
                        'Total ($totalQuantity)',
                        total,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AbsorbPointer(
                    absorbing: selectedItems.isEmpty,
                    child: Opacity(
                      opacity: selectedItems.isEmpty ? 0.5 : 1.0,
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
                        elevation: 0,
                        borderRadius: 35,
                        onSubmit: () async {
                          await Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: selectAll,
                        onChanged: toggleSelectAll,
                      ),
                      const Text(
                        'Pilih Semua',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: AbsorbPointer(
                    absorbing: selectedItems.isEmpty,
                    child: Opacity(
                      opacity: selectedItems.isEmpty ? 0.5 : 1.0,
                      child: SlideAction(
                        height: 58,
                        sliderButtonIconSize: 16,
                        text: ">>>>>> Hapus",
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        outerColor: Colors.red,
                        innerColor: Colors.white,
                        elevation: 0,
                        borderRadius: 35,
                        onSubmit: () async {
                          if (selectedItems.isEmpty) return;
                            setState(() {
                              items.removeWhere((item) => item.isSelected);
                            });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
    );
  }
}