import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/services/admin/api_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final UserModel userData;
  
  const EditProfilePage({
    super.key,
    required this.userData,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nipController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final ApiProfile _apiProfile = ApiProfile();

  void _showNotification(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.nama);
    _emailController = TextEditingController(text: widget.userData.email);
    _nipController = TextEditingController(text: widget.userData.nip);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nipController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profil',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  widget.userData.nama,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  widget.userData.email,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileForm(screenWidth),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(currentPage: 'profile'),
    );
  }

  Widget _buildProfileForm(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
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
                'Edit Profil',
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
                  _buildDetailField('Nama Lengkap', _nameController),
                  const SizedBox(height: 16),
                  _buildDetailField('Email', _emailController),
                  const SizedBox(height: 16),
                  _buildDetailField('NIP', _nipController),
                  const SizedBox(height: 16),
                  _buildReadOnlyField('Jabatan', widget.userData.level),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    'Password Lama',
                    _oldPasswordController,
                    _isOldPasswordVisible,
                    (value) => setState(() => _isOldPasswordVisible = value),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    'Password Baru',
                    _newPasswordController,
                    _isNewPasswordVisible,
                    (value) => setState(() => _isNewPasswordVisible = value),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    'Konfirmasi Password',
                    _confirmPasswordController,
                    _isConfirmPasswordVisible,
                    (value) => setState(() => _isConfirmPasswordVisible = value),
                  ),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
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
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isLoading ? null : () {
            if (_validateInputs()) {
              _showConfirmationDialog();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 5, 167, 170),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            hintText: 'Masukkan $label',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    ValueChanged<bool> onVisibilityChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            hintText: 'Masukkan $label',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => onVisibilityChanged(!isVisible),
            ),
          ),
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nipController.text.isEmpty) {
      _showNotification('Semua field harus diisi', Colors.red);
      return false;
    }

    if (_newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_oldPasswordController.text.isEmpty) {
        _showNotification(
          'Password lama harus diisi untuk mengubah password',
          Colors.red
        );
        return false;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showNotification(
          'Password baru dan konfirmasi password tidak cocok',
          Colors.red
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    
    try {
      final updatedUser = await _apiProfile.updateProfile(
        widget.userData.idUser,
        nama: _nameController.text,
        email: _emailController.text,
        nip: _nipController.text,
        oldPassword: _newPasswordController.text.isNotEmpty ? _oldPasswordController.text : null,
        newPassword: _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
        confirmPassword: _newPasswordController.text.isNotEmpty ? _confirmPasswordController.text : null,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(updatedUser.toJson()));

      if (mounted) {
        _showNotification('Profil berhasil diperbarui', Colors.green);
        Navigator.pop(context, updatedUser);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Gagal memperbarui profil';
        if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }
        _showNotification(errorMessage, Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Konfirmasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menyimpan perubahan?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveChanges();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 5, 167, 170),
            ),
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}