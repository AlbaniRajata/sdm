import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/user_model.dart';
import 'package:sdm/models/dosen/statistik_model.dart';
import 'package:sdm/services/dosen/api_statistik.dart';
import 'package:sdm/welcome_page.dart';
import 'package:sdm/page/dosen/detailprofile_page.dart';
import 'package:sdm/page/pic/homepic_page.dart';
import 'package:sdm/page/anggota/homeanggota_page.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfiledosenPage extends StatefulWidget {
  final UserModel user;

  const ProfiledosenPage({
    super.key,
    required this.user,
  });

  @override
  State<ProfiledosenPage> createState() => _ProfiledosenPageState();
}

class _ProfiledosenPageState extends State<ProfiledosenPage> {
  final ApiStatistik _apiStatistik = ApiStatistik();
  StatistikModel? _statistikData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadStatistikData();
  }

  Future<void> _loadStatistikData() async {
    try {
      setState(() => _isLoading = true);
      final statistik = await _apiStatistik.getStatistikDosen();
      if (mounted) {
        setState(() {
          _statistikData = statistik;
          _error = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        debugPrint('Error loading statistik data: $e');
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomePage()),(route) => false,);
      } catch (e) {
        debugPrint('Error selama logout: $e');
        if (mounted) {
          CustomTopSnackBar.show(context, 'Gagal melakukan logout. Silahkan coba lagi.');
        }
      }
    }
  }

  Widget _buildPointsDisplay(double screenWidth) {
    if (_isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 175, 3, 1)),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '- Poin',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            color: const Color.fromRGBO(255, 175, 3, 1),
            onPressed: _loadStatistikData,
          ),
        ],
      );
    }

    return Text(
      '${_statistikData?.totalPoin?.toString() ?? ''} Poin',
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.bold,
      ),
    );
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
      body: RefreshIndicator(
        onRefresh: _loadStatistikData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 15),
              Text(
                widget.user.nama,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.user.email,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: screenWidth * 0.035,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailprofilePage(
                        userData: widget.user,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text(
                  'Detail Profil',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: const Color.fromRGBO(255, 175, 3, 1),
                    size: screenWidth * 0.05,
                  ),
                  const SizedBox(width: 8),
                  _buildPointsDisplay(screenWidth),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 0.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
                  child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.05),
                ),
                title: Text(
                  'Masuk Sebagai PIC',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomePICPage(user: widget.user)),
                  );
                },
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 0.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
                  child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.05),
                ),
                title: Text(
                  'Masuk Sebagai Anggota',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeAnggotaPage(user: widget.user)),
                  );
                },
              ),
              const SizedBox(height: 10),
              Divider(
                thickness: 0.5,
                color: Colors.grey[300],
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
                  child: Icon(Icons.logout, color: Colors.white, size: screenWidth * 0.05),
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
                onTap: () => _handleLogout(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(currentPage: 'profile'),
    );
  }

  Widget _buildLogoutTile(BuildContext context, double screenWidth) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
        child: Icon(
          Icons.logout,
          color: Colors.white,
          size: screenWidth * 0.05,
        ),
      ),
      title: Text(
        'Logout',
        style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: screenWidth * 0.04,
        color: Colors.black,
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar?',
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
              onPressed: () => _handleLogout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}