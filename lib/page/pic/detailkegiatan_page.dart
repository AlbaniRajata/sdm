import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/models/dosen/dokumen_model.dart';
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
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchKegiatanDetail();
  }

  Future<void> _fetchKegiatanDetail() async {
    try {
      setState(() => isLoading = true);
      final kegiatanDetail = await _apiKegiatan.getKegiatanPICDetail(widget.kegiatanId);
      setState(() {
        kegiatan = kegiatanDetail;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleDownload(DokumenModel dokumen) async {
    try {
      setState(() => isLoading = true);
      await _apiKegiatan.downloadDokumen(
        dokumen.idDokumen,
        dokumen.namaDokumen,
        context,
      );
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunduh dokumen: ${e.toString()}')),
      );
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
      body: Stack(
        children: [
          if (kegiatan != null)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      'Detail Kegiatan',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailField('Nama Kegiatan', kegiatan!.namaKegiatan),
                          _buildDetailField('Deskripsi Kegiatan', 
                            kegiatan!.deskripsiKegiatan ?? 'Deskripsi kegiatan belum tersedia'),
                          _buildDetailField('Tanggal Mulai', kegiatan!.tanggalMulai),
                          _buildDetailField('Tanggal Selesai', kegiatan!.tanggalSelesai),
                          _buildDetailField('Tempat Kegiatan', kegiatan!.tempatKegiatan),
                          _buildDetailField('Tanggal Kegiatan', kegiatan!.tanggalAcara),
                          if (kegiatan?.dokumen != null && kegiatan!.dokumen!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Dokumen',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...kegiatan!.dokumen!.map((dokumen) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dokumen.namaDokumen,
                                          style: GoogleFonts.poppins(fontSize: 12),
                                        ),
                                        Text(
                                          dokumen.jenisDokumen,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.download, size: 16),
                                    label: const Text('Download'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    onPressed: () => _apiKegiatan.downloadDokumen(
                                      dokumen.idDokumen,
                                      dokumen.namaDokumen,
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildSectionCard(
                      'Daftar Anggota',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kegiatan!.anggota != null)
                            ...kegiatan!.anggota!.map((anggota) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailField('Nama Anggota', anggota.nama),
                                _buildDetailField('Jabatan', anggota.jabatanNama),
                                _buildDetailField('Poin', anggota.poin.toString()),
                                const SizedBox(height: 8.0),
                              ],
                            )).toList(),
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
                                  backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                child: const Text(
                                  'Kembali',
                                  style: TextStyle(color: Colors.white),
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
            )
          else
            const Center(child: CircularProgressIndicator()),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Column(
      children: [
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
            title,
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
          child: content,
        ),
      ],
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