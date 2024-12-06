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
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            const Spacer(flex: 2),
            _buildNavButton(
              context: context,
              icon: Icons.home_rounded,
              isSelected: currentPage == 'home',
              onPressed: () => _navigateToPage(context, 'home'),
            ),
            const Spacer(flex: 5),
            _buildNavButton(
              context: context,
              icon: Icons.person,
              isSelected: currentPage == 'profile',
              onPressed: () => _navigateToPage(context, 'profile'),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 30),
      color: isSelected ? Colors.white : Colors.grey.shade400,
      onPressed: onPressed,
    );
  }

  void _navigateToPage(BuildContext context, String page) {
    if (currentPage != page) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page == 'home' 
            ? const HomeAdminPage()
            : const ProfileAdminPage(),
        ),
      );
    }
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
      child: Container(
        width: 60,
        height: 60,
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
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}