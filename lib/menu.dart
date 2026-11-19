import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhumilestari_mobile/navigation/app_route_names.dart';
import 'package:bhumilestari_mobile/navigation/app_user_role.dart';
import 'package:bhumilestari_mobile/widgets/app_bottom_navigation.dart';

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
      bottomNavigationBar: const AppBottomNavigationBar(
        role: AppUserRole.seller,
        currentRoute: AppRouteNames.home,
      ),
    );
  }
}
