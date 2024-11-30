import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:intl/intl.dart';

class TambahKegiatanNonJTIPage extends StatefulWidget {
  const TambahKegiatanNonJTIPage({super.key});

  @override
  _TambahKegiatanNonJTIPageState createState() => _TambahKegiatanNonJTIPageState();
}

class _TambahKegiatanNonJTIPageState extends State<TambahKegiatanNonJTIPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _namaAnggotaController = TextEditingController(text: 'Albani Rajata Malik');
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _dokumenController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAcaraController = TextEditingController();
  final TextEditingController _tanggalSelesaiController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _saveKegiatan() {
    if (_formKey.currentState!.validate()) {
      final newKegiatan = {
        'title': _namaKegiatanController.text,
        'jabatan': 'Anggota',
        'tanggal_mulai': _tanggalMulaiController.text,
        'tanggal_acara': _tanggalAcaraController.text,
        'tanggal_selesai': _tanggalSelesaiController.text,
        'deskripsi': _deskripsiController.text,
        'dokumen': _dokumenController.text,
        'nama_anggota': _namaAnggotaController.text,
        'jenis': 'Non JTI',
      };
      Navigator.pop(context, newKegiatan);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        title: Text(
          'Tambah Kegiatan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Header
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
                    'Detail Kegiatan',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
                // Card Body
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
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
                      _buildDetailField('Nama Kegiatan', _namaKegiatanController, screenWidth),
                      _buildDetailField('Nama Anggota', _namaAnggotaController, screenWidth),
                      _buildDetailField('Deskripsi Kegiatan', _deskripsiController, screenWidth, isDescription: true),
                      _buildDetailField('Dokumen', _dokumenController, screenWidth),
                      _buildDateField('Tanggal Mulai', _tanggalMulaiController, screenWidth),
                      _buildDateField('Tanggal Acara', _tanggalAcaraController, screenWidth),
                      _buildDateField('Tanggal Selesai', _tanggalSelesaiController, screenWidth),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _saveKegiatan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 5, 167, 170),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
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
      floatingActionButton: CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailField(String title, TextEditingController controller, double screenWidth, {bool isDescription = false, Color titleColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: titleColor,
              fontSize: screenWidth * 0.035,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            maxLines: isDescription ? 5 : 1, // Increase maxLines for description
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isi $title';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String title, TextEditingController controller, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: screenWidth * 0.035,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            onTap: () => _selectDate(context, controller),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mohon isi $title';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}