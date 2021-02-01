import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cllangeduAppBar() {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CLLANG EDU',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Online class',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.w400
          ),
        ),
      ],
    ),
  );
}