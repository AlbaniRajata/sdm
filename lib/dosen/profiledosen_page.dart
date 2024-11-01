import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/dosen/homedosen_page.dart';
import 'package:sdm/dosen/logindosen_page.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfiledosenPage extends StatelessWidget {
  const ProfiledosenPage({super.key});

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
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/pp.png'),
          ),
          const SizedBox(height: 15),
          Text(
            'Albani Rajata Malik',
            style: GoogleFonts.poppins(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
          ),
          Text(
            'albanirajata@polinema.ac.id',
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: screenWidth * 0.035),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              'Edit Profil',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
          const SizedBox(height: 20),
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
              child: Icon(Icons.timer, color: Colors.white, size: screenWidth * 0.05),
            ),
            title: Text(
              'Lihat Progress Kegiatan',
              style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04, color: Colors.black),
            onTap: () {},
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
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogindosenPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
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
              color: Colors.grey.shade400,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomedosenPage(),
                  ),
                );
              },
            ),
            const Spacer(flex: 5),
            IconButton(
              icon: const Icon(Icons.person, size: 40),
              color: Colors.white,
              onPressed: () {},
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
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
                              selectedDate = selectedDay; // Update tanggal yang dipilih
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
        child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}