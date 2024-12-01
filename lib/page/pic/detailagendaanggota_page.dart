import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/pic/detailagendakegiatan_page.dart';
import 'package:sdm/widget/pic/custom_bottomappbar.dart';

class DetailAgendaAnggotaPage extends StatefulWidget {
  const DetailAgendaAnggotaPage({Key? key}) : super(key: key);

  @override
  DetailAgendaAnggotaPageState createState() => DetailAgendaAnggotaPageState();
}

class DetailAgendaAnggotaPageState extends State<DetailAgendaAnggotaPage> {
  bool isEditMode = false; // Flag untuk mode edit
  List<String> agendas = ['Menyiapkan perlengkapan acara']; // Daftar agenda

  final TextEditingController _newAgendaController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detail Agenda',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isEditMode ? Icons.close : Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isEditMode = !isEditMode;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailField(
                                'Nama Anggota',
                                'Almira S.Pd',
                                isEditable: false,
                              ),
                              ..._buildAgendaFields(),
                              if (isEditMode)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: _addAgenda,
                                        icon: const Icon(Icons.add, color: Colors.white),
                                        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: agendas.length > 1 ? _deleteAgenda : null,
                                        icon: const Icon(Icons.delete, color: Colors.white),
                                        label: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 16),
                              if (isEditMode)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditMode = false;
                                        });
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
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _saveAgenda,
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
                                  ],
                                ),
                              if (!isEditMode)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const DetailKegiatanAgendaPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: const Text('Kembali', style: TextStyle(color: Colors.white)),
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

  /// Membuat field untuk agenda
  List<Widget> _buildAgendaFields() {
    return List.generate(agendas.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: isEditMode
            ? TextFormField(
                initialValue: agendas[index],
                onChanged: (value) {
                  agendas[index] = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              )
            : Text(
                '- ${agendas[index]}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
      );
    });
  }

  /// Menambah agenda baru
  void _addAgenda() {
    setState(() {
      agendas.add('Agenda baru');
    });
  }

  /// Menghapus agenda terakhir
  void _deleteAgenda() {
    if (agendas.isNotEmpty) {
      setState(() {
        agendas.removeLast();
      });
    }
  }

  /// Simpan agenda dan keluar dari mode edit
  void _saveAgenda() {
    setState(() {
      isEditMode = false;
    });
  }

  /// Membuat detail field
  Widget _buildDetailField(String title, String content, {bool isEditable = false, Color titleColor = Colors.black54}) {
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
          isEditable
              ? TextFormField(
                  initialValue: content,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                )
              : Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }
}