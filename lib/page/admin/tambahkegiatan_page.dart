import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/custom_horizontalcalendar.dart';

class TambahKegiatanPage extends StatefulWidget {
  const TambahKegiatanPage({Key? key}) : super(key: key);

  @override
  _TambahKegiatanPageState createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends State<TambahKegiatanPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  String? _selectedJenisKegiatan;

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomHorizontalCalendar(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: (date) {
                  setState(() {
                    _selectedDay = date;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    color: Colors.white,
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
                            'Detail Kegiatan',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailField('Nama Kegiatan', ''),
                              _buildJenisKegiatanField(),
                              _buildDetailField('Nama Ketua Pelaksana', ''),
                              _buildDetailField('Nama Anggota 1', ''),
                              _buildDetailField('Nama Anggota 2', ''),
                              _buildDetailField('Nama Anggota 3', ''),
                              _buildDetailField('Nama Anggota 4', ''),
                              _buildDetailField('Nama Anggota 5', ''),
                              _buildDetailField('Deskripsi Kegiatan', '', isDescription: true),
                              _buildDetailField('Dokumen', ''),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement save functionality here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 5, 167, 170),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Simpan',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildDetailField(String title, String content, {bool isDescription = false, Color titleColor = Colors.black}) {
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
          TextFormField(
            initialValue: content,
            maxLines: isDescription ? 5 : 1, // Increase maxLines for description
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

  Widget _buildJenisKegiatanField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jenis Kegiatan',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: _selectedJenisKegiatan,
            items: <String>['Kegiatan JTI', 'Kegiatan Non-JTI']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedJenisKegiatan = newValue;
              });
            },
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