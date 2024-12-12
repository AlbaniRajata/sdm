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

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  bool _showFirstPage = true;
  bool _showSecondPage = false;
  bool _showThirdPage = false;
  late AnimationController _controller;
  int _selectedRole = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goForward() {
    setState(() {
      if (_showFirstPage) {
        _showFirstPage = false;
        _showSecondPage = true;
      } else if (_showSecondPage) {
        _showSecondPage = false;
        _showThirdPage = true;
      }
      _controller.forward();
    });
  }

  void _goBackward() {
    setState(() {
      if (_showThirdPage) {
        _showThirdPage = false;
        _showSecondPage = true;
      } else if (_showSecondPage) {
        _showSecondPage = false;
        _showFirstPage = true;
      }
      _controller.forward();
    });
  }

  void _navigateToLoginPage() {
    if (_selectedRole == -1) {
      _showErrorNotification();
    } else {
      if (_selectedRole == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginAdminPage()),
        );
      } else if (_selectedRole == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginDosenPage()),
        );
      } else if (_selectedRole == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginpimpinanPage()),
        );
      }
    }
  }

  void _showErrorNotification() {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.red,
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Text(
                'Anda harus memilih peran terlebih dahulu',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.08; // 8% dari lebar layar
    final verticalPadding = size.height * 0.05; // 5% dari tinggi layar
    final imageHeight = size.height * 0.35; // 35% dari tinggi layar

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/img-min.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height - (verticalPadding * 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                          child: _showFirstPage
                              ? _buildWelcomeContent1(imageHeight)
                              : _showSecondPage
                                  ? _buildWelcomeContent2(imageHeight)
                                  : _buildWelcomeContent3(imageHeight),
                        ),
                        SizedBox(height: size.height * 0.03),
                        if (_showThirdPage) _buildRoleSelector(),
                        SizedBox(height: size.height * 0.02),
                        _buildPageIndicator(),
                        SizedBox(height: size.height * 0.02),
                        _buildActionButton(size),
                        if (!_showFirstPage)
                          _buildBackButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent1(double imageHeight) {
    return Column(
      key: const ValueKey(1),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Image.asset(
            'assets/images/WS2.png',
            height: imageHeight,
            fit: BoxFit.contain,
            key: const ValueKey('WS2'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Selamat Datang, Mari Kita Mulai!',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Ciptakan solusi inovatif dan kelola sumber\ndaya manusia secara efisien dalam satu platform.',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWelcomeContent2(double imageHeight) {
    return Column(
      key: const ValueKey(2),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Image.asset(
            'assets/images/WS1.png',
            height: imageHeight,
            fit: BoxFit.contain,
            key: const ValueKey('WS1'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tingkatkan Kinerja,\nRaih Kesuksesan',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Mengelola kegiatan anda kini lebih mudah.\nBersiaplah untuk mencapai target lebih tinggi.',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWelcomeContent3(double imageHeight) {
    return Column(
      key: const ValueKey(3),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Image.asset(
            'assets/images/WS3.png',
            height: imageHeight,
            fit: BoxFit.contain,
            key: const ValueKey('WS3'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Apa Peran Anda Disini?',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih salah satu untuk masuk ke sistem',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton(Size size) {
    return SizedBox(
      width: size.width * 0.7, // 70% dari lebar layar
      height: size.height * 0.06, // 6% dari tinggi layar
      child: ElevatedButton(
        onPressed: () {
          if (_showFirstPage || _showSecondPage) {
            _goForward();
          } else if (_showThirdPage) {
            _navigateToLoginPage();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 175, 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          _showFirstPage || _showSecondPage ? 'Lanjutkan' : 'Mari Kita Mulai',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: _goBackward,
      child: Text(
        'Kembali',
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.035,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleCircle(0, 'Admin'),
        SizedBox(width: size.width * 0.05),
        _buildRoleCircle(1, 'Dosen'),
        SizedBox(width: size.width * 0.05),
        _buildRoleCircle(2, 'Pimpinan'),
      ],
    );
  }

  Widget _buildRoleCircle(int role, String label) {
    bool isSelected = _selectedRole == role;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
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
            child: Center(
              child: isSelected
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
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
      children: [
        _buildDot(_showFirstPage),
        _buildDot(_showSecondPage),
        _buildDot(_showThirdPage),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}