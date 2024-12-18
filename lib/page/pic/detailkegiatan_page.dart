import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/models/dosen/dokumen_model.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/pic/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
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
      CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
    }
  }

  DokumenModel? _getLatestDokumen() {
    if (kegiatan?.dokumen == null || kegiatan!.dokumen!.isEmpty) {
      return null;
    }
    
    // Filter untuk surat tugas
    final suratTugasDokumen = kegiatan!.dokumen!
        .where((doc) => doc.jenisDokumen.toLowerCase() == 'surat tugas')
        .toList();
    
    if (suratTugasDokumen.isEmpty) {
      return null;
    }

    // Sort berdasarkan ID untuk mendapatkan yang terbaru
    suratTugasDokumen.sort((a, b) => b.idDokumen.compareTo(a.idDokumen));
    return suratTugasDokumen.first;
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
                          
                          // Modified document section untuk surat tugas
                          if (kegiatan?.dokumen != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Surat Tugas',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                final latestDokumen = _getLatestDokumen();
                                if (latestDokumen == null) {
                                  return Text(
                                    'Tidak ada surat tugas tersedia',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  );
                                }
                                
                                return Container(
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
                                              latestDokumen.namaDokumen,
                                              style: GoogleFonts.poppins(fontSize: 12),
                                            ),
                                            Text(
                                              latestDokumen.jenisDokumen,
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
                                          latestDokumen.idDokumen,
                                          latestDokumen.namaDokumen,
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildSectionCard(
                      'Daftar Anggota',
                      Column(
                        children: [
                          if (kegiatan?.anggota == null || kegiatan!.anggota!.isEmpty)
                            Center(
                              child: Text(
                                'Tidak ada anggota terdaftar',
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          else
                            ...kegiatan!.anggota!.map((anggota) => Container(
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
                                          anggota.nama,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Jabatan: ${anggota.jabatanNama}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 5, 167, 170).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Poin: ${anggota.poin}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color.fromARGB(255, 5, 167, 170),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          const SizedBox(height: 16),
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  'Kembali',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
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
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                fontSize: 18,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
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