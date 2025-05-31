import 'package:flutter/material.dart';
import 'package:project2/screen/keranjang.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedSize = 'null';
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  bool _isfavorite = false;
  int amount = 1;

  @override
  Widget build(BuildContext context) {
    final double unitPrice = 125000;
    final double total = unitPrice * amount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://contents.mediadecathlon.com/p2157319/k45a8143f29ae498e05be9c1588d95135/kaos-running-dry-fit-baju-lari-pria-breathable-hitam-decathlon-8488034.jpg?f=1920x0&format=auto',
                height: 250,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adidas Tshirt Oversize',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Material : cotton 24 s\nPlastisol ink\nOversize Regular\nUnisex',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    return ChoiceChip(
                      label: Text(size),
                      selected: selectedSize == size,
                      onSelected: (selected) {
                        setState(() {
                          selectedSize = size;
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                        Text('$amount'),
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
                  Text(
                    'Rp ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
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
                            builder: (context) => KeranjangScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
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
                      onSubmit: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KeranjangScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
