import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/admin/homeadmin_page.dart';
import 'package:sdm/admin/loginadmin_page.dart';

class ProfileadminPage extends StatelessWidget {
  const ProfileadminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profil',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'albanirajata@polinema.ac.id',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              'Edit Profil',
              style: GoogleFonts.poppins(color: Colors.white),
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
            leading: const CircleAvatar(
              backgroundColor: Color.fromRGBO(255, 175, 3, 1),
              child: Icon(Icons.timer, color: Colors.white),
            ),
            title: Text(
              'Lihat Progress Kegiatan',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
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
            leading: const CircleAvatar(
              backgroundColor: Color.fromRGBO(255, 175, 3, 1),
              child: Icon(Icons.logout, color: Colors.white),
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginadminPage(),
                  ),
                );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 70,
          height: 70,
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
          child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color.fromARGB(255, 103, 119, 239),
        child: Row(
          children: <Widget>[
            const Spacer(flex: 2),
            IconButton(
              icon: const Icon(Icons.home_rounded, size: 40),
              color: Colors.grey.shade400,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeadminPage(),
                  ),
                );
              },
            ),
            const Spacer(flex: 5),
            IconButton(
              icon: const Icon(Icons.person, size: 40),
              color: Colors.white,
              onPressed: () {},
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}