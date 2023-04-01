import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventariosdenzil/modelos/models.dart';

class ContadorBar extends StatefulWidget {
  final double offset;
  final double? widthT;
  final Color? background;
  final bool isAppBar;
  final int? index;
  List<dynamic>? locations;
  ContadorBar({
    super.key,
    required this.offset,
    required this.widthT,
    required this.locations,
    this.background,
    required this.isAppBar,
    this.index,
  });

  @override
  State<ContadorBar> createState() => ContadorBarState();
}

class ContadorBarState extends State<ContadorBar> {
  int _buenos = 0;
  int _malos = 0;
  int _regulares = 0;
  int _total = 0;

  getContadores(List<dynamic>? locations) {
    _buenos = 0;
    _malos = 0;
    _regulares = 0;
    _total = 0;
    if (kDebugMode) {
      // print(['widget.locations', widget.locations]);
    }
    setState(() {
      widget.locations = locations;
    });
    if ((widget.locations != null)) {
      if (widget.locations!.isNotEmpty) {
        for (var loc in widget.locations!) {
          if (widget.isAppBar) {
            _buenos += int.parse(loc.buenos.toString());
            _malos += int.parse(loc.malos.toString());
            _regulares += int.parse(loc.regulares.toString());
            _total += int.parse(loc.cantidad.toString());
          }
        }
      }
    }
  }

  @override
  void initState() {
    _buenos = 0;
    _malos = 0;
    _regulares = 0;
    _total = 0;
    getContadores(widget.locations);
    super.initState();
    isDarkModeEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = (size.width < 350)
        ? size.width - 15
        : (widget.widthT != null)
            ? widget.widthT!
            : 350;
    return SizedBox(
      width: (widget.widthT != null) ? widget.widthT : width,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: (widget.background != null) ? widget.background! : Colors.white70,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: (widget.background != null)
                  ? widget.background!
                  : Colors.grey[600]!.withOpacity(0.56),
              offset: Offset(0.0, widget.offset),
              blurRadius: widget.offset,
              // spreadRadius: 1.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Contador(
                width: (widget.isAppBar) ? width * 0.2 : width * 0.18,
                titulo: 'total',
                contador: _total,
                color: Colors.blue,
                isAppBar: widget.isAppBar,
                index: widget.index,
                location: (widget.isAppBar) ? null : widget.locations![widget.index!],
              ),
              Contador(
                width: (widget.isAppBar) ? width * 0.19 : width * 0.18,
                titulo: 'buenos',
                contador: _buenos,
                color: Colors.green,
                isAppBar: widget.isAppBar,
                index: widget.index,
                location: (widget.isAppBar) ? null : widget.locations![widget.index!],
              ),
              Contador(
                width: width * 0.19,
                titulo: 'regulares',
                contador: _regulares,
                color: Colors.amber,
                isAppBar: widget.isAppBar,
                index: widget.index,
                location: (widget.isAppBar) ? null : widget.locations![widget.index!],
              ),
              Contador(
                width: (widget.isAppBar) ? width * 0.19 : width * 0.18,
                titulo: 'malos',
                contador: _malos,
                color: Colors.red,
                isAppBar: widget.isAppBar,
                index: widget.index,
                location: (widget.isAppBar) ? null : widget.locations![widget.index!],
              ),
              (widget.isAppBar)
                  ? (widget.isAppBar)
                      ? SizedBox(
                          width: ((width * 0.14) < 42.5) ? width * 0.14 : 42.5,
                          height: 42.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              // border: Border.all(
                              //   color: Colors.green,
                              //   width: 0.5,
                              // ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green[900]!.withOpacity(0.56),
                                  offset: const Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                  // spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ((width * 0.14) < 42.5) ? width * 0.14 : 42.5,
                                  height: 42.5,
                                  child: SvgPicture.asset(
                                    'assets/svg/google-drive-spreadsheet.svg',
                                    color: Colors.green,
                                    semanticsLabel: 'Reporte',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox()
                  : SizedBox(
                      width: width * 0.1,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Contador extends StatefulWidget {
  final String titulo;
  final int contador;
  final double width;
  final MaterialColor? color;
  final bool isAppBar;
  final int? index;
  final Location? location;
  const Contador({
    required this.titulo,
    required this.contador,
    this.color,
    super.key,
    required this.width,
    required this.isAppBar,
    required this.location,
    this.index,
  });

  @override
  State<Contador> createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Container(
        decoration: BoxDecoration(
          color: (widget.isAppBar)
              ? (widget.color != null)
                  ? widget.color![50]
                  : Colors.amber.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: (widget.isAppBar)
                ? (widget.color != null)
                    ? widget.color!
                    : Colors.amber
                : Colors.transparent,
            width: (widget.isAppBar) ? 0.5 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!.withOpacity(0.56),
              offset: Offset(0.0, ((widget.isAppBar) ? 1 : 0)),
              blurRadius: ((widget.isAppBar) ? 1 : 0),
              // spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.titulo.capitalize(),
              style: GoogleFonts.lato(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: (widget.color != null) ? widget.color![900] : Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            FittedBox(
              child: Text(
                (widget.isAppBar)
                    ? widget.contador.toString()
                    : widget.location!
                        .toJson()[(widget.titulo == 'total') ? 'cantidad' : widget.titulo]
                        .toString(),
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  // fontSize: 20,
                  color: (widget.color != null) ? widget.color![900] : Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
