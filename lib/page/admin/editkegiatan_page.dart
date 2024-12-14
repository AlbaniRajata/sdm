import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:sdm/models/admin/kegiatan_model.dart';
import 'package:sdm/models/admin/anggota_model.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/services/admin/api_kegiatan.dart';

class EditKegiatanPage extends StatefulWidget {
  final KegiatanModel kegiatan;

  const EditKegiatanPage({super.key, required this.kegiatan});

  @override
  EditKegiatanPageState createState() => EditKegiatanPageState();
}

class EditKegiatanPageState extends State<EditKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  
  late TextEditingController _namaKegiatanController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tanggalMulaiController;
  late TextEditingController _tanggalSelesaiController;
  late TextEditingController _tanggalAcaraController;
  late TextEditingController _tempatKegiatanController;
  late String _jenisKegiatan;
  
  List<AnggotaModel> anggotaList = [];
  List<UserModel> dosenList = [];
  List<JabatanKegiatan> jabatanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    final DateFormat displayFormat = DateFormat('dd MMMM yyyy');
    
    _namaKegiatanController = TextEditingController(text: widget.kegiatan.namaKegiatan);
    _deskripsiController = TextEditingController(text: widget.kegiatan.deskripsiKegiatan);
    _tanggalMulaiController = TextEditingController(text: displayFormat.format(widget.kegiatan.tanggalMulai));
    _tanggalSelesaiController = TextEditingController(text: displayFormat.format(widget.kegiatan.tanggalSelesai));
    _tanggalAcaraController = TextEditingController(text: displayFormat.format(widget.kegiatan.tanggalAcara));
    _tempatKegiatanController = TextEditingController(text: widget.kegiatan.tempatKegiatan);
    _jenisKegiatan = widget.kegiatan.jenisKegiatan;
    anggotaList = List.from(widget.kegiatan.anggota);
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final dosens = await _apiKegiatan.getDosen();
      final jabatans = await _apiKegiatan.getJabatan();

      setState(() {
        dosenList = dosens;
        jabatanList = jabatans;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      CustomTopSnackBar.show(context, 'Error mengambil data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _deskripsiController.dispose();
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    _tanggalAcaraController.dispose();
    _tempatKegiatanController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  void _addAnggota() {
    if (dosenList.isEmpty || jabatanList.isEmpty) {
      CustomTopSnackBar.show(context, 'Data dosen atau jabatan belum tersedia');
      return;
    }

    setState(() {
      anggotaList.add(AnggotaModel(
        idUser: dosenList.first.idUser,
        idJabatanKegiatan: jabatanList.first.idJabatanKegiatan!,
        user: dosenList.first,
        jabatan: jabatanList.first,
      ));
    });
  }

  void _deleteAnggota(int index) {
    if (anggotaList.length > 1) {
      setState(() {
        anggotaList.removeAt(index);
      });
    } else {
      CustomTopSnackBar.show(context, 'Minimal harus ada satu anggota');
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        final DateFormat apiFormat = DateFormat('dd MMMM yyyy');
        
        final updatedKegiatan = KegiatanModel(
          idKegiatan: widget.kegiatan.idKegiatan,
          namaKegiatan: _namaKegiatanController.text,
          deskripsiKegiatan: _deskripsiController.text,
          tanggalMulai: apiFormat.parse(_tanggalMulaiController.text),
          tanggalSelesai: apiFormat.parse(_tanggalSelesaiController.text),
          tanggalAcara: apiFormat.parse(_tanggalAcaraController.text),
          tempatKegiatan: _tempatKegiatanController.text,
          jenisKegiatan: _jenisKegiatan,
          progress: widget.kegiatan.progress,
          anggota: anggotaList,
        );

        final savedKegiatan = await _apiKegiatan.updateKegiatan(
          widget.kegiatan.idKegiatan!, 
          updatedKegiatan,
        );

        if (!mounted) return;
        
        CustomTopSnackBar.show(context, 'Berhasil menyimpan perubahan', isError: false);
        Navigator.pop(context, savedKegiatan);
      } catch (e) {
        if (!mounted) return;
        CustomTopSnackBar.show(context, 'Gagal menyimpan perubahan: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Edit Kegiatan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard('Detail Kegiatan'),
                _buildKegiatanForm(),
                const SizedBox(height: 16),
                _buildHeaderCard('Daftar Anggota'),
                _buildAnggotaList(),
                const SizedBox(height: 16),
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

  Widget _buildHeaderCard(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
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
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildKegiatanForm() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          _buildTextField(
            'Nama Kegiatan',
            _namaKegiatanController,
            validator: (value) => value?.isEmpty ?? true ? 'Nama kegiatan harus diisi' : null,
          ),
          _buildTextField(
            'Deskripsi Kegiatan',
            _deskripsiController,
            maxLines: 3,
            validator: (value) => value?.isEmpty ?? true ? 'Deskripsi kegiatan harus diisi' : null,
          ),
          _buildDateField(
            'Tanggal Mulai',
            _tanggalMulaiController,
          ),
          _buildDateField(
            'Tanggal Selesai',
            _tanggalSelesaiController,
          ),
          _buildDateField(
            'Tanggal Acara',
            _tanggalAcaraController,
          ),
          _buildTextField(
            'Tempat Kegiatan',
            _tempatKegiatanController,
            validator: (value) => value?.isEmpty ?? true ? 'Tempat kegiatan harus diisi' : null,
          ),
          _buildJenisKegiatanDropdown(),
        ],
      ),
    );
  }

  Widget _buildAnggotaList() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          ...anggotaList.asMap().entries.map((entry) => _buildAnggotaItem(entry.key)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addAnggota,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Tambah Anggota', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 167, 170),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAnggotaItem(int index) {
    final anggota = anggotaList[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<UserModel>(
            value: dosenList.firstWhere(
              (dosen) => dosen.idUser == anggota.idUser,
              orElse: () => dosenList.first,
            ),
            items: dosenList.map((dosen) {
              return DropdownMenuItem(
                value: dosen,
                child: Text(dosen.nama ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  anggotaList[index] = AnggotaModel(
                    idUser: value.idUser,
                    idJabatanKegiatan: anggota.idJabatanKegiatan,
                    user: value,
                    jabatan: anggota.jabatan,
                  );
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Pilih Dosen',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<JabatanKegiatan>(
            value: jabatanList.firstWhere(
              (jabatan) => jabatan.idJabatanKegiatan == anggota.idJabatanKegiatan,
              orElse: () => jabatanList.first,
            ),
            items: jabatanList.map((jabatan) {
              return DropdownMenuItem(
                value: jabatan,
                child: Text(jabatan.jabatanNama ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  anggotaList[index] = AnggotaModel(
                    idUser: anggota.idUser,
                    idJabatanKegiatan: value.idJabatanKegiatan!,
                    user: anggota.user,
                    jabatan: value,
                  );
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Pilih Jabatan',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteAnggota(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text('Batal',
            style: TextStyle(color: Colors.white)
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 167, 170),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text('Simpan',
            style: TextStyle(color: Colors.white)
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context, controller),
        validator: (value) => value?.isEmpty ?? true ? '$label harus diisi' : null,
      ),
    );
  }

  Widget _buildJenisKegiatanDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _jenisKegiatan,
        items: const [
          DropdownMenuItem(value: 'Kegiatan JTI', child: Text('Kegiatan JTI')),
          DropdownMenuItem(value: 'Kegiatan Non-JTI', child: Text('Kegiatan Non-JTI')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _jenisKegiatan = value;
            });
          }
        },
        decoration: const InputDecoration(
          labelText: 'Jenis Kegiatan',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null ? 'Jenis kegiatan harus dipilih' : null,
      ),
    );
  }
}