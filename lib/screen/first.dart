import 'package:flutter/material.dart';
import 'package:project2/Widget/BottonNavigation.dart';

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

  bool _obscurePass = true;
  bool _obscureConfPass = true;
  bool? _previousValue;

  Widget _inputEmail ({
    required String text,
    required String hintText,
    required TextEditingController controller,
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

  @override
  Widget build(BuildContext context) {
    if (widget.value != _previousValue) {
      loginEmailController.clear();
      loginPassController.clear();
      registerNameController.clear();
      registerEmailController.clear();
      registerPassController.clear();
      regisPassConfController.clear();

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
                  ? Column(
                      children: [
                        _inputEmail(text: 'Email', hintText: 'Input Email', controller: loginEmailController),
          
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
                              onTap: () {},
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const BottonNavigation()),
                                ),
                                (route) => false
                              );
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
                    )
                  : Column(
                      children: [
                        _inputEmail(text: 'Nama', hintText: 'Input Nama', controller: registerNameController),


                        const SizedBox(height: 20),
                        _inputEmail(text: 'Email', hintText: 'example@gmail.com', controller: registerEmailController),
            
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
                              widget.onChanged?.call(true);
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