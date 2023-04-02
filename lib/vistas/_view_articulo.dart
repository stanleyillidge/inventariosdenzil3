import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../apis/_firestore.dart';
import '../estilos.dart';
import '../modelos/models.dart';

class ViewArticuloPage extends StatefulWidget {
  final CollectionReference locationCollection;
  final String title;
  final int sedeIndex;
  final int ubicacionIndex;
  final int subUbicacionIndex;
  final int inventarioIndex;
  final int articuloIndex;
  const ViewArticuloPage({
    super.key,
    required this.title,
    required this.locationCollection,
    required this.sedeIndex,
    required this.ubicacionIndex,
    required this.subUbicacionIndex,
    required this.inventarioIndex,
    required this.articuloIndex,
  });

  @override
  State<ViewArticuloPage> createState() => ViewArticuloPageState();
}

class ViewArticuloPageState extends State<ViewArticuloPage> {
  final double _LocationCardsWidt = 350;
  Articulo? articulo;
  String estado = 'Bueno';
  List<String> estados = [
    'Bueno',
    'Malo',
    'Regular',
  ];
  String _sedekey = '';
  String _sede = '';
  String _ubicacionkey = '';
  String _ubicacion = '';
  List<Location>? _subUbicaciones = [];
  String _subUbicacion = '';
  String subtitulo = '';
  String titulo = '';
  bool dataload = false;

  init() async {
    articulos = await getArticulos(widget.locationCollection);
    setState(() {
      articulos = articulos;
      isDataLoad = true;
    });
  }

  @override
  void initState() {
    dataload = true;
    // mapLocation().then((value) => dataload = true);
    titulo = 'Sede ${sedes![widget.sedeIndex].nombre}';
    subtitulo =
        '${ubicaciones![widget.ubicacionIndex].nombre} - ${subUbicaciones![widget.subUbicacionIndex].nombre}';
    isDataLoad = false;
    setState(() {
      articulo = articulos![widget.articuloIndex];
      estado = articulos![widget.articuloIndex].estado!;
      _sedekey = articulos![widget.articuloIndex].sede!.key!;
      _sede = articulos![widget.articuloIndex].sede!.nombre!;
      _ubicacion = articulos![widget.articuloIndex].ubicacion!.nombre!;
      _subUbicaciones = subUbicaciones;
      _subUbicacion = articulos![widget.articuloIndex].subUbicacion!.nombre!;
    });
    init();
    // getSeriales();
    super.initState();
    isDarkModeEnabled = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onStateChanged(bool isDarkModeEnabled2) async {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
    // await storage.put('isDark', isDarkModeEnabled);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = (size.width > _LocationCardsWidt) ? size.width - 15 : _LocationCardsWidt;
    appBarTitleWidth = (size.width > size.width * 0.7) ? size.width * 0.7 : size.width - 15;
    return Scaffold(
      key: scaffoldViewArticuloPagekey,
      extendBody: true,
      appBar: appBarInst(
        titulo,
        0,
        appBarTitleWidth,
        subtitulo,
        ((articulos != null) ? articulos![widget.articuloIndex].nombre! : ''),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400]!.withOpacity(0.56),
                              offset: const Offset(0.0, 1.0),
                              blurRadius: 1.0,
                              // spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: (articulos![widget.articuloIndex].imagen != null)
                            ? (articulos![widget.articuloIndex].imagen!.contains('shapes'))
                                ? Image.asset(
                                    'assets/shapes.png',
                                    width: width * 0.9,
                                    fit: BoxFit.cover,
                                    // height: 100,
                                  )
                                : Image.network(
                                    articulos![widget.articuloIndex].imagen!,
                                    fit: BoxFit.cover,
                                    width: width * 0.9,
                                  )
                            : Image.asset(
                                'assets/shapes.png',
                                width: width * 0.9,
                                fit: BoxFit.cover,
                                // height: 100,
                              ),
                        // const Placeholder(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            articulos![widget.articuloIndex].nombre!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.9,
                    // height: 40,
                    child: (dataload)
                        ? FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.black45),
                                  errorStyle: const TextStyle(color: Colors.redAccent),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Sede',
                                  floatingLabelStyle: floatingLabelStyle,
                                  contentPadding:
                                      const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                                  isDense: true,
                                ),
                                isEmpty: (articulos![widget.articuloIndex].sede!.nombre != null)
                                    ? (articulos![widget.articuloIndex].sede!.nombre == '')
                                    : false,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: articulos![widget.articuloIndex].sede!.nombre,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _sedekey =
                                            sedes!.where((s) => s.nombre == newValue).first.key;
                                        _sede = newValue!;
                                        // articulos![widget.articuloIndex].sede!.nombre = newValue;
                                        // state.didChange(newValue);
                                      });
                                    },
                                    items: sedes!.map((s) => s.nombre).toList().map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          )
                        : const LinearProgressIndicator(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.9,
                    // height: 40,
                    child: (dataload)
                        ? FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.black45),
                                  errorStyle: const TextStyle(color: Colors.redAccent),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Ubicacion',
                                  floatingLabelStyle: floatingLabelStyle,
                                  contentPadding:
                                      const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                                  isDense: true,
                                ),
                                isEmpty: (_ubicacion == '') ? true : false,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _ubicacion,
                                    isDense: true,
                                    onChanged: (newValue) async {
                                      _subUbicaciones!.clear();
                                      _subUbicacion = '';
                                      var collection = FirebaseFirestore.instance
                                          .collection('sedes')
                                          .doc(_sedekey)
                                          .collection('ubicaciones');
                                      List<Location>? ubicaciones = await getLocation(collection);
                                      var u =
                                          ubicaciones.where((s) => s.nombre == newValue).toList();
                                      if (kDebugMode) {
                                        print(['Nuevas ubicaciones', ubicaciones.length, u.length]);
                                      }
                                      if (u.isNotEmpty) {
                                        _ubicacionkey = u[0].key;
                                        var collection2 = FirebaseFirestore.instance
                                            .collection('sedes')
                                            .doc(_sedekey)
                                            .collection('ubicaciones')
                                            .doc(_ubicacionkey)
                                            .collection('subUbicaciones');
                                        _subUbicaciones = await getLocation(collection2);
                                        if (kDebugMode) {
                                          print(['Nuevas ubicaciones', _subUbicaciones!.length]);
                                        }
                                        if (_subUbicaciones!.isNotEmpty) {
                                          _subUbicacion = _subUbicaciones![0].nombre;
                                        }
                                        if (kDebugMode) {
                                          print(
                                              ['Nuevas _subUbicaciones', _subUbicaciones!.length]);
                                        }
                                      }
                                      setState(() {
                                        _subUbicaciones = _subUbicaciones;
                                        _subUbicacion = _subUbicacion;
                                        _ubicacion = newValue!;
                                        if (newValue ==
                                            articulos![widget.articuloIndex].ubicacion!.nombre) {
                                          _subUbicacion = articulos![widget.articuloIndex]
                                              .subUbicacion!
                                              .nombre!;
                                        }
                                        // articulos![widget.articuloIndex].ubicacion!.nombre =
                                        //     newValue;
                                        // state.didChange(newValue);
                                      });
                                    },
                                    items: ubicaciones!
                                        .map((s) => s.nombre)
                                        .toList()
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                          width: width * 0.78,
                                          child: Text(
                                            value,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          )
                        : const LinearProgressIndicator(),
                  ),
                ),
                // (_subUbicaciones!.isNotEmpty)?
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.9,
                    // height: 40,
                    child: (dataload)
                        ? FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.black45),
                                  errorStyle: const TextStyle(color: Colors.redAccent),
                                  border: const OutlineInputBorder(),
                                  labelText: 'SubUbicacion',
                                  floatingLabelStyle: floatingLabelStyle,
                                  contentPadding:
                                      const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                                  isDense: true,
                                ),
                                isEmpty: (_subUbicacion == '') ? true : false,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _subUbicacion,
                                    isDense: true,
                                    onChanged: (newValue) async {
                                      setState(() {
                                        _subUbicacion = newValue!;
                                        // articulos![widget.articuloIndex]
                                        //     .subUbicacion!
                                        //     .nombre = newValue;
                                      });
                                    },
                                    items: _subUbicaciones!
                                        .map((s) => s.nombre)
                                        .toList()
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                          width: width * 0.78,
                                          child: Text(
                                            value,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          )
                        : const LinearProgressIndicator(),
                  ),
                ),
                // : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width * 0.9,
                    // height: 40,
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            errorStyle: const TextStyle(color: Colors.redAccent),
                            border: const OutlineInputBorder(),
                            labelText: 'Estado del articulo',
                            floatingLabelStyle: floatingLabelStyle,
                            contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                            isDense: true,
                          ),
                          isEmpty: (articulos![widget.articuloIndex].estado != null)
                              ? (articulos![widget.articuloIndex].estado == '')
                              : false,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: articulos![widget.articuloIndex].estado,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  articulos![widget.articuloIndex].estado = newValue;
                                  // state.didChange(newValue);
                                });
                              },
                              items: estados.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DateTimeFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            errorStyle: const TextStyle(color: Colors.redAccent),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.event_note, size: 30),
                            labelText: 'Fecha de creacion',
                            floatingLabelStyle: floatingLabelStyle,
                            contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                            isDense: true,
                          ),
                          dateTextStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          initialValue: DateFormat('dd/M/yyyy', 'es').parse(articulo!.creacion!),
                          dateFormat: DateFormat('EE dd MMM yyyy hh:mm a', 'es'),
                          firstDate: DateTime.now().add(const Duration(days: -45)),
                          lastDate: DateTime.now().add(const Duration(days: 0)),
                          initialDate: DateTime.now().add(const Duration(days: 0)),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) =>
                              (e?.day ?? 0) == 1 ? 'Por favor no en el dia actual' : null,
                          onDateSelected: (DateTime value) {
                            setState(() {
                              // acta_fechaRep.text =
                              //     DateFormat('EEEE dd MMMM hh:mm a', 'es').format(value).toString();
                              // _acta_fechaRep = value;
                            });
                            if (kDebugMode) {
                              print(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DateTimeFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            errorStyle: const TextStyle(color: Colors.redAccent),
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.event_note, size: 30),
                            labelText: 'Fecha de la etiqueta',
                            floatingLabelStyle: floatingLabelStyle,
                            contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 0),
                            isDense: true,
                          ),
                          dateTextStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          initialValue:
                              DateFormat('dd/M/yyyy', 'es').parse(articulo!.fechaEtiqueta!),
                          dateFormat: DateFormat('EE dd MMM yyyy hh:mm a', 'es'),
                          firstDate: DateTime.now().add(const Duration(days: -45)),
                          lastDate: DateTime.now().add(const Duration(days: 0)),
                          initialDate: DateTime.now().add(const Duration(days: 0)),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) =>
                              (e?.day ?? 0) == 1 ? 'Por favor no en el dia actual' : null,
                          onDateSelected: (DateTime value) {
                            setState(() {
                              // acta_fechaRep.text =
                              //     DateFormat('EEEE dd MMMM hh:mm a', 'es').format(value).toString();
                              // _acta_fechaRep = value;
                            });
                            if (kDebugMode) {
                              print(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /* floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: FloatingActionButton(
          onPressed: () async {
            setState(() {
              isDataLoad = false;
            });
            String barcode = await scanner.scan();
            // print(['barcode', barcode]);
            var uno = barcode.split("%3D");
            var key = uno[2].toString().replaceAll('%26', '');
            // print(['key', key]);
            FirebaseFirestore.instance
                .collectionGroup('articulos')
                .where('key', isEqualTo: key)
                .get()
                .then((QuerySnapshot q) {
              q.docs.forEach((doc) async {
                // print(doc.data());
                Articulo articuloScaned = Articulo.fromFirebase(doc.data());
                setState(() {
                  isDataLoad = true;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ArticuloPage(
                    akey: articuloScaned.key,
                    articulo: articuloScaned,
                    sede: articuloScaned.sede,
                    ubicacion: articuloScaned.ubicacion,
                    subUbicacion: articuloScaned.subUbicacion,
                    accion: 'editar',
                  );
                }));
              });
            });
          },
          backgroundColor: color4,
          child: Icon(
            articuloss.barcode,
            // Icons.qr_code_outlined,
            color: primario,
            size: 35,
          ),
        ),
      ), */
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      /* bottomNavigationBar: CustomBottomNavigationBar(
        iconList: [
          CustomBottomNavigationItem(
            isInvisible: true,
            icon: articuloss.drive_spreadsheet,
            onTap: () {
              print('drive_spreadsheet');
            },
          ),
          CustomBottomNavigationItem(
            isInvisible: true,
            icon: Icons.add_shopping_cart,
            onTap: () {
              print('add_shopping_cart');
            },
          ),
          CustomBottomNavigationItem(
            isInvisible: true,
            icon: Icons.save_alt,
            onTap: () {
              print('save_alt');
            },
          ),
          CustomBottomNavigationItem(
            isInvisible: false,
            icon: Icons.add_circle_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LocacionPage(
                      collectionPath: 'sedes',
                      locacion: 'sede',
                      accion: 'crear',
                    );
                  },
                ),
              ).then((value) => {getData(sedesCollection)});
            },
          ),
        ],
        onChange: (val) {},
        defaultSelectedIndex: 0,
        isDarkModeEnabled: false,
      ), */
    );
  }
}
