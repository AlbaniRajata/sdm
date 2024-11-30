import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/dosen/homedosen_page.dart';
import 'package:sdm/page/dosen/logindosen_page.dart';
import 'package:sdm/page/anggota/editprofile_page.dart';
import 'package:sdm/page/pic/homepic_page.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';

class ProfileanggotaPage extends StatelessWidget {
  const ProfileanggotaPage({super.key});

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
            backgroundImage: AssetImage('assets/images/pp.png'),
          ),
          const SizedBox(height: 15),
          Text(
            'Albani Rajata Malik',
            style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
          ),
          Text(
            'albanirajata@polinema.ac.id',
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: screenWidth * 0.035),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
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
              'Edit Profil',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: const Color.fromRGBO(255, 175, 3, 1), size: screenWidth * 0.05),
              const SizedBox(width: 8),
              Text(
                '14 Poin',
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
            ],
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
                  builder: (context) => const HomepicPage(),
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
              'Masuk sebagai Anggota',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
            onTap: () {},
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
                  builder: (context) => const HomedosenPage(),
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
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogindosenPage(),
                ),
              );
            },
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