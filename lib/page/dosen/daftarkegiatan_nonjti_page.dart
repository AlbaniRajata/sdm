import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/dosen/detailkegiatan_nonjti_page.dart';
import 'package:sdm/page/dosen/editkegiatan_nonjti_page.dart';
import 'package:sdm/page/dosen/tambahkegiatan_nonjti_page.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:intl/intl.dart';
import 'package:sdm/widget/dosen/sort_option.dart';
import 'package:sdm/widget/dosen/custom_filter.dart';

class DaftarKegiatanNonJTIPage extends StatefulWidget {
  const DaftarKegiatanNonJTIPage({super.key});

  @override
  DaftarKegiatanNonJTIPageState createState() => DaftarKegiatanNonJTIPageState();
}

class DaftarKegiatanNonJTIPageState extends State<DaftarKegiatanNonJTIPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Seminar Nasional', 'jabatan': 'Ketua Pelaksana', 'tanggal_mulai': '01-03-2022', 'tanggal_acara': '02-03-2022', 'tanggal_selesai': '03-03-2022'},
    {'title': 'Kuliah Tamu', 'jabatan': 'Ketua Pelaksana', 'tanggal_mulai': '01-03-2022', 'tanggal_acara': '02-03-2022', 'tanggal_selesai': '03-03-2022'},
    {'title': 'Workshop Teknologi', 'jabatan': 'Ketua Pelaksana', 'tanggal_mulai': '10-04-2022', 'tanggal_acara': '11-04-2022', 'tanggal_selesai': '12-04-2022'},
    {'title': 'Lokakarya Nasional', 'jabatan': 'Ketua Pelaksana', 'tanggal_mulai': '18-05-2022', 'tanggal_acara': '19-05-2022', 'tanggal_selesai': '20-05-2022'},
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
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(a['tanggal_mulai']!).compareTo(DateFormat('dd-MM-yyyy').parse(b['tanggal_mulai']!)));
          break;
        case SortOption.tanggalTerjauh:
          filteredKegiatanList.sort((a, b) => DateFormat('dd-MM-yyyy').parse(b['tanggal_mulai']!).compareTo(DateFormat('dd-MM-yyyy').parse(a['tanggal_mulai']!)));
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
          'Daftar Kegiatan Non JTI',
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
          CustomFilter(
            controller: _searchController,
            onChanged: (value) => _searchKegiatan(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (option) => _sortKegiatanList(option),
            sortOptions: SortOption.values.where((option) => option != SortOption.poinTerbanyak && option != SortOption.poinTersedikit).toList(),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  final newKegiatan = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahKegiatanNonJTIPage(),
                    ),
                  );
                  if (newKegiatan != null) {
                    setState(() {
                      kegiatanList.add(newKegiatan);
                      _searchKegiatan();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 167, 170),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(
                  'Tambah Kegiatan',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenWidth < 500 ? 14.0 : 16.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                        tanggalMulai: _formatDate(kegiatan['tanggal_mulai']!),
                        tanggalAcara: _formatDate(kegiatan['tanggal_acara']!),
                        tanggalSelesai: _formatDate(kegiatan['tanggal_selesai']!),
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
    required String jabatan,
    required String tanggalMulai,
    required String tanggalAcara,
    required String tanggalSelesai,
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final updatedKegiatan = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditKegiatanNonJTIPage(kegiatan: {
                              'title': title,
                              'jabatan': jabatan,
                              'tanggal_mulai': tanggalMulai,
                              'tanggal_acara': tanggalAcara,
                              'tanggal_selesai': tanggalSelesai,
                            }),
                          ),
                        );
                        if (updatedKegiatan != null) {
                          setState(() {
                            final index = kegiatanList.indexWhere((k) => k['title'] == updatedKegiatan['title']);
                            if (index != -1) {
                              kegiatanList[index] = updatedKegiatan;
                              _searchKegiatan();
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
                        _showDeleteConfirmationDialog(title);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jabatan',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          jabatan,
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
                          'Tanggal Acara',
                          style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          tanggalAcara,
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
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DetailKegiatanNonJTIPage(kegiatan: {
                          'title': title,
                          'jabatan': jabatan,
                          'tanggal_mulai': tanggalMulai,
                          'tanggal_acara': tanggalAcara,
                          'tanggal_selesai': tanggalSelesai,
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
}