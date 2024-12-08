import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sdm/models/pimpinan/kegiatan_model.dart';
import 'package:sdm/page/pimpinan/detailkegiatan_page.dart';
import 'package:sdm/services/pimpinan/api_kegiatan.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/custom_filter.dart';
import 'package:sdm/widget/pimpinan/kegiatan_sortoption.dart';

class DaftarKegiatanPage extends StatefulWidget {
  const DaftarKegiatanPage({super.key});

  @override
  DaftarKegiatanPageState createState() => DaftarKegiatanPageState();
}

class DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  List<KegiatanModel> kegiatanList = [];
  List<KegiatanModel> filteredKegiatanList = [];
  KegiatanSortOption selectedSortOption = KegiatanSortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    _getKegiatanList();
    _searchController.addListener(_searchKegiatan);
  }

  void _getKegiatanList() async {
    try {
      final kegiatan = await _apiKegiatan.getKegiatanList();
      setState(() {
        kegiatanList = kegiatan;
        filteredKegiatanList = kegiatan;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _searchKegiatan() {
    setState(() {
      filteredKegiatanList = kegiatanList.where((kegiatan) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = kegiatan.namaKegiatan.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortKegiatanList(KegiatanSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case KegiatanSortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a.namaKegiatan.compareTo(b.namaKegiatan));
          break;
        case KegiatanSortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b.namaKegiatan.compareTo(a.namaKegiatan));
          break;
        case KegiatanSortOption.tanggalTerdekat:
          filteredKegiatanList.sort((a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));
          break;
        case KegiatanSortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => b.tanggalMulai.compareTo(a.tanggalMulai));
          break;
        case KegiatanSortOption.jti:
          filteredKegiatanList = kegiatanList.where((kegiatan) => kegiatan.jenisKegiatan == 'Kegiatan JTI').toList();
          break;
        case KegiatanSortOption.nonJTI:
          filteredKegiatanList = kegiatanList.where((kegiatan) => kegiatan.jenisKegiatan == 'Kegiatan Non-JTI').toList();
          break;
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            onSortOptionChanged: _sortKegiatanList,
            sortOptions: KegiatanSortOption.values.toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredKegiatanList.map((kegiatan) {
                  return Column(
                    children: [
                      _buildKegiatanCard(context, kegiatan: kegiatan, screenWidth: screenWidth),
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
    required KegiatanModel kegiatan,
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
                Expanded(
                  child: Text(
                    kegiatan.namaKegiatan,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      _formatDate(kegiatan.tanggalMulai),
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
                      _formatDate(kegiatan.tanggalSelesai),
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kegiatan.jenisKegiatan == 'Kegiatan JTI' 
                          ? Colors.blue 
                          : Colors.orange,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        kegiatan.jenisKegiatan,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailKegiatanPage(kegiatan: kegiatan),
                          ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}