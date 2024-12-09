import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/pic/custom_bottomappbar.dart';
import 'package:sdm/page/pic/daftarkegiatan_page.dart';

class DetailKegiatanPage extends StatefulWidget {
  final int kegiatanId;

  const DetailKegiatanPage({super.key, required this.kegiatanId});

  @override
  DetailKegiatanPageState createState() => DetailKegiatanPageState();
}

class DetailKegiatanPageState extends State<DetailKegiatanPage> {
  KegiatanModel? kegiatan;

  @override
  void initState() {
    super.initState();
    _fetchKegiatanDetail();
  }

  Future<void> _fetchKegiatanDetail() async {
    try {
      final apiKegiatan = ApiKegiatan();
      final kegiatanDetail = await apiKegiatan.getKegiatanPICDetail(widget.kegiatanId);
      setState(() {
        kegiatan = kegiatanDetail;
      });
    } catch (e) {
      print('Error mengambil data kegiatan detail: $e');
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
      body: kegiatan != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                        'Detail Kegiatan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    // Card Body
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
                          _buildDetailField('Deskripsi Kegiatan', kegiatan!.deskripsiKegiatan ?? 'Deskripsi kegiatan belum tersedia'),
                          _buildDetailField('Tanggal Mulai', kegiatan!.tanggalMulai),
                          _buildDetailField('Tanggal Selesai', kegiatan!.tanggalSelesai),
                          _buildDetailField('Tempat Kegiatan', kegiatan!.tempatKegiatan),
                          _buildDetailField('Tanggal Kegiatan', kegiatan!.tanggalAcara),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Daftar Anggota Card
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
                                  _buildDetailField('Jabatan', anggota.jabatanNama, ),
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
                                    MaterialPageRoute(builder: (context) => const DaftarKegiatanPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                child: const Text(
                                  'Kembali',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailField(String title, String content) {
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
            maxLines: 1,
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