import 'package:flutter/material.dart';
import 'package:project2/screen/checkout.dart';
import 'package:project2/screen/keranjang.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final bool isInitiallyFavorite;
  const DetailScreen({
    super.key,
    this.isInitiallyFavorite = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedSize = 'null';
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  late bool _isfavorite;
  int amount = 1;

  @override
  void initState() {
    super.initState();
    _isfavorite = widget.isInitiallyFavorite;
  }

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    const double unitPrice = 125000;
    final double total = unitPrice * amount;
    final bool isSizeSelected = selectedSize != '' && selectedSize != 'null';

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
                      child: Image.asset(
                        'assets/images/Baju.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Adidas Tshirt Oversize',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    'Material : cotton 24 s, Plastisol ink, Oversize Regular, Unisex \n \nSpesifikasi',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  )
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
                    const Text(
                      'Pilih Ukuran:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        _isfavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isfavorite
                            ? const Color.fromARGB(255, 242, 15, 83)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isfavorite = !_isfavorite;
                        });
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    children: sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return ChoiceChip(
                        label: Text(size),
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
                      width: 65,
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart, size: 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KeranjangScreen(),
                            ),
                          );
                        },
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
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckoutScreen(),
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
