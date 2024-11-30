import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:intl/intl.dart';
import 'package:sdm/page/pimpinan/detailkegiatan_page.dart';
import 'package:sdm/widget/pimpinan/custom_filter.dart';
import 'package:sdm/widget/pimpinan/kegiatan_sortoption.dart';
import 'dart:math';

class DaftarKegiatanPage extends StatefulWidget {
  const DaftarKegiatanPage({super.key});

  @override
  DaftarKegiatanPageState createState() => DaftarKegiatanPageState();
}

class DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Seminar Nasional', 'ketua': 'Albani Rajata Malik', 'tanggal_mulai': '01-03-2022', 'tanggal_selesai': '03-03-2022'},
    {'title': 'Kuliah Tamu', 'ketua': 'Albani Rajata Malik', 'tanggal_mulai': '01-03-2022', 'tanggal_selesai': '03-03-2022'},
    {'title': 'Workshop Teknologi', 'ketua': 'Siti Fadhilah', 'tanggal_mulai': '10-04-2022', 'tanggal_selesai': '12-04-2022'},
    {'title': 'Lokakarya Nasional', 'ketua': 'Rizki Pratama', 'tanggal_mulai': '18-05-2022', 'tanggal_selesai': '20-05-2022'},
  ];

  List<Map<String, String>> filteredKegiatanList = [];
  KegiatanSortOption selectedSortOption = KegiatanSortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    _assignRandomJenis();
    filteredKegiatanList = kegiatanList;
    _searchController.addListener(_searchKegiatan);
  }

  void _assignRandomJenis() {
    final random = Random();
    for (var kegiatan in kegiatanList) {
      kegiatan['jenis'] = random.nextBool() ? 'JTI' : 'Non JTI';
    }
  }

  void _searchKegiatan() {
    setState(() {
      filteredKegiatanList = kegiatanList.where((kegiatan) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = kegiatan['title']!.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortKegiatanList(KegiatanSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case KegiatanSortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case KegiatanSortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case KegiatanSortOption.tanggalTerdekat:
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(a['tanggal_mulai']!).compareTo(DateFormat('dd-MM-yyyy').parse(b['tanggal_mulai']!)));
          break;
        case KegiatanSortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(b['tanggal_mulai']!).compareTo(DateFormat('dd-MM-yyyy').parse(a['tanggal_mulai']!)));
          break;
        case KegiatanSortOption.jti:
          filteredKegiatanList = kegiatanList.where((kegiatan) => kegiatan['jenis'] == 'JTI').toList();
          break;
        case KegiatanSortOption.nonJTI:
          filteredKegiatanList = kegiatanList.where((kegiatan) => kegiatan['jenis'] == 'Non JTI').toList();
          break;
        default:
          break;
      }
    });
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(parsedDate);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteKegiatan(String title) {
    setState(() {
      kegiatanList.removeWhere((kegiatan) => kegiatan['title'] == title);
      _searchKegiatan();
    });
  }

  void _showDeleteConfirmationDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda ingin menghapus kegiatan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                _deleteKegiatan(title);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Daftar Kegiatan',
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
          const SizedBox(height: 20),
          CustomFilter<KegiatanSortOption>(
            controller: _searchController,
            onChanged: (value) => _searchKegiatan(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (KegiatanSortOption? value) {
              _sortKegiatanList(value);
            },
            sortOptions: KegiatanSortOption.values.toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredKegiatanList.map((kegiatan) {
                  return Column(
                    children: [
                      _buildKegiatanCard(
                        context,
                        title: kegiatan['title']!,
                        ketua: kegiatan['ketua']!,
                        tanggalMulai: _formatDate(kegiatan['tanggal_mulai']!),
                        tanggalSelesai: _formatDate(kegiatan['tanggal_selesai']!),
                        jenis: kegiatan['jenis']!,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String title,
    required String ketua,
    required String tanggalMulai,
    required String tanggalSelesai,
    required String jenis,
    required double screenWidth,
  }) {
    final fontSize = screenWidth < 500 ? 14.0 : 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
          // Header Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 167, 170),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
          // Isi Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ketua Pelaksana',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ketua,
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal Mulai',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggalMulai,
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tanggal Selesai',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggalSelesai,
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(), // Garis pembatas
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: jenis == 'JTI' ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          jenis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DetailKegiatanPage(kegiatan: {
                              'title': title,
                              'ketua': ketua,
                              'tanggal_mulai': tanggalMulai,
                              'tanggal_selesai': tanggalSelesai,
                              'jenis': jenis,
                            })),
                          );
                        },
                        child: Text(
                          'Lihat Detail',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF00796B),
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}