import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/detailkegiatan_page.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/custom_filter.dart';
import 'package:sdm/widget/admin/pengguna_sortoption.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  DaftarPenggunaPageState createState() => DaftarPenggunaPageState();
}

class DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> penggunaList = [
    {'title': 'Albani Rajata Malik', 'username': 'albani', 'email': 'albani@domain.com', 'nip': '2024434343490314', 'level': 'Admin'},
    {'title': 'Nurhidayah Amin', 'username': 'nurhidayah', 'email': 'nurhidayah@domain.com', 'nip': '2024434343490322', 'level': 'Dosen'},
    {'title': 'Rizky Aditya', 'username': 'rizky', 'email': 'rizky@domain.com', 'nip': '2024434343490333', 'level': 'Pimpinan'},
    {'title': 'Siti Fatimah', 'username': 'siti', 'email': 'siti@domain.com', 'nip': '2024434343490344', 'level': 'Dosen'},
  ];

  List<Map<String, String>> filteredPenggunaList = [];
  PenggunaSortOption selectedSortOption = PenggunaSortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    filteredPenggunaList = penggunaList;
    _searchController.addListener(_searchPengguna);
  }

  void _searchPengguna() {
    setState(() {
      filteredPenggunaList = penggunaList.where((pengguna) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = pengguna['title']!.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortPenggunaList(PenggunaSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case PenggunaSortOption.abjadAZ:
          filteredPenggunaList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case PenggunaSortOption.abjadZA:
          filteredPenggunaList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case PenggunaSortOption.admin:
          filteredPenggunaList = penggunaList.where((pengguna) => pengguna['level'] == 'Admin').toList();
          break;
        case PenggunaSortOption.dosen:
          filteredPenggunaList = penggunaList.where((pengguna) => pengguna['level'] == 'Dosen').toList();
          break;
        case PenggunaSortOption.pimpinan:
          filteredPenggunaList = penggunaList.where((pengguna) => pengguna['level'] == 'Pimpinan').toList();
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
          'Daftar Pengguna',
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
          CustomFilter<PenggunaSortOption>(
            controller: _searchController,
            onChanged: (value) => _searchPengguna(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (PenggunaSortOption? value) {
              _sortPenggunaList(value);
            },
            sortOptions: PenggunaSortOption.values.toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredPenggunaList.map((pengguna) {
                  return Column(
                    children: [
                      _buildPenggunaCard(
                        context,
                        title: pengguna['title']!,
                        username: pengguna['username']!,
                        email: pengguna['email']!,
                        nip: pengguna['nip']!,
                        level: pengguna['level']!,
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

  Widget _buildPenggunaCard(
    BuildContext context, {
    required String title,
    required String username,
    required String email,
    required String nip,
    required String level,
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
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
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
                _buildRichText('Username', username, fontSize),
                const Divider(),
                _buildRichText('Email', email, fontSize),
                const Divider(),
                _buildRichText('NIP', nip, fontSize),
                const Divider(),
                _buildRichText('Level', level, fontSize),
                const Divider(),
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

  Widget _buildRichText(String title, String? value, double fontSize) {
    return RichText(
      text: TextSpan(
        text: '$title\n',
        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ],
      ),
    );
  }
}