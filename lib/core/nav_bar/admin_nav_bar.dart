import 'package:flutter/material.dart';
import 'package:servista/admin/features/home/page/admin_home_page.dart';
import 'package:servista/admin/features/manage/page/admin_manage_page.dart';
import 'package:servista/core/theme/color_value.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminHomePage(),
    AdminManagePage(),
    AdminManagePage(), // <- Tambahkan di sini
    AdminHomePage(), // Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextStyle _labelStyle(int index) {
    return TextStyle(
      fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
      color: _selectedIndex == index
          ? ColorValue.darkColor
          : ColorValue.darkColor.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.13),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: ColorValue.darkColor,
          unselectedItemColor: ColorValue.darkColor.withOpacity(0.5),
          showUnselectedLabels: true,
          selectedLabelStyle: _labelStyle(_selectedIndex),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_outlined),
              activeIcon: Icon(Icons.manage_accounts, size: 28),
              label: 'Kelola',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long, size: 28),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, size: 28),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
