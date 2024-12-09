import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/page/pic/detailagendakegiatan_page.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/pic/custom_bottomappbar.dart';
import 'package:intl/intl.dart';
import 'package:sdm/widget/pic/custom_filter.dart';
import 'package:sdm/widget/pic/kegiatan_sortoption.dart';

class DaftarKegiatanAgendaPage extends StatefulWidget {
  const DaftarKegiatanAgendaPage({super.key});

  @override
  DaftarKegiatanAgendaPageState createState() => DaftarKegiatanAgendaPageState();
}

class DaftarKegiatanAgendaPageState extends State<DaftarKegiatanAgendaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<KegiatanModel> kegiatanList = [];
  List<KegiatanModel> filteredKegiatanList = [];
  KegiatanSortOption selectedSortOption = KegiatanSortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    _fetchKegiatanList();
    _searchController.addListener(_searchKegiatan);
  }

  Future<void> _fetchKegiatanList() async {
    try {
      final apiKegiatan = ApiKegiatan();
      final kegiatan = await apiKegiatan.getKegiatanPICList();
      setState(() {
        kegiatanList = kegiatan;
        filteredKegiatanList = kegiatan;
      });
    } catch (e) {
      print('Error mengambil daftar kegiatan: $e');
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
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(a.tanggalAcara).compareTo(DateFormat('dd-MM-yyyy').parse(b.tanggalAcara)));
          break;
        case KegiatanSortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(b.tanggalAcara).compareTo(DateFormat('dd-MM-yyyy').parse(a.tanggalAcara)));
          break;
        default:
          break;
      }
    });
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
                        kegiatan: kegiatan,
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
                  kegiatan.namaKegiatan,
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
                          'Tempat Kegiatan',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          kegiatan.tempatKegiatan,
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
                          'Tanggal',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          kegiatan.tanggalAcara,
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
                          color: kegiatan.jenisKegiatan == 'Kegiatan JTI' ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          kegiatan.jenisKegiatan,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DetailKegiatanAgendaPage(idKegiatan: kegiatan.idKegiatan)),
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