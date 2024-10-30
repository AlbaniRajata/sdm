import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailKegiatanPage extends StatefulWidget {
  const DetailKegiatanPage({Key? key}) : super(key: key);

  @override
  _DetailKegiatanPageState createState() => _DetailKegiatanPageState();
}

class _DetailKegiatanPageState extends State<DetailKegiatanPage> {
  int selectedDateIndex = 1; // Default selected date index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              color: const Color.fromARGB(255, 103, 119, 239),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'September 2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Add spacing between title and calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'][index],
                          style: TextStyle(color: index == selectedDateIndex ? Colors.teal : Colors.black),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: index == selectedDateIndex ? Colors.teal : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${23 + index}',
                            style: TextStyle(
                              color: index == selectedDateIndex ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Detail Kegiatan',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailField('Nama Kegiatan', 'Seminar Nasional'),
                      _buildDetailField('Jenis Kegiatan', 'Kegiatan JTI'),
                      _buildDetailField('Nama Ketua Pelaksana', 'Albani Rajata Malik'),
                      _buildDetailField('Nama Anggota 1', 'Almira S.Pd'),
                      _buildDetailField('Nama Anggota 2', 'Anita S.T.Tr'),
                      _buildDetailField('Nama Anggota 3', 'Sofyan Andani S.T.Tr M.Ti'),
                      _buildDetailField('Nama Anggota 4', '-'),
                      _buildDetailField('Nama Anggota 5', '-'),
                      _buildDetailField('Deskripsi Kegiatan', 'Seminar Nasional yang diadakan oleh Dishub'),
                      _buildDetailField('Dokumen', 'Draft_surat_tugas_SemNas.pdf'),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Kembali'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: content,
            readOnly: true,
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