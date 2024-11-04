import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';

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
            _buildDosenList(searchQuery),
          ],
        ),
      ),
      floatingActionButton: CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
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

  Widget _buildDosenList(ValueNotifier<String> searchQuery) {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: searchQuery,
        builder: (context, query, child) {
          final filteredDosenData = dosenData.where((dosen) {
            final name = dosen['name']!.toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredDosenData.length,
            itemBuilder: (context, index) => _buildDosenCard(context, filteredDosenData[index]),
          );
        },
      ),
    );
  }

  Widget _buildDosenCard(BuildContext context, Map<String, String> dosen) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 25;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 5, 167, 170),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  dosen['name']!,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRichText('NIP', dosen['nip'], fontSize),
                  const Divider(),
                  _buildRichText('Email', dosen['email'], fontSize),
                  const Divider(),
                  _buildRichText('Poin Saat Ini', dosen['poin'], fontSize),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: TextButton(
                        onPressed: () {
                          // Action for "Lihat Detail" button
                        },
                        child: Text(
                          'Lihat Detail',
                          style: GoogleFonts.poppins(fontSize: fontSize, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
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
}