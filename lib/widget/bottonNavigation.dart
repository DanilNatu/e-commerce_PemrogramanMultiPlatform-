import 'package:flutter/material.dart';
import 'package:project2/keranjang.dart';
import 'package:project2/screen/home.dart';
import 'package:project2/screen/profil.dart';

class BottonNavigation extends StatefulWidget {
  const BottonNavigation({super.key});

  @override
  State<BottonNavigation> createState() => _BottonNavigationState();
}

class _BottonNavigationState extends State<BottonNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfilScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const KeranjangScreen()),
                        );
                      },
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),
                  
                  Expanded(
                    child: _currentIndex == 1
                        ? GestureDetector(
                            onTap: () => _onTabTapped(0),
                            child: const Icon(Icons.home),
                          )
                        : const SizedBox(),
                  ),

                  Expanded(
                    child: _currentIndex == 0
                        ? GestureDetector(
                            onTap: () => _onTabTapped(1),
                            child: const Icon(Icons.person),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),

            // Floating Icon Dinamis
            Positioned(
              top: -25,
              left: 0,
              right: 0,
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment:
                    _currentIndex == 1 ? Alignment.centerRight : Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex == 0) {
                      _onTabTapped(1);
                    } else {
                      _onTabTapped(0);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.only(right: _currentIndex == 1 ? 50 : 0),
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF7A8AD7),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8),
                      ],
                    ),
                    child: Icon(
                      _currentIndex == 0 ? Icons.home : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
