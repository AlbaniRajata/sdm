import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/user_model.dart';
import 'package:sdm/page/dosen/homedosen_page.dart';
import 'package:sdm/welcome_page.dart';
import 'package:sdm/page/anggota/detailprofile_page.dart';
import 'package:sdm/page/pic/homepic_page.dart';
import 'package:sdm/widget/anggota/custom_bottomappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileanggotaPage extends StatelessWidget {
  final UserModel user;
  const ProfileanggotaPage({super.key, required this.user});

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
        );
      } catch (e) {
        debugPrint('Error during logout: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal melakukan logout. Silahkan coba lagi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 15),
          Text(
            user.nama,
            style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email,
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: screenWidth * 0.035),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailProfilePage(user: user),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              'Detail Profil',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            thickness: 0.5,
            color: Colors.grey[300],
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.05),
            ),
            title: Text(
              'Masuk sebagai PIC',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePICPage(user: user),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.05),
            ),
            title: Text(
              'Kembali sebagai Dosen',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeDosenPage(user: user),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Divider(
            thickness: 0.5,
            color: Colors.grey[300],
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              child: Icon(Icons.logout, color: Colors.white, size: screenWidth * 0.05),
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(
        currentPage: 'profile',
      ),
    );
  }
}