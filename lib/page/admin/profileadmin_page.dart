import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/loginadmin_page.dart';
import 'package:sdm/page/admin/editprofile_page.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAdminPage extends StatelessWidget {
  const ProfileAdminPage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginAdminPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(screenWidth),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildProfileHeader(screenWidth),
            const SizedBox(height: 20),
            _buildEditButton(context, screenWidth),
            const SizedBox(height: 20),
            _buildDivider(),
            _buildLogoutTile(context, screenWidth),
          ],
        ),
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(currentPage: 'profile'),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Profil',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: screenWidth * 0.05,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 103, 119, 239),
      centerTitle: true,
      elevation: 2,
    );
  }

  Widget _buildProfileHeader(double screenWidth) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: const CircleAvatar(
            radius: 48,
            backgroundImage: AssetImage('assets/images/pp.png'),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Albani Rajata Malik',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'albanirajata@polinema.ac.id',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, double screenWidth) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfilePage()),
      ),
      icon: const Icon(Icons.edit, size: 20, color: Colors.white),
      label: Text(
        'Edit Profil',
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.04, color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey[300],
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context, double screenWidth) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
        child: Icon(
          Icons.logout,
          color: Colors.white,
          size: screenWidth * 0.05,
        ),
      ),
      title: Text(
        'Logout',
        style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: screenWidth * 0.04,
        color: Colors.black,
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton(
              onPressed: () => _handleLogout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}