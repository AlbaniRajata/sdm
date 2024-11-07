import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/detaildosen_page.dart';
import 'package:sdm/widget/admin/custom_bottomappbar.dart';
import 'package:sdm/widget/admin/sort_option.dart';

class ListDosenPage extends StatefulWidget {
  const ListDosenPage({super.key});

  @override
  _ListDosenPageState createState() => _ListDosenPageState();
}

class _ListDosenPageState extends State<ListDosenPage> {
  final List<Map<String, String>> dosenData = const [
    {'name': 'Albani Rajata Malik', 'nip': '2024434343490314', 'email': '2024456@polinema.ac.id', 'poin': '7 Poin', 'tanggal': '2024-09-24'},
    {'name': 'Nurhidayah Amin', 'nip': '2024434343490322', 'email': '2024457@polinema.ac.id', 'poin': '10 Poin', 'tanggal': '2024-09-23'},
    {'name': 'Rizky Aditya', 'nip': '2024434343490333', 'email': '2024458@polinema.ac.id', 'poin': '5 Poin', 'tanggal': '2024-09-22'},
    {'name': 'Siti Fatimah', 'nip': '2024434343490344', 'email': '2024459@polinema.ac.id', 'poin': '8 Poin', 'tanggal': '2024-09-21'},
    {'name': 'Ahmad Fauzan', 'nip': '2024434343490355', 'email': '2024460@polinema.ac.id', 'poin': '6 Poin', 'tanggal': '2024-09-20'},
    {'name': 'Dewi Sartika', 'nip': '2024434343490366', 'email': '2024461@polinema.ac.id', 'poin': '9 Poin', 'tanggal': '2024-09-19'},
    {'name': 'Farhan Maulana', 'nip': '2024434343490377', 'email': '2024462@polinema.ac.id', 'poin': '4 Poin', 'tanggal': '2024-09-18'},
    {'name': 'Aisyah Zahra', 'nip': '2024434343490388', 'email': '2024463@polinema.ac.id', 'poin': '12 Poin', 'tanggal': '2024-09-17'},
  ];

  ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  SortOption selectedSortOption = SortOption.abjadAZ;

  @override
  Widget build(BuildContext context) {
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
            _showSortOptionsDialog(context);
          },
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
  }

  void _showSortOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Urutkan berdasarkan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: SortOption.values.map((SortOption option) {
              return RadioListTile<SortOption>(
                title: Text(_getSortOptionText(option)),
                value: option,
                groupValue: selectedSortOption,
                onChanged: (SortOption? value) {
                  setState(() {
                    selectedSortOption = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getSortOptionText(SortOption option) {
    switch (option) {
      case SortOption.abjadAZ:
        return 'Abjad A ke Z';
      case SortOption.abjadZA:
        return 'Abjad Z ke A';
      case SortOption.tanggalTerdekat:
        return 'Tanggal Terdekat';
      case SortOption.tanggalTerjauh:
        return 'Tanggal Terjauh';
      case SortOption.poinTerbanyak:
        return 'Poin Terbanyak';
      case SortOption.poinTersedikit:
        return 'Poin Tersedikit';
      default:
        return '';
    }
  }

  Widget _buildDosenList(ValueNotifier<String> searchQuery) {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: searchQuery,
        builder: (context, query, child) {
          var filteredDosenData = dosenData.where((dosen) {
            final name = dosen['name']!.toLowerCase();
            return name.contains(query.toLowerCase());
          }).toList();

          filteredDosenData = _sortDosenData(filteredDosenData);

          return ListView.builder(
            itemCount: filteredDosenData.length,
            itemBuilder: (context, index) => _buildDosenCard(context, filteredDosenData[index]),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _sortDosenData(List<Map<String, String>> data) {
    switch (selectedSortOption) {
      case SortOption.abjadAZ:
        data.sort((a, b) => a['name']!.compareTo(b['name']!));
        break;
      case SortOption.abjadZA:
        data.sort((a, b) => b['name']!.compareTo(a['name']!));
        break;
      case SortOption.tanggalTerdekat:
        data.sort((a, b) => DateTime.parse(a['tanggal']!).compareTo(DateTime.parse(b['tanggal']!)));
        break;
      case SortOption.tanggalTerjauh:
        data.sort((a, b) => DateTime.parse(b['tanggal']!).compareTo(DateTime.parse(a['tanggal']!)));
        break;
      case SortOption.poinTerbanyak:
        data.sort((a, b) => int.parse(b['poin']!.split(' ')[0]).compareTo(int.parse(a['poin']!.split(' ')[0])));
        break;
      case SortOption.poinTersedikit:
        data.sort((a, b) => int.parse(a['poin']!.split(' ')[0]).compareTo(int.parse(b['poin']!.split(' ')[0])));
        break;
    }
    return data;
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailDosenPage(),
                            ),
                          );
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