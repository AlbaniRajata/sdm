import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/admin/detailkegiatan_page.dart';
import 'package:sdm/admin/repositoryadmin_page.dart';
import 'package:sdm/admin/kegiatanadmin_page.dart';
import 'package:sdm/admin/listdosen_page.dart';
import 'package:sdm/admin/notifikasi_page.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';

class HomeadminPage extends StatelessWidget {
  const HomeadminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(98, 0, 151, 1),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/back.png',
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
                Positioned(
                  top: 28,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 175, 3, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotifikasiPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications, color: Colors.white),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Text(
                              'Notifikasi',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 65,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'HR',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.08,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                          height: 0.9,
                        ),
                      ),
                      Text(
                        'Sync',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.08,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sistem Manajemen SDM',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Hai, Albani Rajata',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/home.png',
                                  height: screenWidth * 0.6, // Adjust height based on screen width
                                ),
                                Positioned(
                                  top: screenWidth * 0.07,
                                  left: screenWidth * 0.25,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Kegiatan Selesai',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '21 Kegiatan',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const KegiatanadminPage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Lihat Daftar Kegiatan',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: screenWidth * 0.025,
                                                    color: const Color.fromRGBO(244, 71, 8, 1),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 10,
                                                  color: Color.fromRGBO(244, 71, 8, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: screenWidth * 0.04,
                                          width: screenWidth * 0.6,
                                          child: LinearProgressIndicator(
                                            value: 0.5, // Persentase penyelesaian (5 persen)
                                            backgroundColor: Colors.grey.shade300,
                                            valueColor:
                                              const AlwaysStoppedAnimation<Color>(Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '10 Kegiatan Selesai',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.03,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: screenWidth * 0.36,
                                  left: screenWidth * 0.25,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kegiatan yang Akan Datang',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Kuliah Tamu',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const DetailKegiatanPage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Lihat Detail Kegiatan',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: screenWidth * 0.025,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '24 September 2024',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.03,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dosen',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListDosenPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: screenWidth * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFFF44708), Color(0xFF6777EF)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              'assets/images/img-min.png',
                                              fit: BoxFit.cover,
                                              width: screenWidth * 0.3,
                                              height: screenWidth * 0.4,
                                              color: Colors.black.withOpacity(0.2),
                                              colorBlendMode: BlendMode.dstATop,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        'Albani Rajata',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.white, width: 1),
                                        ),
                                        child: Text(
                                          '2 Poin',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.03,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repository',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RepositoryadminPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final titles = [
                        'Surat Tugas',
                        'Proposal',
                        'Bukti Pencairan Dana',
                        'Dokumentasi',
                        'Laporan Pertanggung Jawaban'
                      ];
                      final documentCounts = [
                        '10 Dokumen',
                        '5 Dokumen',
                        '3 Dokumen',
                        '8 Dokumen',
                        '2 Dokumen'
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          height: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/img2.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: screenWidth * 0.2,
                                  colorBlendMode: BlendMode.dstATop,
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: Icon(
                                    Icons.folder,
                                    color: Colors.white,
                                    size: screenWidth * 0.1,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: screenWidth * 0.15,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        titles[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        documentCounts[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.03,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(
        currentPage: 'home',
      ),
    );
  }
}