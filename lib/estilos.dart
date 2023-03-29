import 'package:flutter/material.dart';

double fontSize = 12.5;
const double toolbarHeight = 65;
Color primario = Colors.blue.shade900;
const Color color1 = Color(0xFFFFFFFF);
const Color color2 = Color(0xFF6C7689);
const Color color3 = Color(0xFF1F2633);
const Color color4 = Color(0xFFFFAD33);
const Color color5 = Color(0xFF203599);
//--------
final Color buenosB = Colors.green[400]!;
final Color buenosW = Colors.green[600]!;
final Color malosB = Colors.red[200]!;
final Color malosW = Colors.redAccent[700]!;
final Color regularesB = Colors.orange[400]!;
final Color regularesW = Colors.orange[600]!;

Color getColor(String estado) {
  switch (estado) {
    case 'Bueno':
      return buenosB;
    case 'Malo':
      return malosB;
    case 'Regular':
      return regularesB;
    default:
      return buenosB;
  }
}

TextStyle floatingLabelStyle = const TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);

final BoxDecoration neumorpDecoration = BoxDecoration(
  color: color1,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(5),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[600]!..withOpacity(0.7),
      offset: const Offset(2.0, 2.0),
      blurRadius: 5.0,
      spreadRadius: 3.5,
    ),
    const BoxShadow(
      color: Colors.white,
      offset: Offset(-2.0, -2.0),
      blurRadius: 5.0,
      spreadRadius: 3.5,
    ),
  ],
);

final BoxDecoration circleNeumorpDecorationWhite = BoxDecoration(
  color: color1,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[600]!..withOpacity(0.7),
      offset: const Offset(2.0, 2.0),
      blurRadius: 3.0,
      spreadRadius: 1.5,
    ),
    const BoxShadow(
      color: Colors.white,
      offset: Offset(-2.0, -2.0),
      blurRadius: 3.0,
      spreadRadius: 1.5,
    ),
  ],
);
final BoxDecoration circleNeumorpDecorationBlack = BoxDecoration(
  color: color1,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.55),
      offset: const Offset(0.0, 10.0),
      blurRadius: 10.0,
      spreadRadius: 1.5,
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.155),
      offset: const Offset(2.0, -2.0),
      blurRadius: 5.0,
      spreadRadius: 3.5,
    ),
  ],
);

final BoxDecoration bottonBarDecorationBlack = BoxDecoration(
  color: color3.withOpacity(0.8), //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[600]!,
      offset: const Offset(0.0, 10.0),
      blurRadius: 10.0,
      spreadRadius: 2.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration bottonBarDecorationWhite = BoxDecoration(
  color: color1, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(35),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(1.5, 1.5),
      blurRadius: 5.0,
      spreadRadius: 1.25,
    ),
    BoxShadow(
      color: Colors.grey[600]!.withOpacity(0.245),
      offset: const Offset(-0.5, 0.0),
      blurRadius: 2.50,
      spreadRadius: 0.25,
    ),
  ],
);

final BoxDecoration sideMenuDecorationBlack = BoxDecoration(
  color: color3.withOpacity(0.8), //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.55),
      offset: const Offset(0.0, 10.0),
      blurRadius: 10.0,
      spreadRadius: 1.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration sideMenuDecorationWhite = BoxDecoration(
  color: color1.withOpacity(0.8), //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(3.0, 3.0),
      blurRadius: 5.0,
      spreadRadius: 2.5,
    ),
    BoxShadow(
      color: Colors.grey[600]!.withOpacity(0.45),
      offset: const Offset(-1.0, 0.0),
      blurRadius: 5.0,
      spreadRadius: 1.5,
    ),
  ],
);

final BoxDecoration sideMenuDecorationBlack2 = BoxDecoration(
  color: color3.withOpacity(0.8), //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  // borderRadius: BorderRadius.circular(10),
  borderRadius:
      const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.55),
      offset: const Offset(0.0, 10.0),
      blurRadius: 10.0,
      spreadRadius: 1.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration sideMenuDecorationWhite2 = BoxDecoration(
  color: color1.withOpacity(0.8), //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius:
      const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      offset: const Offset(3.0, 3.0),
      blurRadius: 5.0,
      spreadRadius: 2.5,
    ),
    BoxShadow(
      color: Colors.grey[600]!.withOpacity(0.45),
      offset: const Offset(-1.0, 0.0),
      blurRadius: 5.0,
      spreadRadius: 1.5,
    ),
  ],
);

final BoxDecoration logoDecorationBlack = BoxDecoration(
  color: color5.withOpacity(0.85),
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: const [
    BoxShadow(
      color: color5,
      offset: Offset(1.0, 1.0),
      blurRadius: 10.0,
      spreadRadius: 2.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration logoDecorationWhite = BoxDecoration(
  color: color5.withOpacity(0.85),
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: const [
    BoxShadow(
      color: color5,
      offset: Offset(1.0, 1.0),
      blurRadius: 5.0,
      // spreadRadius: 2.5,
    ),
    // BoxShadow(
    //   color: Colors.grey[300]!.withOpacity(0.5),
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);

final BoxDecoration infoDecorationBlack = BoxDecoration(
  color: color3, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(6),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.55),
      offset: const Offset(0.0, 2.5),
      blurRadius: 6.0,
      spreadRadius: 1.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration infoDecorationWhite = BoxDecoration(
  color: color1, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(6),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0.0, 3.0),
      blurRadius: 5.0,
      // spreadRadius: 2.5,
    ),
    // BoxShadow(
    //   color: Colors.grey[600]!.withOpacity(0.25),
    //   offset: Offset(0.0, 3.0),
    //   blurRadius: 10.0,
    //   // spreadRadius: 1.5,
    // ),
  ],
);

final BoxDecoration loCardDecorationBlack = BoxDecoration(
  color: color3, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.55),
      offset: const Offset(0.0, 2.5),
      blurRadius: 6.0,
      spreadRadius: 1.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
final BoxDecoration loCardDecorationWhite = BoxDecoration(
  color: color1, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0.0, 3.0),
      blurRadius: 5.0,
      // spreadRadius: 2.5,
    ),
    // BoxShadow(
    //   color: Colors.grey[600]!.withOpacity(0.25),
    //   offset: Offset(0.0, 3.0),
    //   blurRadius: 10.0,
    //   // spreadRadius: 1.5,
    // ),
  ],
);

final BoxDecoration contInfDecorationBlack = BoxDecoration(
  color: color3,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[600]!.withOpacity(0.56),
      offset: const Offset(0.0, 5.0),
      blurRadius: 5.0,
      // spreadRadius: 1.0,
    ),
  ],
);
final BoxDecoration contInfDecorationWhite = BoxDecoration(
  color: color3,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[600]!.withOpacity(0.35),
      offset: const Offset(0.0, 5.0),
      blurRadius: 5.0,
      // spreadRadius: 1.0,
    ),
  ],
);

final BoxDecoration scanButton = BoxDecoration(
  color: color4, //Colors.grey[600]!,
  // borderRadius: BorderRadius.all(Radius.circular(50)),
  borderRadius: BorderRadius.circular(50),
  boxShadow: const [
    BoxShadow(
      color: color2,
      offset: Offset(1.0, 1.0),
      blurRadius: 10.0,
      spreadRadius: 0.5,
    ),
    // BoxShadow(
    //   color: Colors.white,
    //   offset: Offset(-3.0, -3.0),
    //   blurRadius: 5.0,
    //   spreadRadius: 3.5,
    // ),
  ],
);
