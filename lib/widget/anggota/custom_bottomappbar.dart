import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sdm/models/dosen/user_model.dart';
import 'package:sdm/page/anggota/homeanggota_page.dart';
import 'package:sdm/page/anggota/profileanggota_page.dart';
import 'package:sdm/page/anggota/daftarkegiatan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomAppBar extends StatelessWidget {
  final String currentPage;

  const CustomBottomAppBar({Key? key, this.currentPage = ''}) : super(key: key);

  Future<UserModel?> _getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userMap = json.decode(userData);
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color.fromARGB(255, 103, 119, 239),
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
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: isSelected ? Colors.white : Colors.grey.shade400,
      ),
      onPressed: onPressed,
    );
  }

  Future<void> _navigateToPage(BuildContext context, String page) async {
    if (currentPage == page) return;

    try {
      final user = await _getUserData();
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Could not load user data'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (!context.mounted) return;

      switch (page) {
        case 'home':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeanggotaPage(user: user),
            ),
          );
          break;
        case 'profile':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileanggotaPage(user: user),
            ),
          );
          break;
      }
    } catch (e) {
      debugPrint('Error navigating to $page: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error navigating to $page'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          final user = await _getUserData();
          if (user != null && context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaftarKegiatanPage(),
              ),
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Could not load user data'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          debugPrint('Error navigating to DaftarKegiatanPage: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error accessing kegiatan page'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
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
        child: const Icon(
          Icons.calendar_today_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}