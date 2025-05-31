import 'package:flutter/material.dart';
import 'package:project2/home_screen.dart';

class FirstScreen extends StatefulWidget {
  final Function(bool)? onChanged;
  final bool value;

 FirstScreen({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

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
          style: TextStyle(
            fontSize: 17
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),
          decoration: InputDecoration(
            hintText: hintText, 
            hintStyle: TextStyle(
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
          style: TextStyle(
            fontSize: 17
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText : obscureText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
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
              SizedBox(height: 75),
          
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
                        duration: Duration(milliseconds: 200),
                        alignment: widget.value ? Alignment.centerLeft : Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(4),
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
                                  offset: Offset(0, 2),
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
                padding: EdgeInsets.all(31),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.value
                  ? Column(
                      children: [
                        _inputEmail(text: 'Email', hintText: 'Your Email', controller: loginEmailController),
          
                        SizedBox(height: 20),
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
          
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text('Forget password?'),
                            )
                          ],
                        ),
          
                        SizedBox(height: 200),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 123, 138, 215),
                              minimumSize: Size(330, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17), 
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => HomeScreen())
                                ),
                                (route) => false
                              );
                            },
                            child: Text(
                              'Log IN',
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
                        _inputEmail(text: 'Name', hintText: 'Input your name', controller: registerNameController),


                        SizedBox(height: 20),
                        _inputEmail(text: 'Email', hintText: 'example@gmail.com', controller: registerEmailController),
            
                        SizedBox(height: 20),
                        _inputPassword(
                          text: 'Create a password', 
                          hintText: 'must be 8 characters', 
                          controller: registerPassController,
                          obscureText: _obscurePass, 
                          toggleVisibility: () {
                            setState(() {
                              _obscurePass = !_obscurePass;
                            });
                          }
                        ),
            
                        SizedBox(height: 20),
                        _inputPassword(
                          text: 'Confirm password', 
                          hintText: 'repeat password', 
                          controller: regisPassConfController,
                          obscureText: _obscureConfPass, 
                          toggleVisibility: () {
                            setState(() {
                              _obscureConfPass = !_obscureConfPass;
                            });
                          }
                        ),

                        SizedBox(height: 35),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 123, 138, 215),
                              minimumSize: Size(330, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17), 
                              ),
                            ),
                            onPressed: () {
                              widget.onChanged?.call(true);
                            }, 
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            )
                          ),
                        ),

                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an acount? '),

                            GestureDetector(
                              onTap: () {
                                widget.onChanged?.call(true);
                              },
                              child: Text(
                                'Log in',
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