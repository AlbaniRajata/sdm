import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/admin/statistik_error.dart';
import 'package:sdm/models/admin/statistik_model.dart';
import 'package:sdm/services/admin/api_statistik.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/dosen_sortoption.dart';
import 'package:sdm/widget/admin/custom_filter.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  StatistikPageState createState() => StatistikPageState();
}

class StatistikPageState extends State<StatistikPage> {
  final TextEditingController _searchController = TextEditingController();
  List<StatistikAdmin> statistikAdminList = [];
  List<StatistikAdmin> filteredStatistikAdminList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;
  final ApiStatistikAdmin _apiStatistikAdmin = ApiStatistikAdmin();

  @override
  void initState() {
    super.initState();
    _fetchStatistikAdmin();
  }

  Future<void> _fetchStatistikAdmin() async {
    try {
      final data = await _apiStatistikAdmin.getStatistikAdmin();
      setState(() {
        statistikAdminList = data;
        filteredStatistikAdminList = data;
      });
    } catch (e) {
      if (e is StatistikAdminError) {
        print('Error: ${e.message}');
      } else {
        print('Error: $e');
      }
    }
  }

  void _searchStatistik() {
    setState(() {
      filteredStatistikAdminList = statistikAdminList.where((statistik) {
        final searchLower = _searchController.text.toLowerCase();
        final namaLower = statistik.nama.toLowerCase();
        return namaLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortStatistikList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case DosenSortOption.abjadAZ:
          filteredStatistikAdminList.sort((a, b) => a.nama.compareTo(b.nama));
          break;
        case DosenSortOption.abjadZA:
          filteredStatistikAdminList.sort((a, b) => b.nama.compareTo(a.nama));
          break;
        case DosenSortOption.poinTerbanyak:
          filteredStatistikAdminList.sort((a, b) => b.totalPoin.compareTo(a.totalPoin));
          break;
        case DosenSortOption.poinTersedikit:
          filteredStatistikAdminList.sort((a, b) => a.totalPoin.compareTo(b.totalPoin));
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
            onChanged: (value) => _searchStatistik(),
            selectedSortOption: selectedSortOption,
            onSortOptionChanged: (option) => _sortStatistikList(option),
            sortOptions: DosenSortOption.values.toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: filteredStatistikAdminList.map((statistik) {
                  return Column(
                    children: [
                      _buildStatistikCard(
                        context,
                        nama: statistik.nama,
                        totalKegiatan: statistik.totalKegiatan,
                        totalPoin: statistik.totalPoin,
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

  Widget _buildStatistikCard(
    BuildContext context, {
    required String nama,
    required int totalKegiatan,
    required double totalPoin,
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
              nama,
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
                          totalKegiatan.toString(),
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
                          totalPoin.toString(),
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