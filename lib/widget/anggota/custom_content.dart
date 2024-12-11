import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/dashboard_model.dart';
import 'package:sdm/widget/anggota/custom_calendar.dart';

class CustomContent extends StatelessWidget {
  final bool isLoading;
  final String error;
  final DashboardModel? dashboardData;
  final Future<void> Function() onRefresh;

  const CustomContent({
    Key? key,
    required this.isLoading,
    required this.error,
    required this.dashboardData,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error.isNotEmpty) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onRefresh,
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
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan JTI',
                  dashboardData?.totalKegiatanJti.toString() ?? '0',
                  'Kegiatan JTI',
                  'yang terdaftar dalam sistem',
                  screenWidth,
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan Non JTI',
                  dashboardData?.totalKegiatanNonJti.toString() ?? '0',
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

  Widget _buildInfoSection(
      String title, String count, String subtitle, String description, double screenWidth) {
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

  Widget _buildGradientContainer(
      String count, String subtitle, String description, double screenWidth) {
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