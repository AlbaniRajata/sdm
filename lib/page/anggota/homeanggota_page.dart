// lib/page/anggota/home_anggota_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/user_model.dart';
import 'package:sdm/models/dosen/dashboard_model.dart';
import 'package:sdm/services/dosen/api_dashboard.dart';
import 'package:sdm/page/anggota/daftarkegiatan_page.dart';
import 'package:sdm/page/anggota/daftarkegiatanagenda_page.dart';
import 'package:sdm/widget/anggota/custom_bottomappbar.dart';
import 'package:sdm/widget/anggota/custom_content.dart';

class HomeAnggotaPage extends StatefulWidget {
  final UserModel user;
  const HomeAnggotaPage({super.key, required this.user});

  @override
  State<HomeAnggotaPage> createState() => _HomeAnggotaPageState();
}

class _HomeAnggotaPageState extends State<HomeAnggotaPage> {
  final ApiDashboard _apiDashboard = ApiDashboard();
  DashboardModel? _dashboardData;
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
      final dashboardData = await _apiDashboard.getDashboardAnggota();

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
                  horizontal: 15.0,
                ),
                child: _buildMainContent(context, screenWidth),
              ),
            ],
          ),
          const SizedBox(height: 5),
          CustomContent(
            isLoading: _isLoading,
            error: _error,
            dashboardData: _dashboardData,
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
                'Anda masuk sebagai Anggota',
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
                _buildMenuButton(
                  context,
                  'Kegiatan',
                  Icons.event,
                  const DaftarKegiatanPage(),
                  screenWidth,
                ),
                _buildMenuButton(
                  context,
                  'Agenda Kegiatan',
                  Icons.event,
                  const DaftarKegiatanAgendaPage(),
                  screenWidth,
                ),
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
          width: screenWidth * 0.38,
          height: screenWidth * 0.16,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => page)
            ),
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
}