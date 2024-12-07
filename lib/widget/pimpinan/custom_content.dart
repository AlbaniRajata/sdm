import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/pimpinan/custom_calendar.dart';

class CustomContent extends StatefulWidget {
  final double screenWidth;
  final int totalDosen;
  final int totalKegiatanJTI;
  final int totalKegiatanNonJTI;
  final bool isLoading;
  final String error;
  final Future<void> Function() onRefresh;

  const CustomContent({
    Key? key,
    required this.screenWidth,
    required this.totalDosen,
    required this.totalKegiatanJTI,
    required this.totalKegiatanNonJTI,
    required this.isLoading,
    required this.error,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<CustomContent> createState() => _CustomContentState();
}

class _CustomContentState extends State<CustomContent> {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/img-min.png',
              fit: BoxFit.cover,
              width: widget.screenWidth * 0.96,
              height: widget.screenWidth * 0.4,
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
          Positioned(
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
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
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.error.isNotEmpty) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onRefresh,
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
        onRefresh: widget.onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(
                  'Jumlah Dosen',
                  widget.totalDosen.toString(),
                  'Dosen',
                  'yang terdaftar dalam sistem',
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan JTI',
                  widget.totalKegiatanJTI.toString(),
                  'Kegiatan JTI',
                  'yang terdaftar dalam sistem',
                ),
                const SizedBox(height: 20),
                _buildInfoSection(
                  'Jumlah Kegiatan Non JTI',
                  widget.totalKegiatanNonJTI.toString(),
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
}