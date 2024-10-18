import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  primaryColor: const Color.fromRGBO(255, 81, 106, 1),
  scaffoldBackgroundColor: const Color.fromRGBO(243, 244, 246, 1),
  appBarTheme:
      const AppBarTheme(backgroundColor: Color.fromRGBO(243, 244, 246, 1)),
  cardTheme: CardTheme(
    color: Colors.white, // Dark card background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  ),
  dialogTheme:
      ThemeData.light().dialogTheme.copyWith(backgroundColor: Colors.white),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
  visualDensity: VisualDensity.comfortable,
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color.fromRGBO(255, 81, 106, 1),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  cardTheme: CardTheme(
    color: const Color.fromRGBO(26, 26, 26, 1), // Dark card background
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  ),
  dialogTheme: ThemeData.dark()
      .dialogTheme
      .copyWith(backgroundColor: const Color.fromRGBO(46, 46, 46, 1)),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  visualDensity: VisualDensity.standard,
);

var cardOnDialogTheme = (BuildContext context) => Theme.of(context).copyWith(
      cardTheme: Theme.of(context).cardTheme.copyWith(
            color: cardBackgroundColorOnDialog(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
    );

var cardBackgroundColorOnDialog = (BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : null;
