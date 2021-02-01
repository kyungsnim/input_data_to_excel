import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cllangeduAppBarTest() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'CLLANG EDU',
        style: GoogleFonts.montserrat(
          fontSize: 20,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Online class',
        style: GoogleFonts.montserrat(
          fontSize: 10,
          color: Colors.grey,
          fontWeight: FontWeight.w400
        ),
      ),
    ],
  );
}