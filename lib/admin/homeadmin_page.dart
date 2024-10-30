import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/admin/detailkegiatan_page.dart';
import 'package:sdm/admin/profileadmin_page.dart';
import 'package:sdm/admin/repositoryadmin_page.dart';
import 'package:sdm/admin/kegiatanadmin_page.dart';
import 'package:sdm/admin/listdosen_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeadminPage extends StatelessWidget {
  const HomeadminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(98, 0, 151, 1),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
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
                Positioned(
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
                      onPressed: () {
                        // Action untuk ke notifikasi
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications, color: Colors.white),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            child: Text(
                              'Notifikasi',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'HR',
                        style: GoogleFonts.poppins(
                          fontSize: 33,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                          height: 0.9,
                        ),
                      ),
                      Text(
                        'Sync',
                        style: GoogleFonts.poppins(
                          fontSize: 33,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sistem Manajemen SDM',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Hai, Albani Rajata',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/home.png',
                                  height: 238,
                                ),
                                Positioned(
                                  top: 15,
                                  left: 95,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Kegiatan Selesai',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '21 Kegiatan',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const KegiatanadminPage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Lihat Daftar Kegiatan',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: const Color.fromRGBO(244, 71, 8, 1),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 10,
                                                  color: Color.fromRGBO(244, 71, 8, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 15,
                                          width: 250,
                                          child: LinearProgressIndicator(
                                            value: 0.5, // Persentase penyelesaian (5 persen)
                                            backgroundColor: Colors.grey.shade300,
                                            valueColor:
                                              const AlwaysStoppedAnimation<Color>(Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height:5),
                                      Text(
                                        '10 Kegiatan Selesai',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 138,
                                  left: 95,
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kegiatan yang Akan Datang',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Kuliah Tamu',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const DetailKegiatanPage(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Lihat Detail Kegiatan',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '24 September 2024',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dosen',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListDosenPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFFF44708),Color(0xFF6777EF),],
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
                                          width: 120,
                                          height: 150,
                                          color: Colors.black.withOpacity(0.2),
                                          colorBlendMode: BlendMode.dstATop,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    'Albani Rajata',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                    child: Text(
                                      '2 Poin',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repository',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RepositoryadminPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final titles = [
                        'Surat Tugas',
                        'Proposal',
                        'Bukti Pencairan Dana',
                        'Dokumentasi',
                        'Laporan Pertanggung Jawaban'
                      ];
                      final documentCounts = [
                        '10 Dokumen',
                        '5 Dokumen',
                        '3 Dokumen',
                        '8 Dokumen',
                        '2 Dokumen'
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/img2.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 80,
                                  colorBlendMode: BlendMode.dstATop,
                                ),
                              ),
                              const Positioned(
                                left: 10,
                                top: 18,
                                child: Icon(
                                  Icons.folder,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              Positioned(
                                left: 60,
                                top: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      titles[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      documentCounts[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              DateTime selectedDate = DateTime.now();
              // List bulan dan tahun
              List<String> bulan = [
                'Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'
              ];
              List<int> tahun = [2021, 2022, 2023, 2024, 2025, 2026];

              String selectedMonth = bulan[selectedDate.month - 1];
              int selectedYear = selectedDate.year;

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: SizedBox(
                      width: 300,
                      height: 450,
                      child: Column(
                        children: [
                          const Text(
                            'Pilih Tanggal Kegiatan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Dropdown untuk bulan dan tahun
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedMonth,
                                items: bulan.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedMonth = newValue!;
                                    selectedDate = DateTime(
                                      selectedYear,
                                      bulan.indexOf(selectedMonth) + 1,
                                      selectedDate.day,
                                    );
                                  });
                                },
                              ),
                              DropdownButton<int>(
                                value: selectedYear,
                                items: tahun.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedYear = newValue!;
                                    selectedDate = DateTime(
                                      selectedYear,
                                      bulan.indexOf(selectedMonth) + 1,
                                      selectedDate.day,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          TableCalendar(
                            locale: 'id_ID', // Set hari dan buan ke Indonesia
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: selectedDate,
                            selectedDayPredicate: (day) {
                              return isSameDay(selectedDate, day); // Menentukan hari yang dipilih
                            },
                            calendarFormat: CalendarFormat.month,
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Month',
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronVisible: false,
                              rightChevronVisible: false,
                            ),
                            onPageChanged: (focusedDay) {
                              setState(() {
                                selectedMonth = bulan[focusedDay.month - 1];
                                selectedYear = focusedDay.year;
                              });
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                selectedDate =
                                    selectedDay; // Update tanggal yang dipilih
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, date, _) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF00CBF1), Color(0xFF6777EF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.calendar_today_rounded,
              color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color.fromARGB(255, 103, 119, 239),
        child: Row(
          children: <Widget>[
            const Spacer(flex: 2),
            IconButton(
              icon: const Icon(Icons.home_rounded, size: 40),
              color: Colors.white,
              onPressed: () {},
            ),
            const Spacer(flex: 5),
            IconButton(
              icon: const Icon(Icons.person, size: 40),
              color: Colors.grey.shade400,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileadminPage(),
                  ),
                );
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
