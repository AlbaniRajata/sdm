import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/models/dosen/notifikasi_model.dart';
import 'package:sdm/page/dosen/detailkegiatan_page.dart';
import 'package:sdm/services/dosen/api_kegiatan.dart';
import 'package:sdm/widget/dosen/custom_bottomappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  NotifikasiPageState createState() => NotifikasiPageState();
}

class NotifikasiPageState extends State<NotifikasiPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiKegiatan _apiKegiatan = ApiKegiatan();
  List<NotifikasiModel> _notifikasiList = [];
  List<NotifikasiModel> _filteredNotifikasi = [];
  Set<int> _readNotifications = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredNotifikasi = List.from(_notifikasiList);
      } else {
        _filteredNotifikasi = _notifikasiList.where((notifikasi) {
          return notifikasi.jabatan.toLowerCase().contains(query) ||
              notifikasi.namaKegiatan.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _initializeNotifications() async {
    await _fetchNotifikasi();
    await _loadReadStatus();
  }

  Future<void> _loadReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readIds = prefs.getStringList('read_notifications') ?? [];
      if (mounted) {
        setState(() {
          _readNotifications = readIds.map((id) => int.parse(id)).toSet();
        });
      }
    } catch (e) {
      debugPrint('Error loading read status: $e');
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readIds = prefs.getStringList('read_notifications') ?? [];
      if (!readIds.contains(notificationId.toString())) {
        readIds.add(notificationId.toString());
        await prefs.setStringList('read_notifications', readIds);
        if (mounted) {
          setState(() {
            _readNotifications.add(notificationId);
          });
        }
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  Future<void> _fetchNotifikasi() async {
    try {
      setState(() => _isLoading = true);
      final notifikasiList = await _apiKegiatan.getNotifikasiDosen();
      if (mounted) {
        setState(() {
          _notifikasiList = notifikasiList;
          _filteredNotifikasi = notifikasiList;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching notifikasi: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await _fetchNotifikasi();
    await _loadReadStatus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifikasi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 103, 119, 239),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                children: [
                  _buildSearchBar(screenWidth),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _filteredNotifikasi.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Tidak ada notifikasi'
                                  : 'Tidak ada hasil pencarian',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredNotifikasi.length,
                            separatorBuilder: (context, index) => Divider(
                              thickness: 0.5,
                              color: Colors.grey[300],
                            ),
                            itemBuilder: (context, index) {
                              final notifikasi = _filteredNotifikasi[index];
                              return _buildNotificationTile(
                                  screenWidth, notifikasi);
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton:
          const CustomBottomAppBar().buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomAppBar(),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari notifikasi',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
              ),
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(double screenWidth, NotifikasiModel notifikasi) {
    bool isRead = _readNotifications.contains(notifikasi.idAnggota);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(255, 175, 3, 1),
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: screenWidth * 0.05,
              ),
            ),
            if (!isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Anda telah ditugaskan sebagai\n',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                ),
              ),
              TextSpan(
                text: '${notifikasi.jabatan}\n',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '${notifikasi.namaKegiatan}\n${notifikasi.tanggalAcara}',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: screenWidth * 0.04,
          color: const Color.fromRGBO(255, 175, 3, 1),
        ),
        onTap: () async {
          await _markAsRead(notifikasi.idAnggota);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailKegiatanPage(idKegiatan: notifikasi.idAnggota),
              ),
            ).catchError((error) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
          }
        },
      ),
    );
  }
}