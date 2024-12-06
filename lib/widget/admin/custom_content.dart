import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/services/admin/api_dashboard.dart';
import 'package:sdm/widget/admin/custom_calendar.dart';

class CustomContent extends StatefulWidget {
  final double screenWidth;

  const CustomContent({Key? key, required this.screenWidth}) : super(key: key);

  @override
  State<CustomContent> createState() => _CustomContentState();
}

class _CustomContentState extends State<CustomContent> {
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
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan JTI',
                  _totalKegiatanJTI.toString(),
                  'Kegiatan JTI',
                  'yang terdaftar dalam sistem',
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan Non JTI',
                  _totalKegiatanNonJTI.toString(),
                  'Kegiatan Non JTI',
                  'yang terdaftar dalam sistem',
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

  Widget _buildInfoSection(String title, String count, String subtitle, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: widget.screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildGradientContainer(count, subtitle, description),
      ],
    );
  }

  Widget _buildGradientContainer(String count, String subtitle, String description) {
    return Container(
      width: widget.screenWidth * 0.96,
      height: widget.screenWidth * 0.4,
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
          _buildBackgroundImage(),
          _buildCountDisplay(count),
          _buildSubtitleDescription(subtitle, description),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/img-min.png',
        fit: BoxFit.cover,
        width: widget.screenWidth * 0.96,
        height: widget.screenWidth * 0.4,
        color: Colors.black.withOpacity(0.2),
        colorBlendMode: BlendMode.dstATop,
      ),
    );
  }

  Widget _buildCountDisplay(String count) {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        width: widget.screenWidth * 0.32,
        height: widget.screenWidth * 0.29,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: widget.screenWidth * 0.22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleDescription(String subtitle, String description) {
    return Positioned(
      bottom: 50,
      left: 165,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: widget.screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: widget.screenWidth * 0.03,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}