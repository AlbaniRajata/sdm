import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/anggota/custom_bottomappbar.dart';
import 'package:sdm/widget/anggota/sort_option.dart';
import 'package:sdm/widget/anggota/custom_filter.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  StatistikPageState createState() => StatistikPageState();
}

class StatistikPageState extends State<StatistikPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Seminar Nasional', 'jabatan': 'Ketua', 'poin': '10', 'tanggalMulai': '2022-03-01', 'tanggalSelesai': '2022-03-03'},
    {'title': 'Kuliah Tamu', 'jabatan': 'Ketua', 'poin': '8', 'tanggalMulai': '2022-03-01', 'tanggalSelesai': '2022-03-03'},
    {'title': 'Workshop Teknologi', 'jabatan': 'Anggota', 'poin': '5', 'tanggalMulai': '2022-04-10', 'tanggalSelesai': '2022-04-12'},
    {'title': 'Lokakarya Nasional', 'jabatan': 'Anggota', 'poin': '3', 'tanggalMulai': '2022-05-18', 'tanggalSelesai': '2022-05-20'},
  ];
  List<Map<String, String>> filteredKegiatanList = [];
  SortOption selectedSortOption = SortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    filteredKegiatanList = kegiatanList;
    _searchController.addListener(_searchKegiatan);
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

  void _sortKegiatanList(SortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case SortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case SortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case SortOption.tanggalTerdekat:
          filteredKegiatanList.sort((a, b) => DateTime.parse(a['tanggalMulai']!).compareTo(DateTime.parse(b['tanggalMulai']!)));
          break;
        case SortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => DateTime.parse(b['tanggalMulai']!).compareTo(DateTime.parse(a['tanggalMulai']!)));
          break;
        case SortOption.poinTerbanyak:
          filteredKegiatanList.sort((a, b) => int.parse(b['poin']!).compareTo(int.parse(a['poin']!)));
          break;
        case SortOption.poinTersedikit:
          filteredKegiatanList.sort((a, b) => int.parse(a['poin']!).compareTo(int.parse(b['poin']!)));
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Statistik',
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
          const SizedBox(height: 20),
          CustomFilter(
            controller: _searchController,
            onChanged: (value) => _searchKegiatan(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (option) => _sortKegiatanList(option),
            sortOptions: SortOption.values.toList(),
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
                        jabatan: kegiatan['jabatan']!,
                        poin: kegiatan['poin']!,
                        tanggalMulai: kegiatan['tanggalMulai']!,
                        tanggalSelesai: kegiatan['tanggalSelesai']!,
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
      floatingActionButton: CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String title,
    required String jabatan,
    required String poin,
    required String tanggalMulai,
    required String tanggalSelesai,
  }) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      jabatan,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$poin Poin',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
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
                          'Tanggal Mulai',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggalMulai,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
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
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggalSelesai,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}