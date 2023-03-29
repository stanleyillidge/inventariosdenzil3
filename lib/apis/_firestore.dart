import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../modelos/models.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference sedesCollection = FirebaseFirestore.instance.collection('sedes');

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

Future<List<Locations>> getLocation(CollectionReference collection) async {
  List<Locations> array = [];
  var locationst = [];
  try {
    // articulos = 0;
    // print(['Internet locationst', locationst]);
    await collection.orderBy('nombre').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (kDebugMode) {
          // print(doc.data());
        }
        Locations loc = Locations.fromFirebase(doc.data() as Map<dynamic, dynamic>);
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