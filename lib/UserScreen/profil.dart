import 'dart:io';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project2/UserScreen/alamat.dart';
import 'package:project2/UserScreen/favorite.dart';
import 'package:project2/UserScreen/loginRegister.dart';
import 'package:project2/UserScreen/history.dart';
import 'package:project2/graphql/mutation/UserScreen/proflUser.dart';
import 'package:project2/graphql/query/UserScreen/profilUser.dart';
import 'package:project2/main.dart';

class ProfilScreen extends StatefulWidget {
  final int idUser;
  const ProfilScreen({super.key, required this.idUser});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  File? imageGallery;
  File? imageCamera;
  File? activeImage;

  String newNama = '';
  String newNomor = '';
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';

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
  
  Future<void> getImageGallery (VoidCallback refetch) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        imageGallery = File(imagePicked.path);
        activeImage = imageGallery;
      });
      // ignore: use_build_context_synchronously
      await updateProfilFoto(context, imagePicked.path, refetch);
    }
  }

  Future<void> getImageCamera (VoidCallback refetch) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera);

    if (imagePicked != null) {
      setState(() {
        imageCamera = File(imagePicked.path);
        activeImage = imageCamera;
      });
      // ignore: use_build_context_synchronously
      await updateProfilFoto(context, imagePicked.path, refetch);
    }
  }

  void clearImage() {
    setState(() {
      imageGallery = null;
      imageCamera = null;
      activeImage = null;
    });
  }

  Future<void> updateProfilFoto(BuildContext context, String path, VoidCallback refetch) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProfilUserMutations.updateFoto),
        variables: {
          "id_user": widget.idUser,
          "profil": path,
        },
      ),
    );
    if (result.hasException) {
      if(!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal update foto: ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
    } else {
      if (!mounted) return;
      _flashyFlushbar(message: "Foto berhasil diubah!");
      refetch();
    }
  }

  Future<void> deleteProfilFoto(BuildContext context, VoidCallback refetch) async {
    await updateProfilFoto(context, "", refetch);
    if (!mounted) return;
    clearImage();
  }

  Future<void> updateProfilNama(String nama, VoidCallback refetch) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProfilUserMutations.updateNama),
        variables: {
          "id_user": widget.idUser,
          "nama": nama,
        },
      ),
    );
    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal update nama: ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _flashyFlushbar(message: "Nama berhasil diubah!");
      refetch();
    }
  }

  Future<void> updateProfilTelepon(String telepon, VoidCallback refetch) async {
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProfilUserMutations.updateTelepon),
        variables: {
          "id_user": widget.idUser,
          "telepon": telepon,
        },
      ),
    );
    if (result.hasException) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(8),
          content: Text(
            "Gagal update nomor telepon: ${result.exception.toString()}",
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(202, 0, 0, 0),
        ),
      );
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      _flashyFlushbar(message: "Nomor telepon berhasil diubah!");
      refetch();
    }
  }

  Future<void> updateProfilPassword(String newPassword, String oldPassword, VoidCallback refetch) async {
    // Ganti mutation di sini sesuai kebutuhan!
    final client = GraphQLProvider.of(context).value;
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProfilUserMutations.updatePassword),
        variables: {
          "id_user": widget.idUser,
          "password": newPassword,
          "old_password": oldPassword,
        },
      ),
    );
    if (result.hasException) {
      final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
          ? result.exception!.graphqlErrors.first.message
          : "Gagal update password";

      if (errorMessage.contains("password lama salah")) {
        _flashyFlushbar(message: "Password lama salah");
        return;
      } else {
        // Pesan error umum
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update password: $errorMessage")),
        );
        return;
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      _flashyFlushbar(message: "Password berhasil diubah!");
      refetch();
    }
  }

  Widget imagePicker ({
    required VoidCallback onTap,
    required String text,
    required IconData icon
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemprofil ({
    required String text,
    required double? fontSize,
    Color? contentColor,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: contentColor
      ),
    );
  }

  Widget navProfil ({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required Color? contentColor,
  }){
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Icon(
                    icon, 
                    color: contentColor, 
                    size: 40,
                  )
                ),
                      
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 25
                  ),
                ),

                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 148, 148, 148),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void popUp({
    required BuildContext context,
    required String titleText,
    required String labelText,
    required ValueSetter<String> onChanged,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          titleText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        content: TextField(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              const SizedBox(width: 10),
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
                onPressed: onSave,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      body: Query(
        options: QueryOptions(
          document: gql(ProfilUserQueries.getById),
          variables: {"id_user": widget.idUser},
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
                child: Text("Error: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
              )
            );
          }
          final user = result.data?['usersbyid'];
          if (user == null) {
            return Center(
              child: Container(
                color: const Color.fromARGB(202, 0, 0, 0),
                padding: const EdgeInsets.all(8),
                child: Text("user tidak ada: ${result.exception.toString()}",style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))
              )
            );
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Column(
                            children: [
                              
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 222, 221, 221),
                                          shape: BoxShape.circle
                                        ),
                                        child: ClipOval(
                                          child: (user['profil'] != null && user['profil'] != '')
                                            ? Image.file(
                                                File(user['profil']),
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 200,
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 120,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 15,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: const Color.fromARGB(255, 222, 221, 221),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                              ),
                                              builder: (context) {
                                                return FractionallySizedBox (
                                                  alignment: Alignment.topLeft,
                                                  widthFactor: 1.0,
                                                  heightFactor: (user['profil'] != null && user['profil'] != '') ? 0.415 : 0.3,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        if (user['profil'] != null && user['profil'] != '')
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5, bottom: 5),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (context) => AlertDialog(
                                                                        backgroundColor: Colors.white,
                                                                        title: const Text(
                                                                          'Apa Anda Yakin Mengapus Gambar?',
                                                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                                  child: const Text('Batal')),
                                                                              const SizedBox(width: 10),
                                                                              TextButton(
                                                                                  style: TextButton.styleFrom(
                                                                                    backgroundColor: Colors.red,
                                                                                    foregroundColor: Colors.white,
                                                                                    textStyle: const TextStyle(fontSize: 16),
                                                                                    fixedSize: const Size(100, 40),
                                                                                    shape: const RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () async{
                                                                                    await deleteProfilFoto(context, refetch!);
                                                                                      
                                                                                    // ignore: use_build_context_synchronously
                                                                                    Navigator.of(context).pop();
                                                                                    // ignore: use_build_context_synchronously
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Text('Hapus')),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    width: 150,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.circular(12)
                                                                    ),
                                                                    child: const Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Icon(Icons.delete, color: Colors.red,),
                                                                        Text(
                                                                          'Hapus Gambar',
                                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
          
                                                        imagePicker(
                                                          onTap: () async{
                                                            await getImageGallery(refetch!);
          
                                                            if (activeImage != null) {
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.of(context).pop();
                                                            }  
                                                          }, 
                                                          icon: Icons.photo_library,
                                                          text: 'Pilih Gambar'
                                                        ),
          
                                                        imagePicker(
                                                          onTap: () async{
                                                            await getImageCamera(refetch!);
          
                                                            if (activeImage != null) {
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.of(context).pop();
                                                            }  
                                                          },
                                                          icon: Icons.camera_alt,
                                                          text: 'Ambil Gambar'
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(255, 234, 234, 234),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 30,
                                              color: Color(0xFF7A8AD7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                                    
                                  const SizedBox(height: 10),
                                                    
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: itemprofil(
                                      text: user['nama'],
                                      fontSize: 23,
                                    ),
                                  ),
                                                    
                                  itemprofil(
                                    text: user['email'],
                                    fontSize: 20,
                                    contentColor: const Color.fromARGB(255, 148, 148, 148), 
                                  ),
                                                    
                                  itemprofil(
                                    text: user['telepon'],
                                    fontSize: 20,
                                    contentColor: const Color.fromARGB(255, 148, 148, 148), 
                                  )
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
              
                    navProfil(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlamatScreen(idUser: widget.idUser,)),
                        );
                      }, 
                      icon: Icons.location_on,
                      contentColor: const Color(0xFF7A8AD7),
                      text: 'Alamat Saya',
                    ),
                    
                    navProfil(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoriteScreen(idUser: widget.idUser)),
                        );
                      }, 
                      icon: Icons.favorite,
                      contentColor: const Color(0xFF7A8AD7),
                      text: 'Favorite Saya',
                    ),
              
                    navProfil(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => HistoryScreen(idUser: widget.idUser,)), 
                        );
                      }, 
                      icon: Icons.history, 
                      contentColor: const Color(0xFF7A8AD7),
                      text: 'Riwayat Pembelian',
                    ),
          
                    navProfil(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color.fromARGB(255, 222, 221, 221),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 18, bottom: 8, right: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Setingan',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(thickness: 2),
                                      
                                      const SizedBox(height: 10),
                                      
                                      navProfil(
                                        onTap: () {
                                          popUp(
                                            context: context, 
                                            titleText: 'Ubah Nama', 
                                            labelText: 'Nama Baru', 
                                            onChanged: (value) {
                                              newNama = value;
                                            }, 
                                            onSave: () async{
                                              if (newNama.isEmpty){
                                                _flashyFlushbar(message: "Field wajib diisi!");
                                                return;
                                              }
                                              await updateProfilNama(newNama, refetch!);
                                            }
                                          );
                                        },
                                        icon: Icons.edit_note_sharp, 
                                        text: 'Ubah Nama', 
                                        contentColor: Colors.black,
                                      ),
                                  
                                      navProfil(
                                        onTap: () {
                                          popUp(
                                            context: context, 
                                            titleText: 'Ubah Nomor Telepon', 
                                            labelText: 'Nomor Telepon Baru', 
                                            onChanged: (value) {
                                              newNomor = value;
                                            }, 
                                            onSave: () async{
                                              if (newNomor.isEmpty){
                                                _flashyFlushbar(message: "Field wajib diisi!");
                                                return;
                                              }
                                              await updateProfilTelepon(newNomor, refetch!);
                                            }
                                          );
                                        }, 
                                        icon: Icons.phone, 
                                        text: 'Ubah Nomor Telepon', 
                                        contentColor: Colors.black,
                                      ),
                                  
                                      navProfil(
                                        onTap: () {
          
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text(
                                                'Ubah Password',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      obscureText: true,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Password Sekarang',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) => oldPassword = value,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextField(
                                                      obscureText: true,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Password Baru',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) => newPassword = value,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextField(
                                                      obscureText: true,
                                                      decoration: const InputDecoration(
                                                        labelText: 'Konfirmasi Password Baru',
                                                        border: OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) => confirmPassword = value,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.black,
                                                    textStyle: const TextStyle(fontSize: 16),
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                    ),
                                                  ),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text('Batal'),
                                                ),
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
                                                  onPressed: () async{
                                                    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty){
                                                      _flashyFlushbar(message: "Semua field wajib diisi!");
                                                      return;
                                                    }

                                                    if (newPassword.length < 8) {
                                                      _flashyFlushbar(message: "Password minimal 8 karakter!");
                                                      return;
                                                    }

                                                    if (newPassword != confirmPassword) {
                                                      _flashyFlushbar(message: "Password tidak sama");
                                                      return;
                                                    }
                                                    await updateProfilPassword(newPassword, oldPassword, refetch!);
                                                  },
                                                  child: const Text('Simpan'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icons.password,
                                        text: 'Ubah Password',
                                        contentColor: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }, 
                      icon: Icons.settings, 
                      contentColor: const Color(0xFF7A8AD7),
                      text: 'Setingan',
                    ),
              
                    const Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 10),
                      child: Divider(thickness: 2,),
                    ),
                    
                    navProfil(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Row(
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.red, size: 26),
                                SizedBox(width: 8),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            content: const Text(
                              'Apakah Anda yakin ingin keluar dari akun Anda?',
                              style: TextStyle(fontSize: 18),
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
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Batal')
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 16),
                                      fixedSize: const Size(100, 40),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      navigatorKey.currentState?.pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => FirstScreen(
                                            value: true,
                                            onChanged: (newValue) {},
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text('Keluar')
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }, 
                      icon: Icons.exit_to_app, 
                      contentColor: Colors.red,
                      text: 'Log Out',
                    ),
                  ],
                ),
              ),
            )
          );
        }
      ),
    );
  }
}