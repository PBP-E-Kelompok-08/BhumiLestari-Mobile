import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhumilestari_mobile/produk.dart';

class OurHomePage extends StatelessWidget {
  const OurHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F3D2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAFC47A),
        foregroundColor: const Color(0xFF4A6358),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BhumiLestari',
              style: GoogleFonts.changa(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Made with Love - PBP E Team 8',
              style: GoogleFonts.changa(fontSize: 10),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Salam hangat dari Tim BhumiLestari - Sedang dalam pengembangan',
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF4A6358),
        selectedItemColor: const Color(0xFFF3EFC3),
        unselectedItemColor: const Color(0xFFF3EFC3),
        iconSize: 30,
        selectedLabelStyle: GoogleFonts.prompt(fontSize: 10),
        unselectedLabelStyle: GoogleFonts.prompt(fontSize: 10),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProdukPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            label: 'Ringkasan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Lap. Penjualan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFD9D9D9),
              child: Icon(Icons.person, color: Colors.grey, size: 20),
            ),
            label: 'Pengguna',
          ),
        ],
      ),
    );
  }
}
