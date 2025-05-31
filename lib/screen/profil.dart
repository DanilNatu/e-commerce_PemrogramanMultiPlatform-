import 'package:flutter/material.dart';
import 'package:project2/alamat.dart';
import 'package:project2/favorite.dart';
import 'package:project2/screen/first.dart';
import 'package:project2/screen/history.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late String userName;
  late String userEmail;
  late String userNomor;

  @override
  void initState() {
    super.initState();
    userName = 'Arfian Sarianto Pendang';
    userEmail = 'arfian@gmail.com';
    userNomor = '(+62) 85434123412';
  }

  bool isLogin = true;

  String newNama = '';
  String newNomor = '';

  Widget itemprofil ({
    required String text,
    required double? fontSize,
    Color? contentColor,
  }) {
    return Text(
      text,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          
                          Column(
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  const CircleAvatar(
                                    radius: 100,
                                    foregroundImage: AssetImage('assets/images/Avatar.png'),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 15,
                                    child: GestureDetector(
                                      onTap: () {},
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
                                  text: userName, 
                                  fontSize: 23,
                                ),
                              ),
                                                
                              itemprofil(
                                text: userEmail, 
                                fontSize: 20,
                                contentColor: const Color.fromARGB(255, 148, 148, 148), 
                              ),
                                                
                              itemprofil(
                                text: userNomor, 
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
                      MaterialPageRoute(builder: (context) => const AlamatScreen()), 
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
                      MaterialPageRoute(builder: (context) => const FavoriteScreen()), 
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
                      MaterialPageRoute(builder: (context) => const HistoryScreen()), 
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      backgroundColor: Colors.white,
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
                                        onSave: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            userName = newNama;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Nama berhasil diubah')),
                                          );
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
                                        onSave: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            userNomor = newNomor;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Nomor telepon berhasil diubah')),
                                          );
                                        }
                                      );
                                    }, 
                                    icon: Icons.phone, 
                                    text: 'Ubah Nomor Telepon', 
                                    contentColor: Colors.black,
                                  ),
                              
                                  navProfil(
                                    onTap: () {
                                      String currentPassword = '';
                                      String newPassword = '';
                                      String confirmPassword = '';

                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
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
                                                  onChanged: (value) => currentPassword = value,
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
                                                backgroundColor: const Color.fromARGB(255, 60, 60, 60),
                                                foregroundColor: Colors.white,
                                                textStyle: const TextStyle(fontSize: 16),
                                                fixedSize: const Size(100, 40),
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
                                              ),
                                              onPressed: () {
                                                if (newPassword != confirmPassword) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Password tidak cocok')),
                                                  );
                                                  return;
                                                }
                                                
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Password berhasil diubah')),
                                                );
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
                        title: const Text(
                          'Apakah Anda yakin ingin keluar dari akun Anda?',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context, 
                                    MaterialPageRoute(builder: 
                                    (context) => FirstScreen(
                                      value: isLogin,
                                      onChanged: (newValue) {
                                        setState(() {
                                          isLogin = newValue;
                                        });
                                      },)
                                    ), 
                                    (route) => false
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
      ),
    );
  }
}