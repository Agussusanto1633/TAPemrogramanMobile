import 'package:flutter/material.dart';
import 'package:servista/core/theme/color_value.dart';
import 'package:servista/features/booking/page/booking_page.dart';
import 'package:servista/features/home/page/home_page.dart';
import 'package:servista/features/profile/page/profile_page.dart';
import 'package:servista/features/service/pages/service_page.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ServicePage(),
    BookingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextStyle _labelStyle(int index) {
    return TextStyle(
      fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
      color:
          _selectedIndex == index
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
              color: Color(0xff000000).withOpacity(0.13),
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
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings, size: 28),
              label: 'Service',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today, size: 28),
              label: 'Pemesanan',
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
