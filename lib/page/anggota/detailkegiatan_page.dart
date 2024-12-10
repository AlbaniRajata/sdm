import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/anggota/custom_bottomappbar.dart';
import 'package:sdm/page/anggota/daftarkegiatan_page.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:intl/intl.dart';

class DetailKegiatanPage extends StatefulWidget {
  final int idKegiatan;

  const DetailKegiatanPage({super.key, required this.idKegiatan});

  @override
  DetailKegiatanPageState createState() => DetailKegiatanPageState();
}

class DetailKegiatanPageState extends State<DetailKegiatanPage> {
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  bool isLoading = true;
  String? error;
  KegiatanModel? kegiatan;

  @override
  void initState() {
    super.initState();
    _loadKegiatanDetail();
  }

  Future<void> _loadKegiatanDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      
      final data = await _apiKegiatan.getKegiatanAnggotaDetail(widget.idKegiatan);
      setState(() {
        kegiatan = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        title: Text(
          'Detail Kegiatan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header Detail Kegiatan
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
                            'Detail Kegiatan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        // Card Body Detail Kegiatan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              _buildDetailField('Nama Kegiatan', kegiatan!.namaKegiatan),
                              _buildDetailField('Deskripsi Kegiatan', 
                                  kegiatan!.deskripsiKegiatan ?? 'Deskripsi kegiatan belum tersedia',
                                  isDescription: true),
                              _buildDetailField('Tanggal Mulai', _formatDate(kegiatan!.tanggalMulai)),
                              _buildDetailField('Tanggal Selesai', _formatDate(kegiatan!.tanggalSelesai)),
                              _buildDetailField('Tempat Kegiatan', kegiatan!.tempatKegiatan),
                              _buildDetailField('Tanggal Kegiatan', _formatDate(kegiatan!.tanggalAcara)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Card Header Daftar Anggota
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
                            'Daftar Anggota',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        // Card Body Daftar Anggota
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              if (kegiatan!.anggota != null)
                                ...kegiatan!.anggota!.map((anggota) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailField('Nama Anggota', anggota.nama),
                                      _buildDetailField('Jabatan', anggota.jabatanNama),
                                      _buildDetailField('Poin', anggota.poin.toString()),
                                      const SizedBox(height: 8.0),
                                    ],
                                  );
                                }).toList(),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const DaftarKegiatanPage(),
                                        ),
                                      );
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailField(String title, String content, {bool isDescription = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: content,
            readOnly: true,
            maxLines: isDescription ? 5 : 1,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}