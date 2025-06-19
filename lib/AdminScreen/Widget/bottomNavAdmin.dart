// ignore: file_names
import 'package:flutter/material.dart';
import 'package:project2/AdminScreen/homeAdmin.dart';
import 'package:project2/AdminScreen/profilAdmin.dart';
import 'package:project2/AdminScreen/tambahProduk.dart';

class BottonNavAdmin extends StatefulWidget {
  final int idPenjual;
  final int initialIndex;
  
  const BottonNavAdmin({super.key, this.initialIndex = 0, required this.idPenjual});

  @override
  State<BottonNavAdmin> createState() => _BottonNavAdminState();
}

class _BottonNavAdminState extends State<BottonNavAdmin> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  List<Widget> get _screens => [
    HomeAdminScreen(idPenjual: widget.idPenjual),
    TambahProdukScreen(idPenjual: widget.idPenjual),
    ProfilAdminScreen(idPenjual: widget.idPenjual),
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
                      onTap: () => _onTabTapped(1),
                      child: _currentIndex != 1 
                      ? const Icon(Icons.add)
                      : const SizedBox()
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTabTapped(0),
                      child: _currentIndex != 0 
                      ? const Icon(Icons.home)
                      : const SizedBox()
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onTabTapped(2),
                      child: _currentIndex != 2 
                      ? const Icon(Icons.person)
                      : const SizedBox()
                    ),
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
                alignment: _currentIndex == 0
                      ? Alignment.center
                      : _currentIndex == 1
                          ? Alignment.centerLeft
                          : _currentIndex == 2
                            ? Alignment.centerRight
                            : Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                    if (_currentIndex == 0) {
                      _onTabTapped(2);
                    } else if (_currentIndex == 2) {
                      _onTabTapped(1);
                    } else if (_currentIndex == 1) {
                      _onTabTapped(0);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: _currentIndex == 1 ? 50 : 50),
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
                      _currentIndex == 0 
                        ? Icons.home 
                        : _currentIndex == 1
                          ? Icons.add : Icons.person,
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
