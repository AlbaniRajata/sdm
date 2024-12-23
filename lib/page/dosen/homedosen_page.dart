import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/user_model.dart';
import 'package:sdm/models/dosen/dashboard_model.dart';
import 'package:sdm/services/dosen/api_dashboard.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/page/dosen/daftarkegiatan_page.dart';
import 'package:sdm/page/dosen/daftarkegiatanjti_page.dart';
import 'package:sdm/page/dosen/daftarkegiatan_nonjti_page.dart';
import 'package:sdm/page/dosen/statistik_page.dart';
import 'package:sdm/page/dosen/notifikasi_page.dart';
import 'package:sdm/widget/dosen/custom_content.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDosenPage extends StatefulWidget {
  final UserModel user;

  const HomeDosenPage({
    super.key,
    required this.user,
  });

  @override
  State<HomeDosenPage> createState() => _HomeDosenPageState();
}

class _HomeDosenPageState extends State<HomeDosenPage> {
  final ApiDashboard _apiDashboard = ApiDashboard();
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  DashboardModel? _dashboardData;
  bool _isLoading = true;
  String _error = '';
  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _checkUnreadNotifications();
  }

  Future<void> _checkUnreadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readIds = prefs.getStringList('read_notifications') ?? [];
      final notifications = await _apiKegiatan.getNotifikasiDosen();
      
      if (mounted) {
        setState(() {
          _hasUnreadNotifications = notifications.any(
            (notif) => !readIds.contains(notif.idAnggota.toString()));
        });
      }
    } catch (e) {
      debugPrint('Error checking notifications: $e');
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() => _isLoading = true);
      final dashboardData = await _apiDashboard.getDashboardData();

      if (mounted) {
        setState(() {
          _dashboardData = dashboardData;
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
      debugPrint('Error loading dashboard data: $e');
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadDashboardData();
          await _checkUnreadNotifications();
        },
        child: Column(
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 15.0,
                  ),
                  child: _buildMainContent(context, screenWidth),
                ),
              ],
            ),
            const SizedBox(height: 5),
            _buildDashboardContent(screenWidth),
          ],
        ),
      ),
      floatingActionButton:
          const CustomBottomAppBar().buildFloatingActionButton(context),
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotifikasiPage()),
                );
                _checkUnreadNotifications();
              },
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
            if (_hasUnreadNotifications)
              Positioned(
                right: 5,
                top: -5,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText(double screenWidth) {
    return Positioned(
      top: 80,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'SI',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.06,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
              height: 0.9,
            ),
          ),
          Text(
            'SDM',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.06,
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
                'Anda masuk sebagai Dosen',
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
      height: screenWidth * 0.58,
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
                _buildMenuButton(
                  context,
                  'Kegiatan',
                  Icons.event,
                  const DaftarKegiatanPage(),
                  screenWidth,
                ),
                _buildMenuButton(
                  context,
                  'Kegiatan JTI',
                  Icons.event,
                  const DaftarKegiatanJTIPage(),
                  screenWidth,
                ),
                _buildMenuButton(
                  context,
                  'Kegiatan Non-JTI',
                  Icons.event,
                  const DaftarKegiatanNonJTIPage(),
                  screenWidth,
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.04),
            _buildMenuButton(
              context,
              'Statistik',
              Icons.bar_chart,
              const StatistikPage(),
              screenWidth,
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
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 174, 3, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
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
            fontSize: screenWidth * 0.03,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashboardContent(double screenWidth) {
    return CustomContent(
      isLoading: _isLoading,
      error: _error,
      dashboardData: _dashboardData,
      onRefresh: _loadDashboardData,
    );
  }
}