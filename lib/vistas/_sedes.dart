import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../apis/_firestore.dart';
import '../estilos.dart';
import '../modelos/_cards.dart';
import '../modelos/models.dart';
import '../widgets/contadores.dart';
import '_ubicaciones.dart';

class SedesPage extends StatefulWidget {
  const SedesPage({
    super.key,
  });

  @override
  State<SedesPage> createState() => SedesPageState();
}

class SedesPageState extends State<SedesPage> {
  final double _locationsCardsWidt = 350;

  init() async {
    // sedes = [];
    // ubicaciones = [];
    // subUbicaciones = [];
    sedes ??= [];
    sedes!.addAll(await getLocation(sedesCollection));
    setState(() {
      sedes = sedes;
      isDataLoad = true;
    });
    // await storage.put('sedes', sedes);
    contadorSedesBarkey.currentState!.getContadores(sedes);
    // await mapLocations();
  }

  @override
  void initState() {
    isDataLoad = false;
    // getSeriales();
    super.initState();
    init();
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
    double width = (size.width > _locationsCardsWidt) ? size.width - 15 : _locationsCardsWidt;
    appBarTitleWidth = (size.width > size.width * 0.75) ? size.width * 0.75 : size.width - 15;
    return Scaffold(
      key: scaffoldSedesPagekey,
      extendBody: true,
      appBar: appBarInst('Inventario general', 15, appBarTitleWidth),
      body: Scaffold(
        key: scaffoldSedesPageBody,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: (isDarkModeEnabled) ? primario.withOpacity(0.98) : Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: toolbarHeight,
          title: (size.width < size.height)
              ? Center(
                  child: ContadorBar(
                    key: contadorSedesBarkey,
                    locations: (sedes != null) ? sedes! : null,
                    widthT: width,
                    isAppBar: true,
                    offset: 5,
                  ),
                )
              : ContadorBar(
                  key: contadorSedesBarkey,
                  locations: (sedes != null) ? sedes! : null,
                  widthT: width,
                  isAppBar: true,
                  offset: 5,
                ),
        ),
        body: (isDataLoad)
            ? Container(
                color: (isDarkModeEnabled) ? primario.withOpacity(0.98) : Colors.white,
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.98,
                    // height: size.height * 0.7,
                    child: WaterfallFlow.builder(
                      padding: const EdgeInsets.only(bottom: 70, left: 5, right: 5, top: 10),
                      gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ((size.width ~/ _locationsCardsWidt) <= 0)
                            ? 1
                            : (size.width ~/ _locationsCardsWidt),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (BuildContext c, int index) {
                        return LocationCard(
                          width: width,
                          index: index,
                          locations: sedes!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UbicacionesPage(
                                    locationCollection: FirebaseFirestore.instance
                                        .collection('sedes')
                                        .doc(sedes![index].sede!.key)
                                        .collection('ubicaciones'),
                                    title: sedes![index].nombre,
                                    sedeIndex: index,
                                  );
                                },
                              ),
                            );
                          },
                        );
                        /* return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UbicacionesPage(
                                    locationCollection: FirebaseFirestore.instance
                                        .collection('sedes')
                                        .doc(sedes![index].sede!.key)
                                        .collection('ubicaciones'),
                                    title: sedes![index].nombre,
                                    sedeIndex: index,
                                  );
                                },
                              ),
                            ); //.then((value) => {getData(sedesCollection)});
                          },
                          child: Card(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width * 0.9,
                                    height: 100,
                                    child: Center(
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
                                        child: (sedes![index].imagen!.contains('shapes'))
                                            ? Image.asset(
                                                'assets/shapes.png',
                                                width: width * 0.9,
                                                height: 100,
                                              )
                                            : Image(
                                                image: NetworkImage(sedes![index].imagen!),
                                                width: width * 0.9,
                                                height: 100,
                                              ),
                                        // const Placeholder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.825,
                                    height: 25,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.825,
                                          // height: 25,
                                          child: Text(
                                            // 'Sede de nombre muy largo y largo y largo y largo y largo y largo',
                                            '${sedes![index].location.capitalize()} - ${sedes![index].nombre}',
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ContadorBar(
                                    key: Key('sede$index'),
                                    locations: sedes!,
                                    background: Colors.white,
                                    widthT: width * 0.75,
                                    offset: 0,
                                    isAppBar: false,
                                    index: index,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ); */
                      },
                      itemCount: sedes!.length,
                    ),
                  ),
                ),
              )
            : LinearProgressIndicator(
                color: primario,
                backgroundColor: primario,
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
                  Inventarios.barcode,
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
                  icon: Inventarios.drive_spreadsheet,
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
