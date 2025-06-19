import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project2/AdminScreen/Widget/bottomNavAdmin.dart';
import 'package:project2/UserScreen/Widget/bottomNavUser.dart';
import 'package:project2/graphql/mutation/AdminScreen/registerPenjual.dart';
import 'package:project2/graphql/mutation/UserScreen/registerUser.dart';
import 'package:project2/graphql/mutation/forgetPassword.dart';
import 'package:project2/graphql/mutation/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  final Function(bool)? onChanged;
  final bool value;

const FirstScreen({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPassController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController(); 
  final TextEditingController registerPassController = TextEditingController();
  final TextEditingController regisPassConfController = TextEditingController();
  final TextEditingController registeleponController = TextEditingController();

  final TextEditingController emailForPasController = TextEditingController();
  final TextEditingController passBaruController = TextEditingController();
  final TextEditingController confirmPassBaruController = TextEditingController();

  List<String> role =['User', 'Penjual'];
  String selectedRole = 'User';

  bool _obscurePass = true;
  bool _obscureConfPass = true;
  bool? _previousValue;

  Widget _inputEmail ({
    required String? text,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text?.isNotEmpty == true ? text! : '',
          style: const TextStyle(
            fontSize: 17
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16
          ),
          decoration: InputDecoration(
            hintText: hintText, 
            hintStyle: const TextStyle(
              color: Colors.grey
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
        )
      ],
    );
  }

  Widget _inputPassword ({
    required String text,
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 17
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText : obscureText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleVisibility,
            ),
          ),
        )
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    if (widget.value != _previousValue) {
      loginEmailController.clear();
      loginPassController.clear();
      registerNameController.clear();
      registerEmailController.clear();
      registerPassController.clear();
      regisPassConfController.clear();
      registeleponController.clear();

      _previousValue = widget.value;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 75),
          
              Center(
                child: Image.asset(
                  'assets/images/BAKULOS.png',
                  height: 150,
                ),
              ),
          
              Center(
                child: Container(
                  width: 350,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Bagian yang bergerak
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: widget.value ? Alignment.centerLeft : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 170,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Teks Login & Sign In
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.onChanged?.call(true);
                              },
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.value ? Colors.black : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                widget.onChanged?.call(false);
                              },
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !widget.value ? Colors.black : Colors.grey[600],
                                  ),
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
          
              Padding(
                padding: const EdgeInsets.all(31),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.value
                  ? Mutation(
                      options: MutationOptions(
                        document: gql(LoginMutation.login),
                        onCompleted: (data) async {
                          print('DATA LOGIN: $data');
                            final loginData = data?['login'];

                            if (loginData == null) {
                              _flashyFlushbar(message: "Email atau password salah");
                              return;
                            }

                              final token = loginData['token'];
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('token', token); // ✅ Simpan token


                            if (token != null) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('token', token);
                            } else {
                              _flashyFlushbar(message: "Login gagal: token tidak tersedia.");
                              return;
                            }

                            final role = loginData['role'];

                            if (role == 'user') {
                              final idUser = loginData['id_user'];
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => BottonNavigation(idUser: idUser))
                              );
                            } else if (role == 'penjual') {
                              final idPenjual = loginData['id_penjual'];
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => BottonNavAdmin(idPenjual: idPenjual))
                              );
                            }
                          },
                        ),
                        builder: (RunMutation runMutation, QueryResult? result) {
                          return Column(
                            children: [
                              _inputEmail(
                                text: 'Email', 
                                hintText: 'Input Email', 
                                controller: loginEmailController
                              ),
                                  
                              const SizedBox(height: 20),
                              _inputPassword(
                                text: 'Password', 
                                hintText: 'Password',
                                controller: loginPassController,
                                obscureText: _obscurePass, 
                                toggleVisibility: () {
                                  setState(() {
                                    _obscurePass = !_obscurePass;
                                  });
                                }
                              ),
                                  
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Mutation(
                                            options: MutationOptions(
                                              document: gql(ForgetPasswordMutation.forgetPassword),
                                              onCompleted: (data) {
                                                final forgetPasswordData = data?['forgetPassword'];

                                                if (forgetPasswordData == null) {
                                                  _flashyFlushbar(message: "Email tidak ditemukan.");
                                                  return;
                                                }

                                                final message = forgetPasswordData['message'];

                                                _flashyFlushbar(message: message ?? 'Password berhasil diubah');

                                                Navigator.pop(context);
                                              }
  
                                            ),
                                            builder: (RunMutation runMutation, QueryResult? result) {

                                              return Padding(
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 15, right: 15),
                                                child: FractionallySizedBox(
                                                  heightFactor: 0.520,
                                                  child: Column(
                                                    children: [
                                                    const Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 8),
                                                        child: Text(
                                                          'Forget Password',
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
                                                              const SizedBox(height: 10),
                                                              _inputEmail(
                                                                text: 'Email', 
                                                                hintText: 'Masukkan Email', 
                                                                controller: emailForPasController
                                                              ),
                                                                                                      
                                                              const SizedBox(height: 20),
                                                              _inputPassword(
                                                                text: 'Password Baru', 
                                                                hintText: 'Minimal 8 Karakter', 
                                                                controller: passBaruController,
                                                                obscureText: _obscurePass, 
                                                                toggleVisibility: () {
                                                                  setState(() {
                                                                    _obscurePass = !_obscurePass;
                                                                  });
                                                                }
                                                              ),
                                                                    
                                                              const SizedBox(height: 20),
                                                              _inputPassword(
                                                                text: 'Konfimasi Password', 
                                                                hintText: 'Input Ulang Password', 
                                                                controller: confirmPassBaruController,
                                                                obscureText: _obscureConfPass, 
                                                                toggleVisibility: () {
                                                                  setState(() {
                                                                    _obscureConfPass = !_obscureConfPass;
                                                                  });
                                                                }
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
                                                                  final email = emailForPasController.text.trim();
                                                                  final passwordBaru = passBaruController.text.trim();
                                                                  final konfirmasi = confirmPassBaruController.text.trim();
                                                        
                                                                  if (email.isEmpty || passwordBaru.isEmpty || konfirmasi.isEmpty) {
                                                                    _flashyFlushbar(message: "Semua field wajib diisi");
                                                                    return;
                                                                  }
                                                        
                                                                  if (passwordBaru != konfirmasi) {
                                                                    _flashyFlushbar(message: "Password tidak sama");
                                                                    return;
                                                                  }
                                                        
                                                                  if (passwordBaru.length < 8) {
                                                                    _flashyFlushbar(message: "Password minimal 8 karakter");
                                                                    return;
                                                                  }
                                                        
                                                                  runMutation({
                                                                    "email": email,
                                                                    "new_password": passwordBaru,
                                                                  });
                                                                },
                                                                child: const Text( 
                                                                  'Ubah Password',
                                                                  style: TextStyle(
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
                                            }
                                          );
                                        },
                                      ).whenComplete(() {
                                          emailForPasController.clear();
                                          passBaruController.clear();
                                          confirmPassBaruController.clear();
                                        });
                                    },
                                    child: const Text('Forget password?'),
                                  )
                                ],
                              ),
                                  
                              const SizedBox(height: 200),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 123, 138, 215),
                                    minimumSize: const Size(330, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17), 
                                    ),
                                  ),
                                  onPressed: () {
                                    String inputEmail = loginEmailController.text.trim();
                                    String inputPassword = loginPassController.text;

                                    if (inputEmail.isEmpty || inputPassword.isEmpty) {
                                      _flashyFlushbar(message: "Email dan password wajib diisi!");
                                      return;
                                    }

                                    runMutation({
                                      "email": inputEmail,
                                      "password": inputPassword,
                                    });  
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  )
                                ),
                              ),
                            ],
                          );
                      }
                  )
                  : Mutation(
                      options: MutationOptions(
                        document: gql(RegisterMutationUser.register),
                        fetchPolicy: FetchPolicy.noCache,
                        onCompleted: (data) {
                          if (data == null || data['createUser'] == null) {
                            // Jangan lakukan apa-apa kalau data null
                            return;
                          }
                          _flashyFlushbar(message: "Register Berhasil User.");
                          widget.onChanged?.call(true);
                        },
                        onError: (err) {
                          final errorMessage = err!.graphqlErrors.isNotEmpty
                              ? err.graphqlErrors.first.message
                              : "Terjadi kesalahan";

                          if (errorMessage.contains("email sudah terdaftar")) {
                            _flashyFlushbar(message: "Email sudah terdaftar.");
                            return;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                padding: const EdgeInsets.all(8),
                                content: Text(
                                  "Gagal register: $errorMessage",
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                                backgroundColor: const Color.fromARGB(202, 0, 0, 0),
                              ),
                            );
                          }
                        }
                      ),
                      builder: (RunMutation runMutationUser, QueryResult? resultUser) {
                        return Mutation(
                          options: MutationOptions(
                            document: gql(RegisterMutationPenjual.register),
                            fetchPolicy: FetchPolicy.noCache,
                            onCompleted: (data) {
                              if (data == null || data['createPenjual'] == null) {
                                // Jangan lakukan apa-apa kalau data null
                                return;
                              }
                              _flashyFlushbar(message: "Register Berhasil Sebagai Penjual.");
                              widget.onChanged?.call(true);
                            },
                            onError: (err) {
                              final errorMessage = err!.graphqlErrors.isNotEmpty
                                  ? err.graphqlErrors.first.message
                                  : "Terjadi kesalahan";

                              if (errorMessage.contains("email sudah terdaftar")) {
                                _flashyFlushbar(message: "Email sudah terdaftar.");
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    padding: const EdgeInsets.all(8),
                                    content: Text(
                                      "Gagal register: $errorMessage",
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                    backgroundColor: const Color.fromARGB(202, 0, 0, 0),
                                  ),
                                );
                              }
                            }
                          ),
                          builder: (RunMutation runMutationPenjual, QueryResult? resultPenjual) {

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: DropdownMenu<String>(
                                    label: const Text('Register Sebagai?'),
                                    width: 130,
                                    initialSelection: selectedRole,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedRole = value!;
                                      });
                                    },
                                    dropdownMenuEntries: role
                                        .map((cat) => DropdownMenuEntry<String>(value: cat, label: cat,))
                                        .toList(),
                                    menuStyle: MenuStyle(
                                      backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
                                      padding: const WidgetStatePropertyAll(EdgeInsets.all(10)),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                    inputDecorationTheme: InputDecorationTheme(
                                      labelStyle: const TextStyle(fontSize: 16),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                          
                                _inputEmail(
                                  text: 'Nama', 
                                  hintText: 'Input Nama', 
                                  controller: registerNameController
                                ),
                          
                                const SizedBox(height: 20),
                                _inputEmail(
                                  text: 'Email', 
                                  hintText: 'example@gmail.com', 
                                  controller: registerEmailController
                                ),
                          
                                const SizedBox(height: 20),
                                _inputEmail(
                                  text: 'Nomor Telepon', 
                                  hintText: '08xxxx', 
                                  controller: registeleponController,
                                ),
                                      
                                const SizedBox(height: 20),
                                _inputPassword(
                                  text: 'Buat Password', 
                                  hintText: 'Minimal 8 Karakter', 
                                  controller: registerPassController,
                                  obscureText: _obscurePass, 
                                  toggleVisibility: () {
                                    setState(() {
                                      _obscurePass = !_obscurePass;
                                    });
                                  }
                                ),
                                      
                                const SizedBox(height: 20),
                                _inputPassword(
                                  text: 'Konfimasi Password', 
                                  hintText: 'Input Ulang Password', 
                                  controller: regisPassConfController,
                                  obscureText: _obscureConfPass, 
                                  toggleVisibility: () {
                                    setState(() {
                                      _obscureConfPass = !_obscureConfPass;
                                    });
                                  }
                                ),
                          
                                const SizedBox(height: 35),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 123, 138, 215),
                                      minimumSize: const Size(330, 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17), 
                                      ),
                                    ),
                                    onPressed: () {
                                      if (registerNameController.text.isEmpty || 
                                          registerEmailController.text.isEmpty || 
                                          registeleponController.text.isEmpty || 
                                          registerPassController.text.isEmpty) {
                                        _flashyFlushbar(message: "Semua field wajib diisi!");
                                        return;
                                      }

                                      final email = registerEmailController.text.trim();
                                      final validDomains = ['@gmail.com', '@yahoo.com', '@outlook.com'];
                                      final isValidDomain = validDomains.any((domain) => email.endsWith(domain));
                                      if (!isValidDomain) {
                                        _flashyFlushbar(message: "Domain email tidak terdaftar");
                                        return;
                                      }

                                      final telepon = registeleponController.text.trim();
                                      final teleponRegExp = RegExp(r'^[0-9]+$');
                                      if (!teleponRegExp.hasMatch(telepon)) {
                                        _flashyFlushbar(message: "Nomor telepon hanya boleh angka");
                                        return;
                                      }

                                      if (registerPassController.text.length < 8 ) {
                                        _flashyFlushbar(message: "Password minimal 8 karakter!");
                                        return;
                                      }
                                      if (registerPassController.text !=regisPassConfController.text) {
                                        _flashyFlushbar(message: "Password tidak sama!");
                                        return;
                                      }

                                      resultUser?.exception = null;
                                      resultPenjual?.exception = null;

                                      if (selectedRole == 'User') {
                                        runMutationUser({
                                          "nama": registerNameController.text,
                                          "email": registerEmailController.text,
                                          "password": registerPassController.text,
                                          "telepon": registeleponController.text
                                        });
                                      } else if (selectedRole == 'Penjual') {
                                        runMutationPenjual({
                                          "nama": registerNameController.text,
                                          "email": registerEmailController.text,
                                          "password": registerPassController.text,
                                          "telepon": registeleponController.text
                                        });
                                      }
                          
                                      setState(() {
                                        selectedRole = 'User';
                                      });
                          
                                    }, 
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    )
                                  ),
                                ),
  
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Already have an acount? '),
                          
                                    GestureDetector(
                                      onTap: () {
                                        widget.onChanged?.call(true);
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                        );
                      }
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}