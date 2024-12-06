import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sdm/models/admin/anggota_model.dart';
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/models/admin/kegiatan_model.dart';
import 'package:sdm/services/admin/api_kegiatan.dart';

class TambahKegiatanPage extends StatefulWidget {
  const TambahKegiatanPage({super.key});

  @override
  TambahKegiatanPageState createState() => TambahKegiatanPageState();
}

class TambahKegiatanPageState extends State<TambahKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalSelesaiController = TextEditingController();
  final TextEditingController _tanggalAcaraController = TextEditingController();
  final TextEditingController _tempatKegiatanController = TextEditingController();
  String? _jenisKegiatan;
  
  List<AnggotaModel> anggotaList = [];
  List<UserModel> dosenList = [];
  List<JabatanKegiatan> jabatanList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final dosens = await _apiKegiatan.getDosen();
      final jabatans = await _apiKegiatan.getJabatan();

      setState(() {
        dosenList = dosens;
        jabatanList = jabatans;
        
        // Initialize with one empty member
        if (dosenList.isNotEmpty && jabatanList.isNotEmpty) {
          anggotaList.add(AnggotaModel(
            idUser: dosenList.first.idUser,
            idJabatanKegiatan: jabatanList.first.idJabatanKegiatan ?? 0,
            user: dosenList.first,
            jabatan: jabatanList.first,
          ));
        }
        
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error mengambil data: $e')),
      );
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 5, 167, 170),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  void _addAnggota() {
    if (dosenList.isEmpty || jabatanList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data dosen atau jabatan belum tersedia')),
      );
      return;
    }

    setState(() {
      anggotaList.add(AnggotaModel(
        idUser: dosenList.first.idUser,
        idJabatanKegiatan: jabatanList.first.idJabatanKegiatan ?? 0,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal harus ada satu anggota')),
      );
    }
  }

  Future<void> _saveKegiatan() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Parse tanggal dari format display ke DateTime
        final DateFormat displayFormat = DateFormat('dd MMMM yyyy');
        
        final newKegiatan = KegiatanModel(
          namaKegiatan: _namaKegiatanController.text,
          deskripsiKegiatan: _deskripsiController.text,
          tanggalMulai: displayFormat.parse(_tanggalMulaiController.text),
          tanggalSelesai: displayFormat.parse(_tanggalSelesaiController.text),
          tanggalAcara: displayFormat.parse(_tanggalAcaraController.text),
          tempatKegiatan: _tempatKegiatanController.text,
          jenisKegiatan: _jenisKegiatan!,
          progress: 0,
          anggota: anggotaList,
        );

        final createdKegiatan = await _apiKegiatan.createKegiatan(newKegiatan);

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menambahkan kegiatan')),
        );

        Navigator.pop(context, createdKegiatan);
      } catch (e) {
        print('Error detail: $e'); // Untuk debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan kegiatan: $e')),
        );
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
          'Tambah Kegiatan',
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
            validator: (value) => value == null ? 'Dosen harus dipilih' : null,
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
                    idJabatanKegiatan: value.idJabatanKegiatan ?? 0,
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
            validator: (value) => value == null ? 'Jabatan harus dipilih' : null,
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
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _saveKegiatan,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 167, 170),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(color: Colors.white),
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