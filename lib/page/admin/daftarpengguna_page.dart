import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/page/admin/editpengguna_page.dart';
import 'package:sdm/page/admin/detailpengguna_page.dart';
import 'package:sdm/page/admin/tambahpengguna_page.dart';
import 'package:sdm/services/admin/api_user.dart';
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
  final ApiUserAdmin _apiService = ApiUserAdmin();
  List<User> userList = [];
  List<User> filteredUserList = [];
  PenggunaSortOption selectedSortOption = PenggunaSortOption.abjadAZ;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_searchPengguna);
  }

  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    try {
      final response = await _apiService.getUsers();
      debugPrint('API Response: ${response.data}');

      if (response.isSuccess) {
        final users = response.getUserList();
        setState(() {
          userList = users;
          filteredUserList = users;
          _sortPenggunaList(selectedSortOption);
        });
      }
    } catch (e) {
      debugPrint('Load users error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _searchPengguna() {
    setState(() {
      filteredUserList = userList.where((user) {
        final searchLower = _searchController.text.toLowerCase();
        final nameLower = user.nama.toLowerCase();
        return nameLower.contains(searchLower);
      }).toList();
    });
  }

  void _sortPenggunaList(PenggunaSortOption? option) {
    setState(() {
      selectedSortOption = option ?? selectedSortOption;
      switch (selectedSortOption) {
        case PenggunaSortOption.abjadAZ:
          filteredUserList.sort((a, b) => a.nama.compareTo(b.nama));
          break;
        case PenggunaSortOption.abjadZA:
          filteredUserList.sort((a, b) => b.nama.compareTo(a.nama));
          break;
        case PenggunaSortOption.admin:
          filteredUserList =
              userList.where((user) => user.level == 'admin').toList();
          break;
        case PenggunaSortOption.dosen:
          filteredUserList =
              userList.where((user) => user.level == 'dosen').toList();
          break;
        case PenggunaSortOption.pimpinan:
          filteredUserList =
              userList.where((user) => user.level == 'pimpinan').toList();
          break;
      }
    });
  }

  Future<void> _deletePengguna(int id) async {
    try {
      final response = await _apiService.deleteUser(id);
      if (response.isSuccess) {
        await _loadUsers();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna berhasil dihapus')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content:
              const Text('Apakah Anda yakin ingin menghapus pengguna ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                _deletePengguna(id);
                Navigator.of(context).pop();
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
            onSortOptionChanged: _sortPenggunaList,
            sortOptions: PenggunaSortOption.values.toList(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pengguna: ${filteredUserList.length}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TambahPenggunaPage()),
                    );
                    if (result != null) {
                      _loadUsers();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 167, 170),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Tambah Pengguna',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: filteredUserList.isEmpty
                        ? const Center(child: Text('Tidak ada data pengguna'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredUserList.length,
                            itemBuilder: (context, index) {
                              final user = filteredUserList[index];
                              return _buildPenggunaCard(
                                  context, user, screenWidth);
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton:
          const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildPenggunaCard(
      BuildContext context, User user, double screenWidth) {
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    user.nama,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPenggunaPage(user: user),
                          ),
                        );
                        if (result != null) {
                          _loadUsers();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Edit',
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          _showDeleteConfirmationDialog(user.idUser),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(244, 71, 8, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Hapus',
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('Username', user.username, fontSize),
                const Divider(),
                _buildInfoRow('Email', user.email, fontSize),
                const Divider(),
                _buildInfoRow('NIP', user.nip, fontSize),
                const Divider(),
                _buildInfoRow('Level', user.level, fontSize),
                const Divider(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPenggunaPage(user: user),
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

  Widget _buildInfoRow(String label, String value, double fontSize) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
