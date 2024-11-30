import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/dosen_sortoption.dart';
import 'package:sdm/widget/pimpinan/custom_filter.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  StatistikPageState createState() => StatistikPageState();
}

class StatistikPageState extends State<StatistikPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> kegiatanList = [
    {'title': 'Albani Rajata Malik', 'total kegiatan': '4', 'total poin': '10'},
    {'title': 'Tasya Cantika Ristiyana', 'total kegiatan': '7', 'total poin': '8'},
    {'title': 'Alya Rafani', 'total kegiatan': '6', 'total poin': '5'},
    {'title': 'Altaf Rafandra', 'total kegiatan': '9', 'total poin': '3'},
  ];
  List<Map<String, String>> filteredKegiatanList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;

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

  void _sortKegiatanList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case DosenSortOption.abjadAZ:
          filteredKegiatanList.sort((a, b) => a['title']!.compareTo(b['title']!));
          break;
        case DosenSortOption.abjadZA:
          filteredKegiatanList.sort((a, b) => b['title']!.compareTo(a['title']!));
          break;
        case DosenSortOption.poinTerbanyak:
          filteredKegiatanList.sort((a, b) => int.parse(b['total poin']!).compareTo(int.parse(a['total poin']!)));
          break;
        case DosenSortOption.poinTersedikit:
          filteredKegiatanList.sort((a, b) => int.parse(a['total poin']!).compareTo(int.parse(b['total poin']!)));
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
            sortOptions: DosenSortOption.values.toList(),
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
                        totalkegiatan: kegiatan['total kegiatan']!,
                        totalpoin: kegiatan['total poin']!,
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
    required String totalkegiatan,
    required String totalpoin,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Kegiatan',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          totalkegiatan,
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
                          'Total Poin',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          totalpoin,
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