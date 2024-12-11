import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/page/pimpinan/daftardosen_page.dart';
import 'package:sdm/page/pimpinan/daftarkegiatan_page.dart';
import 'package:sdm/page/pimpinan/statistik_page.dart';
import 'package:sdm/services/admin/api_dashboard.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/custom_content.dart';

class HomePimpinanPage extends StatefulWidget {
  final UserModel user;

  const HomePimpinanPage({
    super.key,
    required this.user,
  });

  @override
  State<HomePimpinanPage> createState() => _HomePimpinanPageState();
}

class _HomePimpinanPageState extends State<HomePimpinanPage> {
  final ApiDashboard _apiDashboard = ApiDashboard();
  int _totalDosen = 0;
  int _totalKegiatanJTI = 0;
  int _totalKegiatanNonJTI = 0;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() => _isLoading = true);
      final totalDosen = await _apiDashboard.getTotalDosen();
      final totalKegiatanJTI = await _apiDashboard.getTotalKegiatanJTI();
      final totalKegiatanNonJTI = await _apiDashboard.getTotalKegiatanNonJTI();
      
      if (mounted) {
        setState(() {
          _totalDosen = totalDosen;
          _totalKegiatanJTI = totalKegiatanJTI;
          _totalKegiatanNonJTI = totalKegiatanNonJTI;
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(98, 0, 151, 1),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/back.png',
                  fit: BoxFit.cover,
                  height: 250,
                ),
              ),
              _buildHeaderText(screenWidth),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 15.0
                ),
                child: _buildMainContent(context, screenWidth),
              ),
            ],
          ),
          const SizedBox(height: 5),
          CustomContent(
            isLoading: _isLoading,
            error: _error,
            totalDosen: _totalDosen,
            totalKegiatanJTI: _totalKegiatanJTI,
            totalKegiatanNonJTI: _totalKegiatanNonJTI,
            onRefresh: _loadDashboardData,
          ),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(currentPage: 'home'),
    );
  }

  Widget _buildHeaderText(double screenWidth) {
    return Positioned(
      top: 65,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'SI',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.08,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
              height: 0.9,
            ),
          ),
          Text(
            'SDM',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.08,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anda masuk sebagai Pimpinan',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 45),
              Text(
                'Hai, ${widget.user.nama}',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              _buildMenuContainer(context, screenWidth),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuContainer(BuildContext context, double screenWidth) {
    return Container(
      height: screenWidth * 0.31,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMenuButton(context, 'Daftar Dosen', Icons.people_alt, 
                  const DaftarDosenPage(), screenWidth),
                _buildMenuButton(context, 'Kegiatan', Icons.event, 
                  const DaftarKegiatanPage(), screenWidth),
                _buildMenuButton(context, 'Statistik', Icons.event_note, 
                  const StatistikPage(), screenWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, 
      Widget page, double screenWidth) {
    return Column(
      children: [
        SizedBox(
          width: screenWidth * 0.22,
          height: screenWidth * 0.16,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => page)
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
            ),
            child: Icon(icon, color: Colors.white, size: screenWidth * 0.1),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: screenWidth * 0.03
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}