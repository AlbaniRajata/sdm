import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/page/admin/loginadmin_page.dart';
import 'package:sdm/page/dosen/logindosen_page.dart';
import 'package:sdm/page/pimpinan/loginpimpinan_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedRole = -1;

  final List<Map<String, dynamic>> _pageData = [
    {
      'image': 'assets/images/WS2.png',
      'title': 'Selamat Datang, Mari Kita Mulai!',
      'subtitle': 'Ciptakan solusi inovatif dan kelola sumber\ndaya manusia secara efisien dalam satu platform.',
    },
    {
      'image': 'assets/images/WS1.png',
      'title': 'Tingkatkan Kinerja, Raih Kesuksesan',
      'subtitle': 'Mengelola kegiatan anda kini lebih mudah.\nBersiaplah untuk mencapai target lebih tinggi.',
    },
    {
      'image': 'assets/images/WS3.png',
      'title': 'Apa Peran Anda Disini?',
      'subtitle': 'Pilih salah satu untuk masuk ke sistem',
    },
  ];

  final List<Widget> _loginPages = [
    const LoginAdminPage(),
    const LogindosenPage(),
    const LoginpimpinanPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLoginPage() {
    if (_currentPage == 2 && _selectedRole == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Anda harus memilih peran terlebih dahulu',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.fixed,
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          elevation: 6,
        ),
      );
      return;
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _loginPages[_selectedRole]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img-min.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pageData.length,
                itemBuilder: (context, index) => _buildPage(index),
              ),
            ),
            if (_currentPage == 2) _buildRoleSelector(),
            const SizedBox(height: 10),
            _buildPageIndicator(),
            const SizedBox(height: 10),
            _buildNavigationButtons(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Image.asset(
            _pageData[index]['image'],
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _pageData[index]['title'],
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _pageData[index]['subtitle'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Admin', 'Dosen', 'Pimpinan'].asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _buildRoleOption(entry.key, entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildRoleOption(int index, String label) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: _selectedRole == index
                ? Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: ElevatedButton(
            onPressed: _navigateToLoginPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 175, 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _currentPage < 2 ? 'Lanjutkan' : 'Mari Kita Mulai',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (_currentPage > 0)
          TextButton(
            onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: Text(
              'Kembali',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}