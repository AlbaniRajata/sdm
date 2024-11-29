import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';

class EditPenggunaPage extends StatefulWidget {
  final Map<String, String> pengguna;

  const EditPenggunaPage({super.key, required this.pengguna});

  @override
  EditPenggunaPageState createState() => EditPenggunaPageState();
}

class EditPenggunaPageState extends State<EditPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _emailController;
  late TextEditingController _nipController;
  late TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.pengguna['id']);
    _titleController = TextEditingController(text: widget.pengguna['title']);
    _usernameController = TextEditingController(text: widget.pengguna['username']);
    _tanggalLahirController = TextEditingController(text: widget.pengguna['tanggal_lahir']);
    _emailController = TextEditingController(text: widget.pengguna['email']);
    _nipController = TextEditingController(text: widget.pengguna['nip']);
    _levelController = TextEditingController(text: widget.pengguna['level']);
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _usernameController.dispose();
    _tanggalLahirController.dispose();
    _emailController.dispose();
    _nipController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'id': _idController.text,
        'title': _titleController.text,
        'username': _usernameController.text,
        'tanggal_lahir': _tanggalLahirController.text,
        'email': _emailController.text,
        'nip': _nipController.text,
        'level': _levelController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Edit Pengguna',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  'Edit Pengguna',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth < 500 ? 14.0 : 16.0,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailField('ID', _idController),
                      _buildDetailField('Nama Lengkap', _titleController),
                      _buildDetailField('Username', _usernameController),
                      _buildDetailField('Tanggal Lahir', _tanggalLahirController),
                      _buildDetailField('Email', _emailController),
                      _buildDetailField('NIP', _nipController),
                      _buildDetailField('Level', _levelController),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveChanges,
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
                    ],
                  ),
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

  Widget _buildDetailField(String title, TextEditingController controller, {bool isDescription = false, Color titleColor = Colors.black}) {
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
            controller: controller,
            maxLines: isDescription ? 5 : 1,
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
}