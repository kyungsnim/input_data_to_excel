import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget recordButton(context, title, tColor, bColor, oColor) {
  return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: oColor),
          color: bColor,
          boxShadow: [
            BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
          ]
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.07,
      child: title
  );
}

Widget webViewLinkButton(context, title, tColor, bColor, oColor) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: oColor),
      color: bColor,
      boxShadow: [
        BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
      ]
    ),
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.07,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   height: MediaQuery.of(context).size.height * 0.03,
        //   child: Image(image: AssetImage(image,))
        // ),
        // SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: tColor,
            fontWeight: FontWeight.bold,
            fontSize: 20
          )
        ),
      ],
    )
  );
}

Widget instargramWebViewLinkButton(context, title, tColor, oColor) {
  return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: oColor),
          gradient: LinearGradient(
            colors: [ Colors.deepOrangeAccent, Colors.deepPurpleAccent,Colors.deepPurple, Colors.purple, Colors.orangeAccent, Colors.orange]
          ),
          boxShadow: [
            BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
          ]
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.03,
          //   child: Image(image: AssetImage(image,))
          // ),
          // SizedBox(width: 10),
          Text(
              title,
              style: GoogleFonts.montserrat(
                  color: tColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              )
          ),
        ],
      )
  );
}