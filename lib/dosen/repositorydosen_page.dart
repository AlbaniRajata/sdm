import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:sdm/widget/dosen/repository_sortoption.dart'; // Update with your actual project path

class RepositorydosenPage extends StatefulWidget {
  const RepositorydosenPage({super.key});

  @override
  RepositorydosenPageState createState() => RepositorydosenPageState();
}

class RepositorydosenPageState extends State<RepositorydosenPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Seminar Nasional', 'status': 'Selesai'},
    {'title': 'Kuliah Tamu', 'status': 'Selesai'},
    {'title': 'Ospek', 'status': 'Selesai'},
    {'title': 'Dies Natalis', 'status': 'Selesai'},
  ];
  List<Map<String, String>> filteredKegiatanList = [];
  RepositorySortOption selectedSortOption = RepositorySortOption.abjadAZ;

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
        case RepositorySortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case RepositorySortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
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
          'Repository',
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

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
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
            children: RepositorySortOption.values.map((RepositorySortOption option) {
              return RadioListTile<RepositorySortOption>(
                title: Text(_getSortOptionText(option)),
                value: option,
                groupValue: selectedSortOption,
                onChanged: (RepositorySortOption? value) {
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

  String _getSortOptionText(RepositorySortOption option) {
    switch (option) {
      case RepositorySortOption.abjadAZ:
        return 'Abjad A ke Z';
      case RepositorySortOption.abjadZA:
        return 'Abjad Z ke A';
      default:
        return '';
    }
  }

  Widget _buildKegiatanCard(
    BuildContext context, {
    required String title,
    required String status,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    fontSize: fontSize - 2,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Isi Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Surat Tugas',
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Tambahkan aksi untuk download dokumen
                      },
                      child: Text(
                        'Download Dokumen',
                        style: GoogleFonts.poppins(
                          fontSize: fontSize - 2,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dokumentasi',
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Tambahkan aksi untuk download dokumen
                      },
                      child: Text(
                        'Download Dokumen',
                        style: GoogleFonts.poppins(
                          fontSize: fontSize - 2,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
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