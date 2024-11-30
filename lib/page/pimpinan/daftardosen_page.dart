import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/pimpinan/detaildosen_page.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/dosen_sortoption.dart';
import 'package:sdm/widget/pimpinan/custom_filter.dart';

class DaftarDosenPage extends StatefulWidget {
  const DaftarDosenPage({super.key});

  @override
  _DaftarDosenPageState createState() => _DaftarDosenPageState();
}

class _DaftarDosenPageState extends State<DaftarDosenPage> {
  final List<Map<String, String>> dosenData = [
    {'name': 'Albani Rajata Malik', 'nip': '2024434343490314', 'email': '2024456@polinema.ac.id', 'poin': '7 Poin', 'tanggal': '2024-09-24'},
    {'name': 'Nurhidayah Amin', 'nip': '2024434343490322', 'email': '2024457@polinema.ac.id', 'poin': '10 Poin', 'tanggal': '2024-09-23'},
    {'name': 'Rizky Aditya', 'nip': '2024434343490333', 'email': '2024458@polinema.ac.id', 'poin': '5 Poin', 'tanggal': '2024-09-22'},
    {'name': 'Siti Fatimah', 'nip': '2024434343490344', 'email': '2024459@polinema.ac.id', 'poin': '8 Poin', 'tanggal': '2024-09-21'},
    {'name': 'Ahmad Fauzan', 'nip': '2024434343490355', 'email': '2024460@polinema.ac.id', 'poin': '6 Poin', 'tanggal': '2024-09-20'},
    {'name': 'Dewi Sartika', 'nip': '2024434343490366', 'email': '2024461@polinema.ac.id', 'poin': '9 Poin', 'tanggal': '2024-09-19'},
    {'name': 'Farhan Maulana', 'nip': '2024434343490377', 'email': '2024462@polinema.ac.id', 'poin': '4 Poin', 'tanggal': '2024-09-18'},
    {'name': 'Aisyah Zahra', 'nip': '2024434343490388', 'email': '2024463@polinema.ac.id', 'poin': '12 Poin', 'tanggal': '2024-09-17'},
  ];

  List<Map<String, String>> filteredDosenList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDosenList = List.from(dosenData);
    _searchController.addListener(_searchDosen);
  }

  void _searchDosen() {
    setState(() {
      filteredDosenList = dosenData.where((dosen) {
        final searchLower = _searchController.text.toLowerCase();
        final nameLower = dosen['name']!.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortDosenList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      filteredDosenList = _sortDosenData(List.from(filteredDosenList));
    });
  }

  List<Map<String, String>> _sortDosenData(List<Map<String, String>> data) {
    switch (selectedSortOption) {
      case DosenSortOption.abjadAZ:
        data.sort((a, b) => a['name']!.compareTo(b['name']!));
        break;
      case DosenSortOption.abjadZA:
        data.sort((a, b) => b['name']!.compareTo(a['name']!));
        break;
      case DosenSortOption.poinTerbanyak:
        data.sort((a, b) => int.parse(b['poin']!.split(' ')[0]).compareTo(int.parse(a['poin']!.split(' ')[0])));
        break;
      case DosenSortOption.poinTersedikit:
        data.sort((a, b) => int.parse(a['poin']!.split(' ')[0]).compareTo(int.parse(b['poin']!.split(' ')[0])));
        break;
    }
    return data;
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
        title: Center(
          child: Text(
            'Daftar Dosen',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomFilter<DosenSortOption>(
            controller: _searchController,
            onChanged: (value) => _searchDosen(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (DosenSortOption? value) {
              _sortDosenList(value);
            },
            sortOptions: DosenSortOption.values,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredDosenList.map((dosen) {
                  return Column(
                    children: [
                      _buildDosenCard(
                        context,
                        name: dosen['name']!,
                        nip: dosen['nip']!,
                        email: dosen['email']!,
                        poin: dosen['poin']!,
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

  Widget _buildDosenCard(
    BuildContext context, {
    required String name,
    required String nip,
    required String email,
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
            height: 45,
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
                  name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
                Text(
                  poin,
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
                _buildRichText('NIP', nip, fontSize),
                const Divider(),
                _buildRichText('Email', email, fontSize),
                const Divider(),
                _buildRichText('Poin Saat Ini', poin, fontSize),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DetailDosenPage()),
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