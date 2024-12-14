import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/agenda_model.dart';
import 'package:sdm/services/dosen/api_agenda.dart';
import 'package:sdm/widget/anggota/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';

class DetailKegiatanAgendaPage extends StatefulWidget {
  final int idKegiatan;
  
  const DetailKegiatanAgendaPage({
    Key? key,
    required this.idKegiatan,
  }) : super(key: key);

  @override
  DetailKegiatanAgendaPageState createState() => DetailKegiatanAgendaPageState();
}

class DetailKegiatanAgendaPageState extends State<DetailKegiatanAgendaPage> {
  final ApiAgenda _apiAgenda = ApiAgenda();
  AgendaModel? kegiatan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetailKegiatan();
  }

  Future<void> _fetchDetailKegiatan() async {
    try {
      final data = await _apiAgenda.getDetailAgenda(widget.idKegiatan);
      if (mounted) {
        setState(() {
          kegiatan = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        CustomTopSnackBar.show(context, e.toString());
      }
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
          'Detail Agenda Kegiatan',
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
          : RefreshIndicator(
              onRefresh: _fetchDetailKegiatan,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailCard(),
                      const SizedBox(height: 16),
                      _buildAgendaCard(),
                      const SizedBox(height: 16),
                      _buildBackButton(),
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

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCardHeader('Detail Kegiatan'),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailField('Nama Kegiatan', kegiatan?.namaKegiatan ?? ''),
                _buildDetailField('Tempat Kegiatan', kegiatan?.tempatKegiatan ?? ''),
                _buildDetailField('Tanggal Mulai', kegiatan?.tanggalMulai ?? ''),
                _buildDetailField('Tanggal Selesai', kegiatan?.tanggalSelesai ?? ''),
                _buildDetailField('Tanggal Acara', kegiatan?.tanggalAcara ?? ''),
                _buildDetailField(
                  'Deskripsi', 
                  kegiatan?.deskripsiKegiatan ?? 'Deskripsi kegiatan belum tersedia',
                  isDescription: true
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaCard() {
    if (kegiatan?.agenda == null || kegiatan!.agenda.isEmpty) {
      return Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildCardHeader('Daftar Agenda Saya'),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Tidak ada agenda',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCardHeader('Daftar Agenda Saya'),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: kegiatan!.agenda.asMap().entries.map((entry) {
                final agenda = entry.value;
                return _buildDetailField(
                  'Agenda ${entry.key + 1}',
                  agenda.namaAgenda,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title) {
    return Container(
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
    );
  }

  Widget _buildEmptyCard(String title, String message) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCardHeader(title),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, String value, {bool isDescription = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            readOnly: true,
            maxLines: isDescription ? 5 : 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
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
    );
  }
}