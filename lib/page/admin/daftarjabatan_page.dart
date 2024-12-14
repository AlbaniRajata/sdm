import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/services/admin/api_jabatankegiatan.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/custom_filter.dart';
import 'package:sdm/widget/admin/dosen_sortoption.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
import 'package:sdm/page/admin/editjabatan_page.dart';
import 'package:sdm/page/admin/tambahjabatan_page.dart';

class DaftarJabatanPage extends StatefulWidget {
  const DaftarJabatanPage({super.key});

  @override
  DaftarJabatanPageState createState() => DaftarJabatanPageState();
}

class DaftarJabatanPageState extends State<DaftarJabatanPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiJabatanKegiatan _apiJabatanKegiatan = ApiJabatanKegiatan();
  List<JabatanKegiatan> jabatanList = [];
  List<JabatanKegiatan> filteredJabatanList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchJabatan);
    _loadJabatan();
  }

  Future<void> _loadJabatan() async {
    try {
      setState(() => isLoading = true);
      final jabatan = await _apiJabatanKegiatan.getAllJabatanKegiatan();
      setState(() {
        jabatanList = jabatan;
        filteredJabatanList = jabatan;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
    }
  }

  void _searchJabatan() {
    setState(() {
      filteredJabatanList = jabatanList.where((jabatan) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = jabatan.jabatanNama.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortJabatanList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case DosenSortOption.abjadAZ:
          filteredJabatanList.sort((a, b) => a.jabatanNama.compareTo(b.jabatanNama));
          break;
        case DosenSortOption.abjadZA:
          filteredJabatanList.sort((a, b) => b.jabatanNama.compareTo(a.jabatanNama));
          break;
        case DosenSortOption.poinTerbanyak:
          filteredJabatanList.sort((a, b) => b.poin.compareTo(a.poin));
          break;
        case DosenSortOption.poinTersedikit:
          filteredJabatanList.sort((a, b) => a.poin.compareTo(b.poin));
          break;
      }
    });
  }

  Future<void> _deleteJabatan(int id) async {
    try {
      final success = await _apiJabatanKegiatan.deleteJabatanKegiatan(id);
      if (success) {
        CustomTopSnackBar.show(context, 'Jabatan berhasil dihapus', isError: false);
        _loadJabatan();
      }
    } catch (e) {
      CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
    }
  }

  void _showDeleteConfirmationDialog(JabatanKegiatan jabatan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda ingin menghapus jabatan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteJabatan(jabatan.idJabatanKegiatan!);
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
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
          'Daftar Jabatan',
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
          CustomFilter<DosenSortOption>(
            controller: _searchController,
            onChanged: (value) => _searchJabatan(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (DosenSortOption? value) {
              _sortJabatanList(value);
            },
            sortOptions: DosenSortOption.values.toList(),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahJabatanPage(),
                    ),
                  );
                  if (result == true) {
                    _loadJabatan();
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
                  'Tambah Jabatan',
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredJabatanList.isEmpty
                    ? const Center(child: Text('Tidak ada data jabatan'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: filteredJabatanList.map((jabatan) {
                            return Column(
                              children: [
                                _buildJabatanCard(
                                  context,
                                  jabatan: jabatan,
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

  Widget _buildJabatanCard(
    BuildContext context, {
    required JabatanKegiatan jabatan,
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
                  jabatan.jabatanNama,
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditJabatanPage(jabatan: jabatan),
                          ),
                        );
                        if (result == true) {
                          _loadJabatan();
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
                      onPressed: () => _showDeleteConfirmationDialog(jabatan),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildRichText('Nama Jabatan', jabatan.jabatanNama, fontSize),
                const Divider(),
                _buildRichText('Poin', '${jabatan.poin} Poin', fontSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String title, String value, double fontSize) {
    return RichText(
      text: TextSpan(
        text: '$title\n',
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }
}