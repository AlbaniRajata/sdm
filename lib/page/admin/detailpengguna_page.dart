import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/services/admin/api_user.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
import 'package:intl/intl.dart';

class DetailPenggunaPage extends StatefulWidget {
  final UserModel user;

  const DetailPenggunaPage({super.key, required this.user});

  @override
  DetailPenggunaPageState createState() => DetailPenggunaPageState();
}

class DetailPenggunaPageState extends State<DetailPenggunaPage> {
  final ApiUserAdmin _apiService = ApiUserAdmin();
  bool isLoading = true;
  late UserModel userData;

  @override
  void initState() {
    super.initState();
    userData = widget.user;
    _loadUserDetail();
  }

  Future<void> _loadUserDetail() async {
    try {
      final response = await _apiService.getUserDetail(widget.user.idUser);
      if (response.isSuccess) {
        setState(() {
          userData = UserModel.fromJson(response.data);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Load users error: $e');
      CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Detail Pengguna',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  Container(
                    height: 40,
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
                      'Detail Pengguna',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth < 500 ? 14.0 : 16.0,
                      ),
                    ),
                  ),
                  // Card Body
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
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
                        _buildDetailItem('ID', userData.idUser.toString()),
                        _buildDivider(),
                        _buildDetailItem('Username', userData.username),
                        _buildDivider(),
                        _buildDetailItem('Nama Lengkap', userData.nama),
                        _buildDivider(),
                        _buildDetailItem('Tanggal Lahir', DateFormat('dd MMMM yyyy').format(userData.tanggalLahir)),
                        _buildDivider(),
                        _buildDetailItem('Email', userData.email),
                        _buildDivider(),
                        _buildDetailItem('NIP', userData.nip),
                        _buildDivider(),
                        _buildDetailItem('Level', userData.level),
                        const Divider(),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Kembali',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
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
            ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      height: 1,
      thickness: 0.5,
    );
  }
}