import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/page/dosen/daftarkegiatan_nonjti_page.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';

class DetailKegiatanNonJTIPage extends StatefulWidget {
  final int idKegiatan;

  const DetailKegiatanNonJTIPage({
    Key? key,
    required this.idKegiatan,
  }) : super(key: key);

  @override
  State<DetailKegiatanNonJTIPage> createState() => _DetailKegiatanNonJTIPageState();
}

class _DetailKegiatanNonJTIPageState extends State<DetailKegiatanNonJTIPage> {
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

      final data = await _apiKegiatan.getKegiatanDetail(widget.idKegiatan);
      setState(() {
        kegiatan = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
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
                        _buildDetailCard(),
                        const SizedBox(height: 16),
                        _buildAnggotaCard(),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailCard() {
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
              'Detail Kegiatan',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailField('Nama Kegiatan', kegiatan?.namaKegiatan ?? ''),
                _buildDetailField('Deskripsi Kegiatan', 
                    kegiatan?.deskripsiKegiatan ?? 'Tidak ada deskripsi',
                    isDescription: true),
                _buildDetailField('Tanggal Mulai', kegiatan?.tanggalMulai ?? ''),
                _buildDetailField('Tanggal Selesai', kegiatan?.tanggalSelesai ?? ''),
                _buildDetailField('Tempat Acara', kegiatan?.tempatKegiatan ?? ''),
                _buildDetailField('Tanggal Acara', kegiatan?.tanggalAcara ?? ''),
                _buildDetailField('Jenis Kegiatan', kegiatan?.jenisKegiatan ?? ''),
                _buildDetailField('Jabatan', kegiatan?.jabatanNama ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnggotaCard() {
    if (kegiatan?.anggota == null || kegiatan!.anggota!.isEmpty) {
      return const SizedBox();
    }

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
              'Data Anggota',
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
            child: Column(
              children: [
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
                            builder: (context) => const DaftarKegiatanNonJTIPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
            maxLines: isDescription ? 3 : 1,
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