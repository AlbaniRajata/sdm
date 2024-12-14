import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/services/pimpinan/api_user.dart';
import 'package:sdm/page/pimpinan/detaildosen_page.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/dosen_sortoption.dart';
import 'package:sdm/widget/pimpinan/custom_filter.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';

class DaftarDosenPage extends StatefulWidget {
  const DaftarDosenPage({super.key});

  @override
  _DaftarDosenPageState createState() => _DaftarDosenPageState();
}

class _DaftarDosenPageState extends State<DaftarDosenPage> {
  List<UserModel> dosenList = [];
  List<UserModel> filteredDosenList = [];
  DosenSortOption selectedSortOption = DosenSortOption.abjadAZ;
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDosen();
    _searchController.addListener(_searchDosen);
  }

  Future<void> _loadDosen() async {
    try {
      final apiUser = ApiUser();
      final dosen = await apiUser.getAllDosen();
      setState(() {
        dosenList = dosen;
        filteredDosenList = List.from(dosen);
        isLoading = false;
      });
      _sortDosenList(selectedSortOption);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
      }
    }
  }

  void _searchDosen() async {
    if (_searchController.text.length >= 3) {
      try {
        final apiUser = ApiUser();
        final results = await apiUser.searchDosen(_searchController.text);
        setState(() {
          filteredDosenList = results;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    } else {
      setState(() {
        filteredDosenList = List.from(dosenList);
      });
    }
    _sortDosenList(selectedSortOption);
  }

  void _sortDosenList(DosenSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case DosenSortOption.abjadAZ:
          filteredDosenList.sort((a, b) => a.nama.compareTo(b.nama));
          break;
        case DosenSortOption.abjadZA:
          filteredDosenList.sort((a, b) => b.nama.compareTo(a.nama));
          break;
        case DosenSortOption.poinTerbanyak:
          filteredDosenList.sort((a, b) => b.totalPoin.compareTo(a.totalPoin));
          break;
        case DosenSortOption.poinTersedikit:
          filteredDosenList.sort((a, b) => a.totalPoin.compareTo(b.totalPoin));
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
            onSortOptionChanged: _sortDosenList,
            sortOptions: DosenSortOption.values,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDosen,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredDosenList.isEmpty
                      ? Center(
                          child: Text(
                            'Tidak ada data dosen',
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: filteredDosenList.map((dosen) {
                              return Column(
                                children: [
                                  _buildDosenCard(
                                    context,
                                    dosen: dosen,
                                    screenWidth: screenWidth,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),
                          ),
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
    required UserModel dosen,
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
                Expanded(
                  child: Text(
                    dosen.nama,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${dosen.totalPoin} Poin',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
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
                _buildRichText('NIP', dosen.nip, fontSize),
                const Divider(),
                _buildRichText('Email', dosen.email, fontSize),
                const Divider(),
                _buildRichText('Total Kegiatan', '${dosen.totalKegiatan} Kegiatan', fontSize),
                const Divider(),
                _buildRichText('Poin Saat Ini', '${dosen.totalPoin} Poin', fontSize),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailDosenPage(userId: dosen.idUser),
                        ),
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

  Widget _buildRichText(String title, String value, double fontSize) {
    return RichText(
      text: TextSpan(
        text: '$title\n',
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}