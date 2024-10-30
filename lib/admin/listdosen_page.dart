import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/admin/profileadmin_page.dart';
import 'package:sdm/admin/homeadmin_page.dart';

class ListDosenPage extends StatelessWidget {
  const ListDosenPage({super.key});

  final List<Map<String, String>> dosenData = const [
    {
      'name': 'Albani Rajata Malik',
      'nip': '2024434343490314',
      'email': '2024456@polinema.ac.id',
      'poin': '7 Poin',
    },
    {
      'name': 'Nurhidayah Amin',
      'nip': '2024434343490322',
      'email': '2024457@polinema.ac.id',
      'poin': '10 Poin',
    },
    {
      'name': 'Rizky Aditya',
      'nip': '2024434343490333',
      'email': '2024458@polinema.ac.id',
      'poin': '5 Poin',
    },
    {
      'name': 'Siti Fatimah',
      'nip': '2024434343490344',
      'email': '2024459@polinema.ac.id',
      'poin': '8 Poin',
    },
    {
      'name': 'Ahmad Fauzan',
      'nip': '2024434343490355',
      'email': '2024460@polinema.ac.id',
      'poin': '6 Poin',
    },
    {
      'name': 'Dewi Sartika',
      'nip': '2024434343490366',
      'email': '2024461@polinema.ac.id',
      'poin': '9 Poin',
    },
    {
      'name': 'Farhan Maulana',
      'nip': '2024434343490377',
      'email': '2024462@polinema.ac.id',
      'poin': '4 Poin',
    },
    {
      'name': 'Aisyah Zahra',
      'nip': '2024434343490388',
      'email': '2024463@polinema.ac.id',
      'poin': '12 Poin',
    },
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
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchQuery,
                builder: (context, query, child) {
                  final filteredDosenData = dosenData.where((dosen) {
                    final name = dosen['name']!.toLowerCase();
                    return name.contains(query.toLowerCase());
                  }).toList();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredDosenData.length,
                        itemBuilder: (context, index) {
                          final dosen = filteredDosenData[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 103, 119, 239),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      dosen['name']!,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            text: 'NIP\n',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: dosen['nip'],
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Email\n',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: dosen['email'],
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Poin Saat Ini\n',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: dosen['poin'],
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 70,
          height: 70,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color.fromARGB(255, 103, 119, 239),
        child: Row(
          children: <Widget>[
            const Spacer(flex: 2),
            LayoutBuilder(
              builder: (context, constraints) {
                double iconSize = constraints.maxWidth * 0.1;
                return IconButton(
                  icon: Icon(Icons.home_rounded, size: iconSize),
                  color: Colors.grey.shade400,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeadminPage(),
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(flex: 5),
            LayoutBuilder(
              builder: (context, constraints) {
                double iconSize = constraints.maxWidth * 0.1;
                return IconButton(
                  icon: Icon(Icons.person, size: iconSize),
                  color: Colors.grey.shade400,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileadminPage(),
                      ),
                    );
                  },
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