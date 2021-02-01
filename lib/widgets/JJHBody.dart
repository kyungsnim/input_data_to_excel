import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget jjhBody() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 200),
      Center(
        child: Text(
          '조지형 국어학원',
          style: GoogleFonts.montserrat(
            fontSize: 35,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(offset: Offset(1, 2), blurRadius: 3, color: Colors.black)
            ]
          ),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: Text(
          '답안제출 앱',
          style: GoogleFonts.montserrat(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(offset: Offset(1, 2), blurRadius: 3, color: Colors.black)
              ]
          ),
        ),
      ),
      // Text(
      //   'Online class',
      //   style: GoogleFonts.montserrat(
      //     fontSize: 20,
      //     color: Colors.grey,
      //     shadows: [
      //       Shadow(offset: Offset(1, 1), blurRadius: 1, color: Colors.white)
      //     ]
      //   ),
      // ),
    ],
  );
}