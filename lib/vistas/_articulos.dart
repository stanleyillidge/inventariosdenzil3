import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../apis/_firestore.dart';
import '../estilos.dart';
import '../modelos/models.dart';
import '../widgets/contadores.dart';
import '_view_articulo.dart';

class ArticulosPage extends StatefulWidget {
  final CollectionReference locationCollection;
  final String title;
  final int sedeIndex;
  final int ubicacionIndex;
  final int subUbicacionIndex;
  final int inventarioIndex;
  const ArticulosPage({
    super.key,
    required this.title,
    required this.locationCollection,
    required this.sedeIndex,
    required this.ubicacionIndex,
    required this.subUbicacionIndex,
    required this.inventarioIndex,
  });

  @override
  State<ArticulosPage> createState() => ArticulosPageState();
}

class ArticulosPageState extends State<ArticulosPage> {
  final double _locationsCardsWidt = 350;
  String subtitulo = '';
  String titulo = '';

  init() async {
    articulos = await getArticulos(widget.locationCollection);
    setState(() {
      articulos = articulos;
      isDataLoad = true;
    });
  }

  @override
  void initState() {
    titulo = 'Sede ${sedes![widget.sedeIndex].nombre}';
    subtitulo =
        '${ubicaciones![widget.ubicacionIndex].nombre} - ${subUbicaciones![widget.subUbicacionIndex].nombre}';
    isDataLoad = false;
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
    double width = (size.width > _locationsCardsWidt) ? size.width - 15 : _locationsCardsWidt;
    appBarTitleWidth = (size.width > size.width * 0.7) ? size.width * 0.7 : size.width - 15;
    return Scaffold(
      key: scaffoldArticulosPagekey,
      extendBody: true,
      appBar: appBarInst(
        titulo,
        0,
        appBarTitleWidth,
        subtitulo,
        ((articulos != null) ? articulos![0].nombre! : ''),
      ),
      body: Scaffold(
        key: scaffoldArticulosPageBody,
        extendBody: true,
        appBar: AppBar(
          key: const Key('ArticulosPageAppBar'),
          elevation: 0,
          backgroundColor: (isDarkModeEnabled) ? primario.withOpacity(0.98) : Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: toolbarHeight,
          title: (size.width < size.height)
              ? Center(
                  child: ContadorBar(
                    key: contadorArticulosBarkey,
                    locations: [inventario![widget.inventarioIndex]],
                    widthT: _locationsCardsWidt,
                    isAppBar: true,
                    offset: 5,
                  ),
                )
              : ContadorBar(
                  key: contadorArticulosBarkey,
                  locations: [inventario![widget.inventarioIndex]],
                  widthT: _locationsCardsWidt,
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
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ViewArticuloPage(
                                    locationCollection: FirebaseFirestore.instance
                                        .collection('sedes')
                                        .doc(sedes![widget.sedeIndex].sede!.key)
                                        .collection('ubicaciones')
                                        .doc(ubicaciones![widget.ubicacionIndex].ubicacion!.key)
                                        .collection('subUbicaciones')
                                        .doc(subUbicaciones![widget.subUbicacionIndex]
                                            .subUbicacion!
                                            .key)
                                        .collection('inventario')
                                        .doc(inventario![widget.inventarioIndex].key)
                                        .collection('articulos'),
                                    title: articulos![index].nombre!,
                                    sedeIndex: widget.sedeIndex,
                                    ubicacionIndex: widget.ubicacionIndex,
                                    subUbicacionIndex: widget.subUbicacionIndex,
                                    inventarioIndex: widget.inventarioIndex,
                                    articuloIndex: index,
                                  );
                                },
                              ),
                            );
                          },
                          child: Card(
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
                                      child: (articulos![index].imagen != null)
                                          ? (articulos![index].imagen!.contains('shapes'))
                                              ? Image.asset(
                                                  'assets/shapes.png',
                                                  width: width * 0.9,
                                                  height: 100,
                                                )
                                              : Image(
                                                  image: NetworkImage(articulos![index].imagen!),
                                                  width: width * 0.9,
                                                  height: 100,
                                                )
                                          : Image.asset(
                                              'assets/shapes.png',
                                              width: width * 0.9,
                                              height: 100,
                                            ),
                                      // const Placeholder(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.9,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: width * 0.75,
                                          child: Text(
                                            articulos![index].nombre!,
                                            softWrap: true,
                                            // overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.bold,
                                              // fontSize: 16,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.15,
                                        height: 50,
                                        child: Card(
                                          color: getColor(articulos![index].estado!),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                articulos![index].estado![0].toUpperCase(),
                                                style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  decoration: TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: articulos!.length,
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
