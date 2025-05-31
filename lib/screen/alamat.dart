import 'package:flutter/material.dart';

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

class AlamatScreen extends StatefulWidget {
  const AlamatScreen({super.key});

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  int? editingIndex;
  int selectedIndex = 0;

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

  Widget tambahAlamat({
    required TextEditingController controller,
    required String text,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 5),
            child: Text(
              text,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void popUp(
      {required BuildContext context,
      required String text,
      required String opsi2,
      required Color? contentColor,
      required VoidCallback onPressed1,
      required VoidCallback onPressed2}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 60, 60),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    fixedSize: const Size(100, 40),
                  ),
                  onPressed: onPressed1,
                  child: const Text('Batal')),
              const SizedBox(width: 10),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: contentColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                    fixedSize: const Size(100, 40),
                  ),
                  onPressed: onPressed2,
                  child: Text(opsi2)),
            ],
          )
        ],
      ),
    );
  }

  Widget alamatItem(int index) {
    final location = locations[index];
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: isSelected
          ? null
          : () {
              popUp(
                context: context,
                text: 'Jadikan sebagai alamat utama?',
                opsi2: 'Ubah',
                contentColor: const Color(0xFF7A8AD7),
                onPressed1: () => Navigator.of(context).pop(),
                onPressed2: () {
                  setState(() {
                    final lokasi = locations.removeAt(index);
                    locations.insert(0, lokasi);
                    selectedIndex = 0;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                        child: isSelected
                            ? const Icon(Icons.location_on, color: Colors.red)
                            : const SizedBox.shrink(),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  location.nama,
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
                                  location.nomor,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 129, 129, 129),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              location.alamat,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showAlamatBottomSheet(
                              existingAlamat: location, index: index);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xFF7A8AD7),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (index == selectedIndex) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Alamat utama tidak dapat dihapus!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                actions: [
                                  const Divider(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF7A8AD7),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 16),
                                      fixedSize: const Size(100, 40),
                                    ),
                                    child: const Text('Oke'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  )
                                ],
                              ),
                            );
                          } else {
                            popUp(
                              context: context,
                              text: 'Hapus Alamat?',
                              opsi2: 'Hapus',
                              contentColor: Colors.red,
                              onPressed1: () => Navigator.of(context).pop(),
                              onPressed2: () {
                                setState(() {
                                  locations.removeAt(index);
                                  if (selectedIndex > index) {
                                    selectedIndex--;
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Hapus',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlamatBottomSheet({Alamat? existingAlamat, int? index}) {
    if (existingAlamat != null) {
      namaController.text = existingAlamat.nama;
      phoneController.text = existingAlamat.nomor;
      alamatController.text = existingAlamat.alamat;
      editingIndex = index;
    } else {
      namaController.clear();
      phoneController.clear();
      alamatController.clear();
      editingIndex = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.60,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Form Alamat',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(thickness: 2),
              tambahAlamat(
                controller: namaController,
                text: 'Nama',
                hintText: 'Masukkan Nama',
              ),
              tambahAlamat(
                controller: phoneController,
                text: 'Nomor Telepon',
                hintText: '08xxxx',
              ),
              tambahAlamat(
                controller: alamatController,
                text: 'Alamat',
                hintText: 'Masukkan Alamat Lengkap',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 123, 138, 215),
                  fixedSize: const Size(370, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                onPressed: () {
                  final newAlamat = Alamat(
                    nama: namaController.text,
                    nomor: phoneController.text,
                    alamat: alamatController.text,
                  );

                  setState(() {
                    if (editingIndex != null) {
                      locations[editingIndex!] = newAlamat;
                    } else {
                      locations.add(newAlamat);
                    }
                  });

                  Navigator.of(context).pop();
                },
                child: Text(
                  editingIndex != null ? 'Simpan Perubahan' : 'Tambahkan',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      appBar: AppBar(
        title: const Text('Alamat'),
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
        itemCount: locations.length,
        itemBuilder: (context, index) => alamatItem(index),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          showAlamatBottomSheet();
        },
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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle, color: Color(0xFF7A8AD7)),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Alamat Baru',
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xFF7A8AD7),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
