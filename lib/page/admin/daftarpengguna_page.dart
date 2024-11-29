import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/editpengguna_page.dart';
import 'package:sdm/page/admin/detailpengguna_page.dart';
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
    {'id': '1', 'title': 'Albani Rajata Malik', 'username': 'albani', 'tanggal_lahir': '1990-01-01', 'email': 'albani@domain.com', 'nip': '2024434343490314', 'level': 'Admin'},
    {'id': '2', 'title': 'Nurhidayah Amin', 'username': 'nurhidayah', 'tanggal_lahir': '1991-02-02', 'email': 'nurhidayah@domain.com', 'nip': '2024434343490322', 'level': 'Dosen'},
    {'id': '3', 'title': 'Rizky Aditya', 'username': 'rizky', 'tanggal_lahir': '1992-03-03', 'email': 'rizky@domain.com', 'nip': '2024434343490333', 'level': 'Pimpinan'},
    {'id': '4', 'title': 'Siti Fatimah', 'username': 'siti', 'tanggal_lahir': '1993-04-04', 'email': 'siti@domain.com', 'nip': '2024434343490344', 'level': 'Dosen'},
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

  void _deletePengguna(String id) {
    setState(() {
      penggunaList.removeWhere((pengguna) => pengguna['id'] == id);
      _searchPengguna();
    });
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda ingin menghapus pengguna ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                _deletePengguna(id);
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
                        id: pengguna['id']!,
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
    required String id,
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
            height: 60, // Increased height
            width: double.infinity,
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final updatedPengguna = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPenggunaPage(pengguna: {
                              'id': id,
                              'title': title,
                              'username': username,
                              'tanggal_lahir': penggunaList.firstWhere((pengguna) => pengguna['id'] == id)['tanggal_lahir']!,
                              'email': email,
                              'nip': nip,
                              'level': level,
                            }),
                          ),
                        );
                        if (updatedPengguna != null) {
                          setState(() {
                            final index = penggunaList.indexWhere((p) => p['id'] == updatedPengguna['id']);
                            if (index != -1) {
                              penggunaList[index] = updatedPengguna;
                              _searchPengguna();
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(244, 71, 8, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                    ),
                  ],
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
                        MaterialPageRoute(builder: (context) => DetailPenggunaPage(pengguna: {
                          'id': id,
                          'title': title,
                          'username': username,
                          'tanggal_lahir': penggunaList.firstWhere((pengguna) => pengguna['id'] == id)['tanggal_lahir']!,
                          'email': email,
                          'nip': nip,
                          'level': level,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String title, String? value, double fontSize) {
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
            value ?? '',
            style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ),
      ],
    );
  }
}