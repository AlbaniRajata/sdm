import 'package:flutter/material.dart';
import 'package:sdm/page/admin/homeadmin_page.dart';
import 'package:sdm/page/admin/profileadmin_page.dart';
import 'package:sdm/page/admin/tambahkegiatan_page.dart';

class CustomBottomAppBar extends StatelessWidget {
  final String currentPage;

  const CustomBottomAppBar({Key? key, this.currentPage = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color.fromARGB(255, 103, 119, 239),
      child: Row(
        children: <Widget>[
          const Spacer(flex: 2),
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 40),
            color: currentPage == 'home' ? Colors.white : Colors.grey.shade400,
            onPressed: () {
              if (currentPage != 'home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeadminPage(),
                  ),
                );
              }
            },
          ),
          const Spacer(flex: 5),
          IconButton(
            icon: const Icon(Icons.person, size: 40),
            color: currentPage == 'profile' ? Colors.white : Colors.grey.shade400,
            onPressed: () {
              if (currentPage != 'profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileadminPage(),
                  ),
                );
              }
            },
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TambahKegiatanPage(),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF00CBF1), Color(0xFF6777EF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}