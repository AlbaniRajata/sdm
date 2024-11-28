import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/custom_filter.dart';
import 'package:sdm/widget/admin/dosen_sortoption.dart';

class DaftarJabatanPage extends StatefulWidget {
  const DaftarJabatanPage({super.key});

  @override
  DaftarJabatanPageState createState() => DaftarJabatanPageState();
}

class DaftarJabatanPageState extends State<DaftarJabatanPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> jabatanList = [
    {'title': 'Ketua', 'poin': '10 Poin'},
    {'title': 'Wakil Ketua', 'poin': '8 Poin'},
    {'title': 'Sekretaris', 'poin': '7 Poin'},
    {'title': 'Bendahara', 'poin': '9 Poin'},
  ];

  List<Map<String, String>> filteredJabatanList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;

  @override
  void initState() {
    super.initState();
    filteredJabatanList = jabatanList;
    _searchController.addListener(_searchJabatan);
  }

  void _searchJabatan() {
    setState(() {
      filteredJabatanList = jabatanList.where((jabatan) {
        final searchLower = _searchController.text.toLowerCase();
        final titleLower = jabatan['title']!.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortJabatanList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case DosenSortOption.abjadAZ:
          filteredJabatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case DosenSortOption.abjadZA:
          filteredJabatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case DosenSortOption.poinTerbanyak:
          filteredJabatanList.sort((a, b) => int.parse(b['poin']!.split(' ')[0]).compareTo(int.parse(a['poin']!.split(' ')[0])));
          break;
        case DosenSortOption.poinTersedikit:
          filteredJabatanList.sort((a, b) => int.parse(a['poin']!.split(' ')[0]).compareTo(int.parse(b['poin']!.split(' ')[0])));
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredJabatanList.map((jabatan) {
                  return Column(
                    children: [
                      _buildJabatanCard(
                        context,
                        title: jabatan['title']!,
                        poin: jabatan['poin']!,
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
    required String title,
    required String poin,
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
                _buildRichText('Nama Jabatan', title, fontSize),
                const Divider(),
                _buildRichText('Poin', poin, fontSize),
                // const Divider(),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(builder: (context) => const DetailKegiatanPage()),
                //       );
                //     },
                //     child: Text(
                //       'Lihat Detail',
                //       style: GoogleFonts.poppins(
                //         color: const Color(0xFF00796B),
                //         fontSize: fontSize,
                //       ),
                //     ),
                //   ),
                // ),
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