import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  visualDensity: VisualDensity.comfortable,
);

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  cardTheme: CardTheme(
    color: Colors.grey[900], // Dark card background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  ),
  dialogTheme: ThemeData.dark().dialogTheme.copyWith(
        backgroundColor: Colors.grey[900],
      ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  visualDensity: VisualDensity.standard,
);

var cardOnDialogTheme = (BuildContext context) => Theme.of(context).copyWith(
      cardTheme: CardTheme(
        color: cardBackgroundColorOnDialog(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    );

var cardBackgroundColorOnDialog = (BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.grey.shade50;
