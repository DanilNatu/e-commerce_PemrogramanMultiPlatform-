import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project2/screen/alamat.dart';
import 'package:project2/screen/history.dart';
import 'package:project2/widget/bottonNavigation.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CartItem {
  final String image;
  final String name;
  final String size;
  final String warna;
  int amount;
  final double price;

  CartItem({
    required this.image,
    required this.name,
    required this.size,
    required this.warna,
    required this.amount,
    required this.price,
  });
}

class Alamat {
  final String nama;
  final String nomor;
  final String alamat;

  Alamat({
    required this.nama,
    required this.nomor,
    required this.alamat,
  });
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
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
    ),
    CartItem(
      image: 'assets/images/Polo.png',
      name: 'Kaos Polo',
      size: 'L',
      warna: 'Coklat Muda',
      amount: 3,
      price: 150000,
    ),
    CartItem(
      image: 'assets/images/Sepatu.png',
      name: 'Produk Tambahan',
      size: 'L',
      warna: 'Hitam',
      amount: 1,
      price: 250000,
    ),
  ];

  List<String> metodePembayaran = ['Bank BCA (232362543254)', 'Bank BRI (1654745468)', 'Bank BNI (451414676)'];
  String selectedPembayaran = '';

  List<String> metodePengiriman = ['Jnt Standard | 3-4 days', 'SiCepat | 5-6 days', 'JnE | 3-5 days'];
  String selectedPengiriman = '';

  List<String> metodeVoucher = ['Gratis Ongkir', 'Potongan Rp20.000'];
  List<String> selectedVouchers = [];

  bool get isFreeShipping => selectedVouchers.contains('Gratis Ongkir');
  bool get hasDiscount => selectedVouchers.contains('Potongan Rp20.000');

  double get potonganVoucher {
    if (selectedVouchers.contains('Potongan Rp20.000')) {
      return 20000;
    }
    return 0;
  }

  String get selectedVoucher {
    return selectedVouchers.isNotEmpty ? selectedVouchers.first : '';
  }

  List<Alamat> locations = [
    Alamat(
      nama: 'Arfian', 
      nomor: '(+62) 85434123412', 
      alamat: 'Gang Elang, No.100',
    ),
    Alamat(
      nama: 'Riyo', 
      nomor: '(+62) 82145367891', 
      alamat: 'Tukad Badung, No.99',
    )
  ];
  
  late Alamat selectedAlamat;

  @override
  void initState() {
    super.initState();
    selectedAlamat = locations.first;
  }

  Widget _itemcheckout({
    required String label,
    required Widget text,
    required Color? contentColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        label, 
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      const Spacer(),
                      const Icon(
                        size: 17,
                        color: Color.fromARGB(255, 129, 129, 129),
                        Icons.arrow_forward_ios,
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: contentColor, 
                      fontSize: 16
                    ), 
                    child: text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardItems(int index) {
    final item = items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
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
    );
  }

  Widget _summaryRow(
    String label, 
    String value
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(fontSize: 16)
          ),
          Text(
            value, 
            style: const TextStyle(fontSize: 16)
          ),
        ],
      ),
    );
  }

  void showSelectionModal({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String) onItemSelected,
    IconData? icon,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.35,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const AlamatScreen())
                        );
                      }, 
                      icon: Icon(icon, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 2),
              Expanded(
                child: ListView(
                  children: items.map((item) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      title: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        onItemSelected(item);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jumlahitem = items.fold(0, (sum, item) => sum + item.amount);
    final subtotal = items.fold(0.0, (sum, item) => sum + item.amount * item.price);
    const jasaAplikasi = 15000;
    const ongkir = 10000;

    // Fixed total calculation
    final ongkirCost = isFreeShipping ? 0 : ongkir;
    final total = subtotal + jasaAplikasi + ongkirCost - potonganVoucher;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text(
          'Checkout', 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
          children: [
            _itemcheckout(
              label: 'Alamat',
              text: selectedAlamat.nama.isNotEmpty 
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 30,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedAlamat.nama,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text(
                                '|',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 129, 129, 129),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(
                              selectedAlamat.nomor,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 129, 129, 129),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedAlamat.alamat,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ) : const Text('Tambahkan Alamat Pengiriman'),
              contentColor: selectedAlamat.nama.isNotEmpty ? Colors.black : Colors.grey,
              onTap: () {
                showSelectionModal(
                  context: context,
                  title: 'Pilih Alamat Pengiriman',
                  items: locations.map((a) => '${a.nama}\n${a.nomor}\n${a.alamat}').toList(),
                  onItemSelected: (selected) {
                    final alamat = locations.firstWhere((a) => '${a.nama}\n${a.nomor}\n${a.alamat}' == selected);
                    setState(() {
                      selectedAlamat = alamat;
                    });
                  },
                  icon: Icons.add,
                );
              },
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: items.length,
              itemBuilder: (context, index) => _cardItems(index),
            ),

            _itemcheckout(
              label: 'Metode Pembayaran', 
              text: selectedPembayaran.isEmpty ? const Text('Pilih Metode Pembayaran') : Text(selectedPembayaran), 
              contentColor: selectedPembayaran.isEmpty ? Colors.grey : Colors.black, 
              onTap: () {
                showSelectionModal(
                  context: context, 
                  title: 'Pilih Metode Pembayaran', 
                  items: metodePembayaran, 
                  onItemSelected: (metode) {
                    setState(() {
                      selectedPembayaran = metode;
                    });
                  }
                );
              }
            ),

            _itemcheckout(
              label: 'Metode Pengiriman', 
              text: selectedPengiriman.isEmpty ? const Text('Pilih Metode Pengiriman') : Text(selectedPengiriman), 
              contentColor: selectedPengiriman.isEmpty ? Colors.grey : Colors.black, 
              onTap: () {
                showSelectionModal(
                  context: context, 
                  title: 'Pilih Metode Pengiriman', 
                  items: metodePengiriman, 
                  onItemSelected: (metode) {
                    setState(() {
                      selectedPengiriman = metode;
                    });
                  }
                );
              }
            ),

            _itemcheckout(
              label: 'Voucher', 
              text: selectedVouchers.isNotEmpty ? Text(selectedVouchers.join('\n')) : const Text('Pilih Voucher'), 
              contentColor: selectedVouchers.isNotEmpty ? Colors.black : const Color.fromARGB(255, 129, 129, 129),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor:  const Color.fromARGB(255, 222, 221, 221),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    final List<String> tempSelected = List.from(selectedVouchers);
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return FractionallySizedBox(
                          heightFactor: 0.35,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Pilih Voucher',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const Divider(thickness: 2),
                              Expanded(
                                child: ListView(
                                  children: metodeVoucher.map((voucher) {
                                    final isSelected = tempSelected.contains(voucher);
                                    return Card(
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      child: CheckboxListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            voucher,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        value: isSelected,
                                        onChanged: (value) {
                                          setModalState(() {
                                            if (value == true) {
                                              tempSelected.add(voucher);
                                            } else {
                                              tempSelected.remove(voucher);
                                            }
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, tempSelected);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7A8AD7),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Pilih',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ).then((value) {
                  if (value != null && value is List<String>) {
                    setState(() {
                      selectedVouchers = value;
                    });
                  }
                });
              }
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              'Rincian Pembayaran', 
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            _summaryRow(
                              'Subtotal ($jumlahitem)', 
                              formatter.format(subtotal),
                            ),
                            _summaryRow(
                              'Biaya Ongkir',
                              isFreeShipping ? 'Free' : formatter.format(ongkir),
                            ),
                            if (hasDiscount)
                              _summaryRow(
                                'Voucher Diskon',
                                '- ${formatter.format(potonganVoucher)}',
                              ),
                            _summaryRow(
                              'Jasa Aplikasi', 
                              formatter.format(jasaAplikasi)
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),   
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
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(width: 10),

                    const Text(
                      'Rp',
                      style: TextStyle(
                        color: Color(0xFF7A8AD7),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      formatter.format(total).replaceAll('Rp', ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 23, 
                        color: Color(0xFF7A8AD7)
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AbsorbPointer(
                    absorbing: selectedPembayaran.isEmpty || selectedPengiriman.isEmpty,
                    child: Opacity(
                      opacity: selectedPembayaran.isEmpty || selectedPengiriman.isEmpty ? 0.5 : 1.0,
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
                        borderRadius: 35,
                        onSubmit: () async {
                          await Future.delayed(const Duration(milliseconds: 500), () {
                            showDialog(
                              barrierDismissible: false,
                              // ignore: use_build_context_synchronously
                              context: context, 
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 50),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 123, 138, 215),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/Sukses.png',
                                          height: 150,
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Pembelian\nSukses',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                        const SizedBox(height: 35),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            minimumSize: const Size(250, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13), 
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context, 
                                              MaterialPageRoute(builder: (context) => const BottonNavigation()),
                                              (route) => false,
                                            );
                                          }, 
                                          child: const Text(
                                            'Lanjut Belanja',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 123, 138, 215),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ),
                                        const SizedBox(height: 15),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const HistoryScreen(),
                                              ),
                                              (route) => route.isFirst,
                                            );
                                          },
                                          child: const Text(
                                            'Lihat Detail Belanja',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}