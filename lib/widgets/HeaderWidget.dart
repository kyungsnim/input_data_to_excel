import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(BuildContext context, {bool isAppTitle = false, String title, disappearedBackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? 'CLLANG EDU' : title,
      style: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: isAppTitle ? 45 : 22,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.blue,
  );
}