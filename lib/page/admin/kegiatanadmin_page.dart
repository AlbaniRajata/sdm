import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/detailkegiatan_page.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:intl/intl.dart';
import 'package:sdm/widget/admin/kegiatan_sortoption.dart';

class KegiatanadminPage extends StatefulWidget {
  const KegiatanadminPage({super.key});

  @override
  KegiatanadminPageState createState() => KegiatanadminPageState();
}

class KegiatanadminPageState extends State<KegiatanadminPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Seminar Nasional', 'status': 'Disetujui', 'ketua': 'Albani Rajata Malik', 'tanggal': '2022-03-03'},
    {'title': 'Kuliah Tamu', 'status': 'Disetujui', 'ketua': 'Albani Rajata Malik', 'tanggal': '2022-03-03'},
    {'title': 'Workshop Teknologi', 'status': 'Menunggu', 'ketua': 'Siti Fadhilah', 'tanggal': '2022-04-12'},
    {'title': 'Lokakarya Nasional', 'status': 'Ditolak', 'ketua': 'Rizki Pratama', 'tanggal': '2022-05-20'},
  ];
  List<Map<String, String>> filteredKegiatanList = [];
  KegiatanSortOption selectedSortOption = KegiatanSortOption.abjadAZ;

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

  void _sortKegiatanList() {
    setState(() {
      switch (selectedSortOption) {
        case KegiatanSortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case KegiatanSortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case KegiatanSortOption.tanggalTerdekat:
          filteredKegiatanList.sort((a, b) => DateTime.parse(a['tanggal']!).compareTo(DateTime.parse(b['tanggal']!)));
          break;
        case KegiatanSortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => DateTime.parse(b['tanggal']!).compareTo(DateTime.parse(a['tanggal']!)));
          break;
        default:
          break;
      }
    });
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(parsedDate);
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
          _buildSearchBar(screenWidth),
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
                        status: kegiatan['status']!,
                        ketua: kegiatan['ketua']!,
                        tanggal: _formatDate(kegiatan['tanggal']!),
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
                hintText: 'Cari Kegiatan...',
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
              _showSortOptionsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSortOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Urutkan berdasarkan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: KegiatanSortOption.values.map((KegiatanSortOption option) {
              return RadioListTile<KegiatanSortOption>(
                title: Text(_getSortOptionText(option)),
                value: option,
                groupValue: selectedSortOption,
                onChanged: (KegiatanSortOption? value) {
                  setState(() {
                    selectedSortOption = value!;
                    _sortKegiatanList();
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getSortOptionText(KegiatanSortOption option) {
    switch (option) {
      case KegiatanSortOption.abjadAZ:
        return 'Abjad A ke Z';
      case KegiatanSortOption.abjadZA:
        return 'Abjad Z ke A';
      case KegiatanSortOption.tanggalTerdekat:
        return 'Tanggal Terdekat';
      case KegiatanSortOption.tanggalTerjauh:
        return 'Tanggal Terjauh';
      default:
        return '';
    }
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String title,
    required String status,
    required String ketua,
    required String tanggal,
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
                Text(
                  status,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
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
                          'Tanggal Selesai',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggal,
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
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DetailKegiatanPage()),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}