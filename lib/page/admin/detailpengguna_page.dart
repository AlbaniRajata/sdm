import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/page/admin/daftarpengguna_page.dart';

class DetailPenggunaPage extends StatefulWidget {
  final Map<String, String> pengguna;

  const DetailPenggunaPage({super.key, required this.pengguna});

  @override
  DetailPenggunaPageState createState() => DetailPenggunaPageState();
}

class DetailPenggunaPageState extends State<DetailPenggunaPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pengguna = widget.pengguna;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Detail Pengguna',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Header
              Container(
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 5, 167, 170),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Detail Pengguna',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth < 500 ? 14.0 : 16.0,
                  ),
                ),
              ),
              // Card Body
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildRichText('ID', pengguna['id']!, screenWidth),
                    const Divider(),
                    _buildRichText('Username', pengguna['username']!, screenWidth),
                    const Divider(),
                    _buildRichText('Nama Lengkap', pengguna['title']!, screenWidth),
                    const Divider(),
                    _buildRichText('Tanggal Lahir', pengguna['tanggal_lahir']!, screenWidth),
                    const Divider(),
                    _buildRichText('Email', pengguna['email']!, screenWidth),
                    const Divider(),
                    _buildRichText('NIP', pengguna['nip']!, screenWidth),
                    const Divider(),
                    _buildRichText('Level', pengguna['level']!, screenWidth),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DaftarPenggunaPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildRichText(String title, String value, double screenWidth) {
    final fontSize = screenWidth < 500 ? 14.0 : 16.0;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$title: ',
            style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ),
      ],
    );
  }
}