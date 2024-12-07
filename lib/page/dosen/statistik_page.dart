import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/statistik_data.dart';
import 'package:sdm/services/dosen/api_statistik.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:sdm/widget/dosen/sort_option.dart';
import 'package:sdm/widget/dosen/custom_filter.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  StatistikPageState createState() => StatistikPageState();
}

class StatistikPageState extends State<StatistikPage> {
  final TextEditingController _searchController = TextEditingController();
  List<StatistikItem> kegiatanList = [];
  List<StatistikItem> filteredKegiatanList = [];
  SortOption selectedSortOption = SortOption.abjadAZ;
  double totalPoin = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStatistikDosen();
    _searchController.addListener(_searchKegiatan);
  }

  Future<void> _fetchStatistikDosen() async {
    try {
      final apiStatistik = ApiStatistik();
      final statistikModel = await apiStatistik.getStatistikDosen();

      setState(() {
        kegiatanList = statistikModel.statistik ?? [];
        filteredKegiatanList = kegiatanList;
        totalPoin = statistikModel.totalPoin ?? 0.0;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
      // Show error message to the user or perform any necessary action
    }
  }

  void _searchKegiatan() {
    setState(() {
      filteredKegiatanList = kegiatanList.where((kegiatan) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = kegiatan.namaKegiatan?.toLowerCase() ?? '';
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortKegiatanList(SortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case SortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) =>
              (a.namaKegiatan ?? '').compareTo(b.namaKegiatan ?? ''));
          break;
        case SortOption.abjadZA:
          filteredKegiatanList.sort((a, b) =>
              (b.namaKegiatan ?? '').compareTo(a.namaKegiatan ?? ''));
          break;
        case SortOption.tanggalTerdekat:
          filteredKegiatanList.sort((a, b) => (a.tanggalAcara ?? '')
              .compareTo(b.tanggalAcara ?? ''));
          break;
        case SortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => (b.tanggalAcara ?? '')
              .compareTo(a.tanggalAcara ?? ''));
          break;
        case SortOption.poinTerbanyak:
          filteredKegiatanList.sort((a, b) => (b.poin ?? 0).compareTo(a.poin ?? 0));
          break;
        case SortOption.poinTersedikit:
          filteredKegiatanList.sort((a, b) => (a.poin ?? 0).compareTo(b.poin ?? 0));
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
                children: [
                  Text(
                    'Total Poin: $totalPoin',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filteredKegiatanList.map((kegiatan) {
                    return Column(
                      children: [
                        _buildKegiatanCard(
                          context,
                          title: kegiatan.namaKegiatan ?? '',
                          jabatan: kegiatan.jabatan ?? '',
                          poin: kegiatan.poin ?? 0.0,
                          tanggalMulai: kegiatan.tanggalAcara ?? '',
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String title,
    required String jabatan,
    required double poin,
    required String tanggalMulai,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity, // Menyesuaikan dengan lebar layar
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
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 5, 167, 170),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // Isi Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Jabatan',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  jabatan,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Poin',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '$poin Poin',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  tanggalMulai,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
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