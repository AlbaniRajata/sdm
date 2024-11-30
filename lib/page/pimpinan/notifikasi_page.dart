import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  NotifikasiPageState createState() => NotifikasiPageState();
}

class NotifikasiPageState extends State<NotifikasiPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifikasi',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(screenWidth),
            const SizedBox(height: 10),
            _buildNotificationTile(screenWidth),
            const SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey[300],
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            _buildNotificationTile(screenWidth),
          ],
        ),
      ),
      floatingActionButton: CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari notifikasi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Tambahkan aksi untuk filter
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(double screenWidth) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
        child: Icon(Icons.notifications, color: Colors.white, size: screenWidth * 0.05),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Anda telah ditugaskan sebagai\n',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.grey),
            ),
            TextSpan(
              text: 'Ketua Pelaksana\n',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: 'Seminar Nasional\n24 September 2024',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.black),
            ),
          ],
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: const Color.fromRGBO(255, 175, 3, 1)),
      onTap: () {
        
      },
    );
  }
}