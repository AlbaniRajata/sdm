// lib/page/pimpinan/detaildosen_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/services/pimpinan/api_user.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';

class DetailDosenPage extends StatefulWidget {
  final int userId;

  const DetailDosenPage({
    super.key,
    required this.userId,
  });

  @override
  State<DetailDosenPage> createState() => _DetailDosenPageState();
}

class _DetailDosenPageState extends State<DetailDosenPage> {
  bool isLoading = true;
  UserModel? dosenData;

  @override
  void initState() {
    super.initState();
    _loadDosenDetail();
  }

  Future<void> _loadDosenDetail() async {
    try {
      final dosen = await ApiUser.getDosenDetail(widget.userId);
      setState(() {
        dosenData = dosen;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
          'Detail Profil Dosen',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dosenData == null
              ? Center(
                  child: Text(
                    'Data tidak ditemukan',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDosenDetail,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/pp.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(height: 15),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 5, 167, 170),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Detail Profil',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailField('Nama', dosenData!.nama),
                                        _buildDetailField('Email', dosenData!.email),
                                        _buildDetailField('NIP', dosenData!.nip),
                                        _buildDetailField(
                                          'Jabatan', 
                                          dosenData!.jabatan.isNotEmpty
                                              ? dosenData!.jabatan.join('\n')
                                              : '-'
                                        ),
                                        _buildDetailField(
                                          'Kegiatan',
                                          dosenData!.kegiatan.isNotEmpty
                                              ? dosenData!.kegiatan.join('\n')
                                              : '-'
                                        ),
                                        _buildDetailField(
                                          'Total Kegiatan',
                                          '${dosenData!.totalKegiatan} Kegiatan'
                                        ),
                                        _buildDetailField(
                                          'Poin Saat Ini',
                                          '${dosenData!.totalPoin} Poin',
                                          isPoinField: true
                                        ),
                                        const SizedBox(height: 16),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            child: Text(
                                              'Kembali',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailField(
    String title,
    String content, {
    bool isDescription = false,
    Color titleColor = Colors.black,
    bool isPoinField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: titleColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: content,
                  readOnly: true,
                  maxLines: isDescription ? 5 : null,
                  style: GoogleFonts.poppins(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              if (isPoinField)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 167, 170),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.white),
                        SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}