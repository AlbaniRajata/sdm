import 'package:flutter/material.dart';
import 'package:sdm/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

// haloo saya yunika
// haloo saya nur
// haloo saya nurhidayah
// haloo saya nur1
// haloo soff
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Manajemen SDM',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const WelcomePage(),
    );
  }
}
