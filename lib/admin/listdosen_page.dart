import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/admin/profileadmin_page.dart';
import 'package:sdm/admin/homeadmin_page.dart';
import 'package:table_calendar/table_calendar.dart';

class ListDosenPage extends StatelessWidget {
  const ListDosenPage({super.key});

  final List<Map<String, String>> dosenData = const [
    {'name': 'Albani Rajata Malik', 'nip': '2024434343490314', 'email': '2024456@polinema.ac.id', 'poin': '7 Poin'},
    {'name': 'Nurhidayah Amin', 'nip': '2024434343490322', 'email': '2024457@polinema.ac.id', 'poin': '10 Poin'},
    {'name': 'Rizky Aditya', 'nip': '2024434343490333', 'email': '2024458@polinema.ac.id', 'poin': '5 Poin'},
    {'name': 'Siti Fatimah', 'nip': '2024434343490344', 'email': '2024459@polinema.ac.id', 'poin': '8 Poin'},
    {'name': 'Ahmad Fauzan', 'nip': '2024434343490355', 'email': '2024460@polinema.ac.id', 'poin': '6 Poin'},
    {'name': 'Dewi Sartika', 'nip': '2024434343490366', 'email': '2024461@polinema.ac.id', 'poin': '9 Poin'},
    {'name': 'Farhan Maulana', 'nip': '2024434343490377', 'email': '2024462@polinema.ac.id', 'poin': '4 Poin'},
    {'name': 'Aisyah Zahra', 'nip': '2024434343490388', 'email': '2024463@polinema.ac.id', 'poin': '12 Poin'},
  ];

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> searchQuery = ValueNotifier<String>('');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'List Dosen',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(searchQuery),
            const SizedBox(height: 20),
            _buildDosenGrid(searchQuery),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSearchBar(ValueNotifier<String> searchQuery) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => searchQuery.value = value,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Cari Dosen...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            // Action for filter icon
          },
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
  }

  Widget _buildDosenGrid(ValueNotifier<String> searchQuery) {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: searchQuery,
        builder: (context, query, child) {
          final filteredDosenData = dosenData.where((dosen) {
            final name = dosen['name']!.toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredDosenData.length,
            itemBuilder: (context, index) => _buildDosenCard(context, filteredDosenData[index]),
          );
        },
      ),
    );
  }

  Widget _buildDosenCard(BuildContext context, Map<String, String> dosen) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth < 500 ? 450.0 : 400.0;
    final fontSize = screenWidth < 500 ? 12.0 : 14.0;

    return SizedBox(
      height: cardHeight,
      child: Card(
        color: Colors.white, // Set card background color to white
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 103, 119, 239),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Text(
                dosen['name']!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRichText('NIP', dosen['nip'], fontSize),
                  const Divider(),
                  _buildRichText('Email', dosen['email'], fontSize),
                  const Divider(),
                  _buildRichText('Poin Saat Ini', dosen['poin'], fontSize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String title, String? value, double fontSize) {
    return RichText(
      text: TextSpan(
        text: '$title\n',
        style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ],
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
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color.fromARGB(255, 103, 119, 239),
      child: Row(
        children: <Widget>[
          const Spacer(flex: 2),
          IconButton(
            icon: const Icon(Icons.home_rounded, size: 40),
            color: Colors.grey.shade400,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeadminPage()),
            ),
          ),
          const Spacer(flex: 5),
          IconButton(
            icon: const Icon(Icons.person, size: 40),
            color: Colors.grey.shade400,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileadminPage()),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}