import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF0F5DFE); // Exact blue from designs
  static const Color backgroundLight = Color(0xFFF3F4F6); // Off white
  static const Color solidBlack = Colors.black;
  static const Color pureWhite = Colors.white;

  // Brutalist constants
  static const double borderWidth = 3.5;
  static const double shadowOffset = 6.0;

  static BoxDecoration brutalBox({Color bgColor = pureWhite, bool shadow = true}) {
    return BoxDecoration(
      color: bgColor,
      border: Border.all(color: solidBlack, width: borderWidth),
      boxShadow: shadow
          ? [
              const BoxShadow(
                color: solidBlack,
                offset: Offset(shadowOffset, shadowOffset),
                blurRadius: 0,
              )
            ]
          : null,
    );
  }

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        background: backgroundLight,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
        // Use a stark, bold font for headings
        displayLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, color: solidBlack),
        displayMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, color: solidBlack),
        titleLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800, color: solidBlack),
        bodyLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, color: solidBlack),
        bodyMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w500, color: solidBlack),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: solidBlack),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w800,
          color: solidBlack,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
        shape: const Border(
          bottom: BorderSide(color: solidBlack, width: borderWidth),
        ),
      ),
    );
  }
}
