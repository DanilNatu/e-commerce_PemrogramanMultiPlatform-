// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/graphql/mutation/UserScreen/alamat.dart';
import 'package:project2/graphql/query/UserScreen/alamat.dart';

class AlamatScreen extends StatefulWidget {
  final int idUser;
  const AlamatScreen({super.key, required this.idUser});

  @override
  State<AlamatScreen> createState() => _AlamatScreenState();
}

class _AlamatScreenState extends State<AlamatScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  int? editingIndex;
  int selectedIndex = 0;

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

  Future<void> deleteAlamat(BuildContext context,int idAlamatToDelete,) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(AlamatMutations.delete),
        variables: {"id_alamat": idAlamatToDelete},
      ),
    );

    if (!mounted) return;

    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text("Gagal hapus alamat: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
          backgroundColor: const Color.fromARGB(202, 0, 0, 0)
        ),
      );
    } else {
      _flashyFlushbar(message: "Alamat berhasil dihapus !");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future<void> tambahAtauUpdateAlamat({int? idAlamat, VoidCallback? refetch}) async {
    final client = GraphQLProvider.of(context).value;

    if (idAlamat == null) {
      // Cek dulu apakah user sudah punya alamat
      final existingAlamatResult = await client.query(
        QueryOptions(
          document: gql(AlamatQueries.getAll),
          variables: {"id_alamat": widget.idUser},
        ),
      );

      final List alamat = existingAlamatResult.data?['alamats'] ?? [];
      List filtered = alamat.where((item) {
        if(item['id_user'] != widget.idUser) return false;
        return true;
      }).toList();

      final bool isFirstAlamat = filtered.isEmpty;

      // CREATE
      final result = await client.mutate(
        MutationOptions(
          document: gql(AlamatMutations.create),
          variables: {
            "namaA": namaController.text,
            "teleponA": teleponController.text,
            "alamat": alamatController.text,
            "id_user": widget.idUser,
            "alamat_utama": isFirstAlamat,
          },
        ),
      );

      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(8),
            content: Text("Gagal tambah alamat: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
            backgroundColor: const Color.fromARGB(202, 0, 0, 0)
          ),
        );
      } else {
        _flashyFlushbar(message: "Alamat berhasil ditambahkan!");
      }
    } else {
      // UPDATE
      final result = await client.mutate(
        MutationOptions(
          document: gql(AlamatMutations.update),
          variables: {
            "id_alamat": idAlamat,
            "namaA": namaController.text,
            "teleponA": teleponController.text,
            "alamat": alamatController.text,
          },
        ),
      );

      if (result.hasException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(8),
            content: Text("Gagal ubah alamat: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
            backgroundColor: const Color.fromARGB(202, 0, 0, 0)
          ),
        );
      } else {
        _flashyFlushbar(message: "Alamat berhasil diubah!");
      }
    }

    refetch?.call();
    Navigator.of(context).pop();
  }


  Future<void> setDefaultAlamat(int idAlamat) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(AlamatMutations.setDefault),
        variables: {
          "id_alamat": idAlamat,
          "id_user": widget.idUser,
        },
      ),
    );

    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
            padding: const EdgeInsets.all(8),
            content: Text("Gagal set default: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)), 
            backgroundColor: const Color.fromARGB(202, 0, 0, 0)
          ),
      );
    } else {
      _flashyFlushbar(message: "Alamat utama berhasil diubah!");
    }
  }


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
        backgroundColor: Colors.white,
        title: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: onPressed2,
                  child: Text(opsi2)),
            ],
          )
        ],
      ),
    );
  }

  Widget alamatItem(Map item, int index, VoidCallback refetch) {

    final isSelected = item['alamat_utama'] == true;
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
                  onPressed2: () async {
                    await setDefaultAlamat(item['id_alamat']);
                    refetch();
                    setState(() {});
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
                                    item['namaA'],
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
                                    item['teleponA'],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 129, 129, 129),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['alamat'],
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
                              existingAlamat: item, idAlamat: item['id_alamat'], refetch: refetch);
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
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    'Alamat utama tidak dapat dihapus!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color(0xFF7A8AD7),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(fontSize: 16),
                                        fixedSize: const Size(100, 40),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
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
                                onPressed2: () async {
                                  setState(() {
                                    if (selectedIndex > index) {
                                      selectedIndex--;
                                    }
                                  });
                                  final int idAlamat = item['id_alamat'];
                                  await deleteAlamat(context, idAlamat);
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

  void showAlamatBottomSheet({Map? existingAlamat, int? idAlamat, VoidCallback? refetch}) {
    if (existingAlamat != null) {
      namaController.text = existingAlamat['namaA'];
      teleponController.text = existingAlamat['teleponA'];
      alamatController.text = existingAlamat['alamat'];
    } else {
      namaController.clear();
      teleponController.clear();
      alamatController.clear();
      editingIndex = null;
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FractionallySizedBox(
            heightFactor: 0.520,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        tambahAlamat(
                          controller: namaController,
                          text: 'Nama',
                          hintText: 'Masukkan Nama',
                        ),
                        tambahAlamat(
                          controller: teleponController,
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
                            if (alamatController.text.isEmpty || 
                                namaController.text.isEmpty || 
                                teleponController.text.isEmpty) {
                              _flashyFlushbar(message: "Semua field wajib diisi!");
                              return;
                            }
                  
                            final telepon = teleponController.text.trim();
                            final teleponRegExp = RegExp(r'^[0-9]+$');
                            if (!teleponRegExp.hasMatch(telepon)) {
                              _flashyFlushbar(message: "Nomor telepon hanya boleh angka");
                              return;
                            }
                            
                            tambahAtauUpdateAlamat(idAlamat: idAlamat, refetch: refetch);
                          },
                          child: Text(
                            idAlamat != null ? 'Simpan Perubahan' : 'Tambahkan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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
      body: Query(
        options: QueryOptions(
          document: gql(AlamatQueries.getAll),
          variables: {"id_alamat": widget.idUser},
          pollInterval: const Duration(seconds: 5),
          fetchPolicy: FetchPolicy.noCache, 
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(
              child: Container(
                color: const Color.fromARGB(202, 0, 0, 0),
                padding: const EdgeInsets.all(8),
                child: Text("Gagal upload alamat: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
              )
            );
          }

          final List alamat = result.data?['alamats'] ?? [];

          List filtered = alamat.where((item) {
            if(item['id_user'] != widget.idUser) return false;
            return true;
          }).toList();

          // Sort agar yang default muncul paling atas
          filtered.sort((a, b) {
            final int aDefault = a['alamat_utama'] == true ? 1 : 0;
            final int bDefault = b['alamat_utama'] == true ? 1 : 0;
            return bDefault.compareTo(aDefault);
          });

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filtered.length,
            itemBuilder: (context, index) => alamatItem(filtered[index], index, refetch!),
          );
        }

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
