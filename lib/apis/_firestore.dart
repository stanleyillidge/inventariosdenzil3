import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../modelos/models.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference sedesCollection = FirebaseFirestore.instance.collection('sedes');
Map<dynamic, dynamic> _locaciones = {};

Future<List<Articulo>> getArticulos(CollectionReference collection) async {
  List<Articulo> array = [];
  var articulot = [];
  try {
    // articulos = 0;
    // print(['Internet Articulot', Articulot]);
    await collection.orderBy('nombre').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (kDebugMode) {
          // print(doc.data());
        }
        Articulo loc = Articulo.fromFirebase(doc.data() as Map<dynamic, dynamic>);
        if (kDebugMode) {
          // print(['loc', loc.toJson()]);
        }
        array.add(loc);
        articulot.add(loc.toJson());
      }
    });
    return array;
  } catch (e) {
    if (kDebugMode) {
      print(['Error getArticulos', e]);
    }
    return array;
  }
}

Future<List<Location>> getLocation(CollectionReference collection) async {
  List<Location> array = [];
  var locationst = [];
  try {
    // articulos = 0;
    // print(['Internet locationst', locationst]);
    await collection.orderBy('nombre').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (kDebugMode) {
          // print(doc.data());
        }
        Location loc = Location.fromFirebase(doc.data() as Map<dynamic, dynamic>);
        if (kDebugMode) {
          // print(['loc', loc.toJson()]);
        }
        array.add(loc);
        locationst.add(loc.toJson());
      }
    });
    return array;
  } catch (e) {
    if (kDebugMode) {
      print(['Error getLocation', e]);
    }
    return array;
  }
}

Future mapLocations() async {
  var loc = await storage.get('locaciones');
  // _sedes = sedes!.map((s) => s.nombre).toList();
  if (loc == null) {
    sedes = await getLocation(sedesCollection);
    List<String> sedesk = sedes!.map((s) => s.key).toList();
    for (var i = 0; i < sedes!.length; i++) {
      _locaciones[sedes![i].nombre] = sedes![i].toJson();
      _locaciones[sedes![i].nombre]['ubicaciones'] = {};
      List<String> ubisk = [];
      List<Location> ubis = ubicaciones!.where((u) => sedes![i].nombre == u.sede!.nombre).toList();
      if (ubis.isEmpty) {
        var collection =
            FirebaseFirestore.instance.collection('sedes').doc(sedesk[i]).collection('ubicaciones');
        ubicaciones!.addAll(await getLocation(collection));
      }
      ubis = ubicaciones!.where((u) => sedes![i].nombre == u.sede!.nombre).toList();
      ubisk =
          ubis.where((u) => sedes![i].nombre == u.sede!.nombre).toList().map((u) => u.key).toList();
      for (var j = 0; j < ubis.length; j++) {
        _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j].nombre] = ubis[j].toJson();
        _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j].nombre]['subUbicaciones'] = {};
        // _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j]] = [];
        List<Location> subis = subUbicaciones!
            .where((u) =>
                ((sedes![i].nombre == u.sede!.nombre) && (ubis[j].nombre == u.ubicacion!.nombre)))
            .toList();
        if (subis.isEmpty) {
          var collection = FirebaseFirestore.instance
              .collection('sedes')
              .doc(sedesk[i])
              .collection('ubicaciones')
              .doc(ubisk[j])
              .collection('subUbicaciones');
          subUbicaciones!.addAll(await getLocation(collection));
          subis = subUbicaciones!
              .where((u) =>
                  ((sedes![i].nombre == u.sede!.nombre) && (ubis[j].nombre == u.ubicacion!.nombre)))
              .toList();
        }
        for (var k = 0; k < subis.length; k++) {
          _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j].nombre]['subUbicaciones']
              [subis[k].nombre] = subis[k].toJson();
        }
        if (kDebugMode) {
          print([
            '_locaciones',
            sedes![i].nombre,
            'ubicaciones',
            _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j].nombre]['nombre'],
            'subUbicaciones',
            _locaciones[sedes![i].nombre]!['ubicaciones'][ubis[j].nombre]['subUbicaciones'].length
          ]);
        }
      }
    }
    await storage.put('locaciones', _locaciones);
    if (kDebugMode) {
      print(['_locaciones guardadas']);
    }
  } else {
    _locaciones = loc;
    if (kDebugMode) {
      print('_locaciones carga local');
    }
  }
}

  /* getSeriales() async {
    Query query = FirebaseFirestore.instance
        .collectionGroup('articulos')
        // .collectionGroup('inventario')
        .orderBy('nombre', descending: false);
    await query.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) async {
            if ((doc.data()['serial'] != '') &&
                (doc.data()['serial'] != null)) {
              await setSerial(doc);
            }
          })
        });
  } */

  /* setSerial(DocumentSnapshot doc) async {
    print(['Articulo con serial', doc.data()]);
    await FirebaseFirestore.instance
        .collection('seriales')
        .doc(doc.data()['serial'])
        .set({
      'sede': doc.data()['sede'],
      'ubicacion': doc.data()['ubicacion'],
      'subUbicacion': doc.data()['subUbicacion'],
    });
  } */