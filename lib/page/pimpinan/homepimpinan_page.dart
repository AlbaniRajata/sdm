import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/page/pimpinan/daftardosen_page.dart';
import 'package:sdm/page/pimpinan/daftarkegiatan_page.dart';
import 'package:sdm/page/pimpinan/notifikasi_page.dart';
import 'package:sdm/page/pimpinan/statistik_page.dart';
import 'package:sdm/services/admin/api_dashboard.dart';
import 'package:sdm/widget/pimpinan/custom_bottomappbar.dart';
import 'package:sdm/widget/pimpinan/custom_calendar.dart';

class HomePimpinanPage extends StatefulWidget {
  final UserModel user;

  const HomePimpinanPage({
    super.key,
    required this.user  
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
              _buildNotificationButton(screenWidth),
              _buildHeaderText(screenWidth),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                child: _buildMainContent(context, screenWidth),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _buildDashboardContent(screenWidth),
        ],
      ),
      floatingActionButton: const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(currentPage: 'home'),
    );
  }

  Widget _buildNotificationButton(double screenWidth) {
    return Positioned(
      top: 28,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 175, 3, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: TextButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const NotifikasiPage()),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.notifications, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                'Notifikasi',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
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
                'Anda masuk sebagai Admin',
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
                _buildMenuButton(context, 'Daftar Dosen', Icons.people_alt, const DaftarDosenPage(), screenWidth),
                _buildMenuButton(context, 'Kegiatan', Icons.event, const DaftarKegiatanPage(), screenWidth),
                _buildMenuButton(context, 'Statistik', Icons.event_note, const StatistikPage(), screenWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget page, double screenWidth) {
    return Column(
      children: [
        SizedBox(
          width: screenWidth * 0.22,
          height: screenWidth * 0.16,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
            child: Icon(icon, color: Colors.white, size: screenWidth * 0.1),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: GoogleFonts.poppins(color: Colors.black, fontSize: screenWidth * 0.03),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashboardContent(double screenWidth) {
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDashboardData,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  'Jumlah Dosen',
                  _totalDosen.toString(),
                  'Dosen',
                  'yang terdaftar dalam sistem',
                  screenWidth,
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan JTI',
                  _totalKegiatanJTI.toString(),
                  'Kegiatan JTI',
                  'yang terdaftar dalam sistem',
                  screenWidth,
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan Non JTI',
                  _totalKegiatanNonJTI.toString(),
                  'Kegiatan Non JTI',
                  'yang terdaftar dalam sistem',
                  screenWidth,
                ),
                const SizedBox(height: 20),
                CustomCalendar(
                  focusedDay: DateTime.now(),
                  selectedDay: DateTime.now(),
                  onDaySelected: (selectedDay) {},
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String count, String subtitle, String description, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildGradientContainer(count, subtitle, description, screenWidth),
      ],
    );
  }

  Widget _buildGradientContainer(String count, String subtitle, String description, double screenWidth) {
    return Container(
      width: screenWidth * 0.96,
      height: screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFF44708), Color(0xFF6777EF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/img-min.png',
              fit: BoxFit.cover,
              width: screenWidth * 0.96,
              height: screenWidth * 0.4,
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: screenWidth * 0.32,
              height: screenWidth * 0.29,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Text(
                  count,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 165,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}