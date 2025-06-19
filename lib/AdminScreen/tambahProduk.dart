import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project2/AdminScreen/Widget/bottomNavAdmin.dart';
import 'package:project2/graphql/mutation/AdminScreen/product.dart';
import 'package:flashy_flushbar/flashy_flushbar.dart';

class TambahProdukScreen extends StatefulWidget {
  final int idPenjual;
  final Map? product;
  final bool isEdit;

  const TambahProdukScreen({super.key, this.product, this.isEdit = false, required this.idPenjual});

  @override
  State<TambahProdukScreen> createState() => _TambahProdukScreenState();
}

class _TambahProdukScreenState extends State<TambahProdukScreen> {
  File? _imageFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController prizeController = TextEditingController();
  final TextEditingController warnaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  final List<String> categories = ['Baju', 'Celana', 'Tas', 'Sepatu'];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.product != null) {
      final p = widget.product!;
      selectedCategory = p['kategori'];
      if (p['image'] != null && !p['image'].toString().startsWith('assets/')) {
        _imageFile = File(p['image']);
      }
      nameController.text = p['name'] ?? '';
      sizeController.text = p['size'] ?? '';
      brandController.text = p['brand'] ?? '';
      prizeController.text = p['price']?.toString() ?? '';
      warnaController.text = p['warna'] ?? '';
      stokController.text = p['stok']?.toString() ?? '';
      descriptionController.text = p['deskripsi'] ?? '';
    }
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _flashyFlushbar ({required String message})
  {
    return FlashyFlushbar(
      leadingWidget: const Icon(
        Icons.error_outline,
        color: Colors.black,
        size: 24,
      ),
      message: message,
      duration: const Duration(seconds: 2),
      trailingWidget: const IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
          size: 24,
        ),
        onPressed: FlashyFlushbar.cancel,
      ), 
      isDismissible: false,
    ).show();
  }

  Widget _buildEditableField(String label, String? hinttext, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          helperText: hinttext?.isNotEmpty == true ? hinttext : null,
          helperStyle: const TextStyle(fontSize: 13),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        )
      ),
    );
  }

  Future<void> _submitProdukKeGraphQL() async {
    final client = GraphQLProvider.of(context).value;

    // Tentukan mutation dan variabel sesuai mode
    final bool isEdit = widget.isEdit;
    final mutation = isEdit ? ProductMutations.update : ProductMutations.create;
    final variables = isEdit
        ? {
            "idProduct": widget.product!['id_product'],
            "kategori": selectedCategory!,
            "name": nameController.text,
            "size": sizeController.text,
            "deskripsi": descriptionController.text,
            "brand": brandController.text,
            "price": int.parse(prizeController.text),
            "image": _imageFile!.path,
            "warna": warnaController.text,
            "stok": int.parse(stokController.text),
          }
        : {
            "idPenjual": widget.idPenjual,
            "kategori": selectedCategory!,
            "name": nameController.text,
            "size": sizeController.text,
            "deskripsi": descriptionController.text,
            "brand": brandController.text,
            "price": int.parse(prizeController.text),
            "image": _imageFile!.path,
            "warna": warnaController.text,
            "stok": int.parse(stokController.text),
          };

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables,
      ),
    );

    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text("Gagal upload produk ke server: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
          backgroundColor: const Color.fromARGB(202, 0, 0, 0)
        ),
      );
    } else {
      _flashyFlushbar(message: isEdit ? 'Produk berhasil diperbarui!' : 'Produk berhasil ditambahkan!');
      // Balik ke home
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => BottonNavAdmin(initialIndex: 0, idPenjual: widget.idPenjual),
        ),
        (route) => false,
      );
    }
  }


  void _uploadData() async {
    // Validasi default
    if (selectedCategory == null ||
      nameController.text.isEmpty ||
      ((selectedCategory != 'Tas') && sizeController.text.isEmpty) ||
      brandController.text.isEmpty ||
      prizeController.text.isEmpty ||
      stokController.text.isEmpty ||
      descriptionController.text.isEmpty ||
      _imageFile == null ||
      warnaController.text.isEmpty) {
        _flashyFlushbar(message: "Semua field harus diisi dan gambar harus dipilih.");
        return;
      }

    if (selectedCategory == 'Tas') {
      sizeController.text = '';
    }

    // ADD dan EDIT logika sama: kirim ke GraphQL
    await _submitProdukKeGraphQL();

    // ignore: use_build_context_synchronously
    _flashyFlushbar(message: widget.isEdit ? 'Produk berhasil diperbarui!' : 'Produk berhasil ditambahkan!');

    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => BottonNavAdmin(initialIndex: 0, idPenjual: widget.idPenjual),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Produk' : 'Upload Produk'),
        centerTitle: true,
        backgroundColor: const Color(0xFF7A8AD7),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (widget.isEdit && widget.product != null && (widget.product!['image']?.toString().startsWith('assets/') ?? false)
                                ? AssetImage(widget.product!['image'])
                                : (widget.product != null && widget.product!['image'] != null
                                    ? FileImage(File(widget.product!['image']))
                                    : const AssetImage('assets/images/noimage.png'))) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: (_imageFile == null && (widget.product?['image']?.isEmpty ?? true))
                          ? const Center(
                              child: Text(
                                'Masukkan Gambar Produk',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A8AD7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Pilih Gambar'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pilih Kategori
            DropdownMenu<String>(
              width: double.infinity,
              label: const Text('Pilih Kategori'),
              initialSelection: selectedCategory,
              onSelected: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              dropdownMenuEntries: categories
                  .map((cat) => DropdownMenuEntry<String>(value: cat, label: cat,))
                  .toList(),
              menuStyle: MenuStyle(
                backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
                padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
                fixedSize: const WidgetStatePropertyAll(Size(378, 215)),  
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),


            const SizedBox(height: 12),

            _buildEditableField('Nama', '',nameController),
            _buildEditableField('Brand', '',brandController),
            if (selectedCategory != 'Tas') _buildEditableField('SIZE','Contoh: L atau S,L,M atau 40,41,42 (Jangan Pakai Spasi)', sizeController),
            _buildEditableField('Harga', '',prizeController),
            _buildEditableField('Warna', '',warnaController),
            _buildEditableField('Stok', '',stokController),
            const SizedBox(height: 12),

            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Tuliskan deskripsi produk...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _uploadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A8AD7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.isEdit ? 'Simpan Perubahan' : 'Upload Produk'),
            ),
          ],
        ),
      ),
    );
  }
}
