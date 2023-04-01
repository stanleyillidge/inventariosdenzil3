import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../estilos.dart';
import '../widgets/contadores.dart';
import '_field.dart';

DateTime inicio_ano_lectivo = DateFormat('dd/MM/yyyy', 'es').parse('06/02/2023');

String institucionEducativa = "Institución Educativa Denzil Escolar";

final GlobalKey<ScaffoldState> scaffoldSedesPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldSedesPageBody = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldUbicacionesPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldUbicacionesPageBody = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldSubUbicacionesPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldSubUbicacionesPageBody = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldInventarioPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldInventarioPageBody = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldArticulosPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldArticulosPageBody = GlobalKey();

final GlobalKey<ScaffoldState> scaffoldViewArticuloPagekey = GlobalKey();
final GlobalKey<ScaffoldState> scaffoldViewArticuloPageBody = GlobalKey();

final GlobalKey<ContadorBarState> contadorSedesBarkey = GlobalKey();
final GlobalKey<ContadorBarState> contadorUbicacionesBarkey = GlobalKey();
final GlobalKey<ContadorBarState> contadorSubUbicacionesBarkey = GlobalKey();
final GlobalKey<ContadorBarState> contadorInventarioBarkey = GlobalKey();
final GlobalKey<ContadorBarState> contadorArticulosBarkey = GlobalKey();
final GlobalKey<ContadorBarState> contadorViewArticuloBarkey = GlobalKey();

bool isDarkModeEnabled = false;
bool? login = false;
bool isDataLoad = true;

double appBarTitleWidth = 300;

List<Location>? locations;
List<Location>? sedes;
List<Location>? ubicaciones;
List<Location>? subUbicaciones;
List<Location>? inventario;
List<Articulo>? articulos;

var storage;
PackageInfo? packageInfo;
var loginState;
var accessToken;
GoogleUser? googleUser;
dynamic googleAuthStorage;
GoogleSignInAuthentication? googleAuth;
GoogleSignInAccount? googleSignInAccount;
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    "https://mail.google.com/",
    "https://www.googleapis.com/auth/gmail.send",
    "https://www.googleapis.com/auth/gmail.modify",
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/gmail.metadata",
    "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/documents",
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/presentations",
    "https://www.googleapis.com/auth/contacts",
    "https://www.googleapis.com/auth/contacts.readonly",
    "https://www.googleapis.com/auth/directory.readonly",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/classroom.coursework.students",
    "https://www.googleapis.com/auth/classroom.courses",
    "https://www.googleapis.com/auth/classroom.announcements",
    "https://www.googleapis.com/auth/classroom.rosters",
    "https://www.googleapis.com/auth/classroom.profile.emails",
    "https://www.googleapis.com/auth/classroom.profile.photos",
    "https://www.googleapis.com/auth/firebase",
    "https://www.googleapis.com/auth/datastore",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ],
  hostedDomain: "denzilescolar.edu.co",
);

// --- Hive -----------------------

Future initializeHive() async {
  if (kIsWeb) {
    /* print([
      login,
      'Flutter Web persistence 00',
      // FirebaseFirestore.instance.settings,
      googleUser?.name?.fullName,
      asignaciones.length
    ]); */
    // print(["Flutter Web"]);
    // print('Hive web is ok');
  } else if (Platform.isAndroid) {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      // print('Hive Android is ok');
    } catch (e) {
      if (kDebugMode) {
        print(['Error inicializando Hive Android', e]);
      }
    }
  }
  try {
    storage = await Hive.openBox('storage');
    loginState = await Hive.openBox('loginState');
    googleAuthStorage = await Hive.openBox('googleAuthStorage');
  } catch (e) {
    if (kDebugMode) {
      print(['Error en main', e]);
    }
  }
}

Future getPackageInfo() async {
  packageInfo = await PackageInfo.fromPlatform();
}

// --- Usuario de Google ----------
class GoogleUser {
  String? kind;
  String? id;
  String? etag;
  String? primaryEmail;
  Name? name;
  bool? isAdmin;
  bool? isDelegatedAdmin;
  String? lastLoginTime;
  String? creationTime;
  bool? agreedToTerms;
  bool? suspended;
  bool? archived;
  bool? changePasswordAtNextLogin;
  bool? ipWhitelisted;
  List<Emails>? emails;
  List<Organizations>? organizations;
  List<String>? nonEditableAliases;
  String? customerId;
  String? orgUnitPath;
  bool? isMailboxSetup;
  bool? isEnrolledIn2Sv;
  bool? isEnforcedIn2Sv;
  bool? includeInGlobalAddressList;
  bool? selected;
  String? thumbnailPhotoUrl;
  String? thumbnailPhotoEtag;

  GoogleUser({
    this.kind,
    this.id,
    this.etag,
    this.primaryEmail,
    this.name,
    this.isAdmin,
    this.isDelegatedAdmin,
    this.lastLoginTime,
    this.creationTime,
    this.agreedToTerms,
    this.suspended,
    this.archived,
    this.changePasswordAtNextLogin,
    this.ipWhitelisted,
    this.emails,
    this.organizations,
    this.nonEditableAliases,
    this.customerId,
    this.orgUnitPath,
    this.isMailboxSetup,
    this.isEnrolledIn2Sv,
    this.isEnforcedIn2Sv,
    this.includeInGlobalAddressList,
    this.selected,
    this.thumbnailPhotoUrl,
    this.thumbnailPhotoEtag,
  });

  GoogleUser.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    id = json['id'];
    etag = json['etag'];
    primaryEmail = json['primaryEmail'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    isAdmin = json['isAdmin'];
    isDelegatedAdmin = json['isDelegatedAdmin'];
    lastLoginTime = json['lastLoginTime'];
    creationTime = json['creationTime'];
    agreedToTerms = json['agreedToTerms'];
    suspended = json['suspended'];
    archived = json['archived'];
    changePasswordAtNextLogin = json['changePasswordAtNextLogin'];
    ipWhitelisted = json['ipWhitelisted'];
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add(Emails.fromJson(v));
      });
    }
    if (json['organizations'] != null) {
      organizations = <Organizations>[];
      json['organizations'].forEach((v) {
        organizations!.add(Organizations.fromJson(v));
      });
    }
    nonEditableAliases = json['nonEditableAliases'].cast<String>();
    customerId = json['customerId'];
    orgUnitPath = json['orgUnitPath'];
    isMailboxSetup = json['isMailboxSetup'];
    isEnrolledIn2Sv = json['isEnrolledIn2Sv'];
    isEnforcedIn2Sv = json['isEnforcedIn2Sv'];
    includeInGlobalAddressList = json['includeInGlobalAddressList'];
    selected = false;
    thumbnailPhotoUrl = json['thumbnailPhotoUrl'];
    thumbnailPhotoEtag = json['thumbnailPhotoEtag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['id'] = id;
    data['etag'] = etag;
    data['primaryEmail'] = primaryEmail;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    data['isAdmin'] = isAdmin;
    data['isDelegatedAdmin'] = isDelegatedAdmin;
    data['lastLoginTime'] = lastLoginTime;
    data['creationTime'] = creationTime;
    data['agreedToTerms'] = agreedToTerms;
    data['suspended'] = suspended;
    data['archived'] = archived;
    data['changePasswordAtNextLogin'] = changePasswordAtNextLogin;
    data['ipWhitelisted'] = ipWhitelisted;
    if (emails != null) {
      data['emails'] = emails!.map((v) => v.toJson()).toList();
    }
    if (organizations != null) {
      data['organizations'] = organizations!.map((v) => v.toJson()).toList();
    }
    data['nonEditableAliases'] = nonEditableAliases;
    data['customerId'] = customerId;
    data['orgUnitPath'] = orgUnitPath;
    data['isMailboxSetup'] = isMailboxSetup;
    data['isEnrolledIn2Sv'] = isEnrolledIn2Sv;
    data['isEnforcedIn2Sv'] = isEnforcedIn2Sv;
    data['includeInGlobalAddressList'] = includeInGlobalAddressList;
    data['selected'] = selected;
    data['thumbnailPhotoUrl'] = thumbnailPhotoUrl;
    data['thumbnailPhotoEtag'] = thumbnailPhotoEtag;
    return data;
  }
}

class Name {
  String? givenName;
  String? familyName;
  String? fullName;

  Name({this.givenName, this.familyName, this.fullName});

  Name.fromJson(Map<dynamic, dynamic> json) {
    givenName = (json['givenName'] != null) ? json['givenName'] : null;
    familyName = (json['familyName'] != null) ? json['familyName'] : null;
    fullName = (json['fullName'] != null) ? json['fullName'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (givenName != null) {
      data['givenName'] = givenName.toString();
    }
    if (familyName != null) {
      data['familyName'] = familyName.toString();
    }
    if (fullName != null) {
      data['fullName'] = fullName.toString();
    }
    return data;
  }
}

class Emails {
  String? address;
  bool? primary;

  Emails({this.address, this.primary});

  Emails.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['primary'] = primary;
    return data;
  }
}

class Organizations {
  String? title;
  bool? primary;
  String? customType;
  String? description;

  Organizations({this.title, this.primary, this.customType, this.description});

  Organizations.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    primary = json['primary'];
    customType = json['customType'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['primary'] = primary;
    data['customType'] = customType;
    data['description'] = description;
    return data;
  }
}

class Profile {
  String? id;
  Name? name;
  String? emailAddress;
  String? photoUrl;
  List? permissions;
  bool? verifiedTeacher;

  Profile({
    this.id,
    this.name,
    this.emailAddress,
    this.photoUrl,
    this.permissions,
    this.verifiedTeacher,
  });

  factory Profile.fromClassroom(Map<dynamic, dynamic> json) {
    Profile? a;
    // print(json);
    try {
      a = Profile(
        id: json['id'],
        name: Name.fromJson(json['name']),
        emailAddress: json['emailAddress'],
        photoUrl: json['photoUrl'],
        permissions: json['permissions'],
        verifiedTeacher: (json['verifiedTeacher'] != null) ? json['verifiedTeacher'] : false,
      );
    } catch (e) {
      if (kDebugMode) {
        print(['Error en modelo de Profile.fromClassroom', e, json]);
      }
    }
    return a!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // Map<String, dynamic>? name = this.name != null ? this.name!.toJson() : {};
    if (id != null) {
      data['id'] = id;
    }
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (emailAddress != null) {
      data['emailAddress'] = emailAddress;
    }
    if (photoUrl != null) {
      data['photoUrl'] = photoUrl;
    }
    if (permissions != null) {
      data['permissions'] = permissions;
    }
    if (verifiedTeacher != null) {
      data['verifiedTeacher'] = verifiedTeacher;
    }
    return data;
    /* return {
      'id': id,
      'name': name,
      'emailAddress': emailAddress,
      'photoUrl': photoUrl,
      'permissions': permissions,
      'verifiedTeacher': verifiedTeacher,
    }; */
  }

  dynamic get(String propertyName) {
    var mapRep = toJson();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}
// ----------------------------------

class Modificacion {
  String? key;
  DateTime? fecha;
  dynamic data;
}

class Referencia {
  String? key;
  String? nombre;
  Referencia({
    required this.key,
    required this.nombre,
  });
  factory Referencia.fromFirebase(Map<dynamic, dynamic> json) {
    return Referencia(key: json['key'], nombre: json['nombre']);
  }
  factory Referencia.fromHive(Map<dynamic, dynamic> json) {
    return Referencia(key: json['key'], nombre: json['nombre']);
  }
  Map toJson() {
    return {
      'key': key,
      'nombre': nombre,
    };
  }
}

class ArticuloUnico {
  String key;
  String nombre;
  String tipo;
  ArticuloUnico({
    required this.key,
    required this.nombre,
    required this.tipo,
  });
  factory ArticuloUnico.fromFirebase(Map<dynamic, dynamic> json) {
    return ArticuloUnico(
      key: json['key'],
      nombre: json['nombre'],
      tipo: json['tipo'],
    );
  }
  Map toJson() {
    return {
      'key': key,
      'nombre': nombre,
      'tipo': tipo,
    };
  }
}

class CustomBottomNavigationItem {
  IconData icon;
  Function onTap;
  bool isInvisible;
  CustomBottomNavigationItem({
    required this.icon,
    required this.onTap,
    required this.isInvisible,
  });
  factory CustomBottomNavigationItem.fromFirebase(Map<dynamic, dynamic> json) {
    return CustomBottomNavigationItem(
      icon: json['icon'],
      onTap: json['onTap'],
      isInvisible: json['isInvisible'],
    );
  }
  Map toJson() {
    return {
      'icon': icon,
      'onTap': onTap,
      'isInvisible': isInvisible,
    };
  }
}

class Location {
  late String location;
  Referencia? sede;
  Referencia? ubicacion;
  Referencia? subUbicacion;
  late String key;
  late String nombre;
  late int cantidad;
  String? descripcion;
  String? imagen;
  dynamic file;
  Modificacion? modificacion;
  late int buenos;
  late int malos;
  late int regulares;
  late String error;

  Location({
    required this.location,
    required this.sede,
    required this.ubicacion,
    required this.subUbicacion,
    required this.key,
    required this.nombre,
    required this.cantidad,
    this.descripcion,
    this.imagen,
    this.file,
    this.modificacion,
    required this.buenos,
    required this.malos,
    required this.regulares,
  });

  Location.fromFirebase(Map<dynamic, dynamic> json) {
    location = getLocationst(json, 'location');
    sede = getLocationst(json, 'sede');
    ubicacion = getLocationst(json, 'ubicacion');
    subUbicacion = getLocationst(json, 'subUbicacion');
    key = json['key'];
    nombre = json['nombre'];
    cantidad = (json['cantidad'] != null) ? json['cantidad'] : 0;
    descripcion = json['descripcion'];
    imagen = json['imagen'];
    file = json['file'];
    modificacion = json['modificacion'];
    buenos = (json['Buenos'] != null)
        ? json['Buenos']
        : (json['Bueno'] != null)
            ? json['Bueno']
            : 0;
    malos = (json['Malos'] != null)
        ? json['Malos']
        : (json['Malo'] != null)
            ? json['Malo']
            : 0;
    regulares = (json['Regulares'] != null)
        ? json['Regulares']
        : (json['Regular'] != null)
            ? json['Regular']
            : 0;
  }
  Location.fromHive(Map<dynamic, dynamic> json) {
    location = getLocationst(json, 'location');
    sede = getLocationst(json, 'sede');
    ubicacion = getLocationst(json, 'ubicacion');
    subUbicacion = getLocationst(json, 'subUbicacion');
    key = json['key'];
    nombre = json['nombre'];
    cantidad = (json['cantidad'] != null) ? json['cantidad'] : 0;
    descripcion = json['descripcion'];
    imagen = json['imagen'];
    file = json['file'];
    modificacion = json['modificacion'];
    buenos = (json['Buenos'] != null)
        ? json['Buenos']
        : (json['Bueno'] != null)
            ? json['Bueno']
            : 0;
    malos = (json['Malos'] != null)
        ? json['Malos']
        : (json['Malo'] != null)
            ? json['Malo']
            : 0;
    regulares = (json['Regulares'] != null)
        ? json['Regulares']
        : (json['Regular'] != null)
            ? json['Regular']
            : 0;
  }
  factory Location.fromLocal(Map<dynamic, dynamic> json) {
    return Location(
      location: json['location'],
      sede: (json['sede'] != null)
          ? Referencia(key: json['sede']['key'], nombre: json['sede']['nombre'])
          : null,
      ubicacion: (json['ubicacion'] != null)
          ? Referencia(key: json['ubicacion']['key'], nombre: json['ubicacion']['nombre'])
          : null,
      subUbicacion: (json['subUbicacion'] != null)
          ? Referencia(key: json['subUbicacion']['key'], nombre: json['subUbicacion']['nombre'])
          : null,
      key: json['key'],
      nombre: json['nombre'],
      cantidad: (json['cantidad'] != null) ? json['cantidad'] : 0,
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      file: json['file'],
      modificacion: json['modificacion'],
      buenos: (json['buenos'] != null) ? json['buenos'] : 0,
      malos: (json['malos'] != null) ? json['malos'] : 0,
      regulares: (json['regulares'] != null) ? json['regulares'] : 0,
    );
  }
  Map toJson() {
    return {
      'location': location,
      'sede': (sede != null) ? sede!.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion!.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion!.toJson() : null,
      'key': key,
      'nombre': nombre,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'imagen': imagen,
      'file': file,
      'modificacion': modificacion,
      'buenos': buenos,
      'malos': malos,
      'regulares': regulares,
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    /* print({
      'location': location,
      'sede': (sede != null) ? sede.key : null,
      'sedeNombre': (sede != null) ? sede.nombre : null,
      'ubicacion': (ubicacion != null) ? ubicacion.key : null,
      'ubicacionNombre': (ubicacion != null) ? ubicacion.nombre : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion.key : null,
      'subUbicacionNombre': (subUbicacion != null) ? subUbicacion.nombre : null,
      'key': key,
      'nombre': nombre,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'imagen': imagen,
      'Buenos': buenos,
      'Malos': malos,
      'Regulares': regulares,
    }); */
    if (location == 'sede') {
      return {
        'location': location,
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'imagen': imagen,
        'Buenos': buenos,
        'Malos': malos,
        'Regulares': regulares,
      };
    } else if (location == 'ubicacion') {
      return {
        'location': location,
        'sede': (sede != null) ? sede!.key : null,
        'sedeNombre': (sede != null) ? sede!.nombre : null,
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'imagen': imagen,
        'Buenos': buenos,
        'Malos': malos,
        'Regulares': regulares,
      };
    } else if (location == 'subUbicacion') {
      return {
        'location': location,
        'sede': (sede != null) ? sede!.key : null,
        'sedeNombre': (sede != null) ? sede!.nombre : null,
        'ubicacion': (ubicacion != null) ? ubicacion!.key : null,
        'ubicacionNombre': (ubicacion != null) ? ubicacion!.nombre : null,
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'imagen': imagen,
        'Buenos': buenos,
        'Malos': malos,
        'Regulares': regulares,
      };
    } else if (location == 'inventario') {
      return {
        'location': location,
        'sede': (sede != null) ? sede!.key : null,
        'sedeNombre': (sede != null) ? sede!.nombre : null,
        'ubicacion': (ubicacion != null) ? ubicacion!.key : null,
        'ubicacionNombre': (ubicacion != null) ? ubicacion!.nombre : null,
        'subUbicacion': (subUbicacion != null) ? subUbicacion!.key : null,
        'subUbicacionNombre': (subUbicacion != null) ? subUbicacion!.nombre : null,
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'imagen': imagen,
        'Buenos': buenos,
        'Malos': malos,
        'Regulares': regulares,
      };
    }
    return {error: 'Error en el modelo'};
  }
}

class Articulo {
  int? cantidad;
  String? tipo;
  String? fechaModif;
  String? fechaBaja;
  String? articulo;
  String? creacion;
  String? descripcion;
  String? disponibilidad;
  String? estado;
  String? etiqueta;
  String? etiquetaId;
  String? fechaEtiqueta;
  String? file;
  String? imagen;
  String? key;
  String? modificaciones;
  String? nombre;
  String? observaciones;
  String? serie;
  Referencia? sede;
  Referencia? ubicacion;
  Referencia? subUbicacion;
  String? fsede;
  String? fubicacion;
  String? fsubUbicacion;
  String? sedeNombre;
  String? ubicacionNombre;
  String? subUbicacionNombre;
  int? valor;

  Articulo({
    this.articulo,
    this.cantidad,
    this.creacion,
    this.descripcion,
    this.disponibilidad,
    this.estado,
    this.etiqueta,
    this.etiquetaId,
    this.fechaEtiqueta,
    this.fechaModif,
    this.fechaBaja,
    this.file,
    this.imagen,
    this.key,
    this.modificaciones,
    this.nombre,
    this.observaciones,
    this.serie,
    this.sede,
    this.ubicacion,
    this.subUbicacion,
    this.fsede,
    this.fubicacion,
    this.fsubUbicacion,
    this.sedeNombre,
    this.ubicacionNombre,
    this.subUbicacionNombre,
    this.valor,
    this.tipo,
  });

  factory Articulo.fromFirebase(Map<dynamic, dynamic> json) {
    return Articulo(
      sede: getLocationst(json, 'sede'),
      ubicacion: getLocationst(json, 'ubicacion'),
      subUbicacion: getLocationst(json, 'subUbicacion'),
      articulo: json['articulo'],
      cantidad: json['cantidad'],
      creacion: json['creacion'],
      descripcion: json['descripcion'],
      disponibilidad: json['disponibilidad'],
      estado: json['estado'],
      etiqueta: json['etiqueta'],
      etiquetaId: json['etiquetaId'],
      fechaEtiqueta: json['fechaEtiqueta'],
      fechaModif: json['fechaModif'],
      fechaBaja: json['fechaBaja'],
      file: json['file'],
      imagen: json['imagen'],
      key: json['key'],
      modificaciones: json['modificaciones'],
      nombre: json['nombre'],
      observaciones: json['observaciones'],
      valor: (json['valor'] is int) ? json['valor'] : 0,
      serie: json['serie'],
      tipo: json['tipo'],
    );
  }

  factory Articulo.fromLocal(Map<dynamic, dynamic> json) {
    return Articulo(
      sede: getLocationst(json, 'sede'),
      ubicacion: getLocationst(json, 'ubicacion'),
      subUbicacion: getLocationst(json, 'subUbicacion'),
      articulo: (json['articulo'] != null) ? json['articulo'] : '',
      cantidad: (json['cantidad'] != null) ? json['cantidad'] : 1,
      creacion: (json['creacion'] != null) ? json['creacion'] : DateTime.now().toLocal().toString(),
      descripcion: (json['descripcion'] != null) ? json['descripcion'] : '',
      disponibilidad: (json['disponibilidad'] != null) ? json['disponibilidad'] : 'Si',
      estado: (json['estado'] != null) ? json['estado'] : 'Bueno',
      etiqueta: (json['etiqueta'] != null) ? json['etiqueta'] : '',
      etiquetaId: (json['etiquetaId'] != null) ? json['etiquetaId'] : '',
      fechaEtiqueta: (json['fechaEtiqueta'] != null) ? json['fechaEtiqueta'] : '',
      fechaModif: (json['fechaModif'] != null) ? json['fechaModif'] : '',
      fechaBaja: (json['fechaBaja'] != null) ? json['fechaBaja'] : '',
      file: (json['file'] != null) ? json['file'] : '',
      imagen: (json['imagen'] != null) ? json['imagen'] : 'assets/shapes2.svg',
      key: (json['key'] != null) ? json['key'] : '',
      modificaciones: (json['modificaciones'] != null) ? json['modificaciones'] : '',
      nombre: (json['nombre'] != null) ? json['nombre'] : '',
      observaciones: (json['observaciones'] != null) ? json['observaciones'] : '',
      serie: (json['serie'] != null) ? json['serie'] : '',
      tipo: (json['tipo'] != null) ? json['tipo'] : '',
      valor: (json['valor'] is int) ? json['valor'] : 0,
    );
  }

  factory Articulo.toFirebase(Map<dynamic, dynamic> json) {
    return Articulo(
      fsede: (json['sede'] != null) ? json['sede'].key : '',
      fubicacion: (json['ubicacion'] != null) ? json['ubicacion'].key : '',
      fsubUbicacion: (json['subUbicacion'] != null) ? json['subUbicacion'].key : '',
      sedeNombre: (json['sede'] != null) ? json['sede'].nombre : '',
      ubicacionNombre: (json['ubicacion'] != null) ? json['ubicacion'].nombre : '',
      subUbicacionNombre: (json['subUbicacion'] != null) ? json['subUbicacion'].nombre : '',
      articulo: (json['articulo'] != null) ? json['articulo'] : '',
      cantidad: (json['cantidad'] != null) ? json['cantidad'] : 1,
      creacion: (json['creacion'] != null) ? json['creacion'] : DateTime.now().toLocal().toString(),
      descripcion: (json['descripcion'] != null) ? json['descripcion'] : '',
      disponibilidad: (json['disponibilidad'] != null) ? json['disponibilidad'] : 'Si',
      estado: (json['estado'] != null) ? json['estado'] : 'Bueno',
      etiqueta: (json['etiqueta'] != null) ? json['etiqueta'] : '',
      etiquetaId: (json['etiquetaId'] != null) ? json['etiquetaId'] : '',
      fechaEtiqueta: (json['fechaEtiqueta'] != null) ? json['fechaEtiqueta'] : '',
      fechaModif: (json['fechaModif'] != null) ? json['fechaModif'] : '',
      fechaBaja: (json['fechaBaja'] != null) ? json['fechaBaja'] : '',
      file: (json['file'] != null) ? json['file'] : '',
      imagen: (json['imagen'] != null) ? json['imagen'] : '/assets/shapes.svg',
      key: (json['key'] != null) ? json['key'] : '',
      modificaciones: (json['modificaciones'] != null) ? json['modificaciones'] : '',
      nombre: (json['nombre'] != null) ? json['nombre'] : '',
      observaciones: (json['observaciones'] != null) ? json['observaciones'] : '',
      serie: (json['serie'] != null) ? json['serie'] : '',
      tipo: (json['tipo'] != null) ? json['tipo'] : '',
      valor: (json['valor'] is int) ? json['valor'] : 0,
    );
  }

  Map toJson() {
    return {
      'sede': (sede != null) ? sede!.toJson() : null,
      'ubicacion': (ubicacion != null) ? ubicacion!.toJson() : null,
      'subUbicacion': (subUbicacion != null) ? subUbicacion!.toJson() : null,
      'articulo': articulo,
      'cantidad': cantidad,
      'creacion': creacion,
      'descripcion': descripcion,
      'disponibilidad': disponibilidad,
      'estado': estado,
      'etiqueta': etiqueta,
      'etiquetaId': etiquetaId,
      'fechaEtiqueta': fechaEtiqueta,
      'fechaModif': fechaModif,
      'fechaBaja': fechaBaja,
      'file': file,
      'imagen': imagen,
      'key': key,
      'modificaciones': modificaciones,
      'nombre': nombre,
      'observaciones': observaciones,
      'valor': valor,
      'serie': serie,
      'tipo': tipo,
    };
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'sede': (fsede != null) ? fsede : '',
      'sedeNombre': (sedeNombre != null) ? sedeNombre : '',
      'ubicacion': (fubicacion != null) ? fubicacion : '',
      'ubicacionNombre': (ubicacionNombre != null) ? ubicacionNombre : '',
      'subUbicacion': (fsubUbicacion != null) ? fsubUbicacion : '',
      'subUbicacionNombre': (subUbicacionNombre != null) ? subUbicacionNombre : '',
      'articulo': (articulo != null) ? articulo : '',
      'cantidad': (cantidad != null) ? cantidad : 1,
      'creacion': (creacion != null) ? creacion : '',
      'descripcion': (descripcion != null) ? descripcion : '',
      'disponibilidad': (disponibilidad != null) ? disponibilidad : '',
      'estado': (estado != null) ? estado : '',
      'etiqueta': (etiqueta != null) ? etiqueta : '',
      'etiquetaId': (etiquetaId != null) ? etiquetaId : '',
      'fechaEtiqueta': (fechaEtiqueta != null) ? fechaEtiqueta : '',
      'fechaModif': (fechaModif != null) ? fechaModif : '',
      'fechaBaja': (fechaBaja != null) ? fechaBaja : '',
      'file': (file != null) ? file : '',
      'imagen': (imagen != null) ? imagen : '',
      'key': (key != null) ? key : '',
      'modificaciones': (modificaciones != null) ? modificaciones : '',
      'nombre': (nombre != null) ? nombre : '',
      'observaciones': (observaciones != null) ? observaciones : '',
      'valor': (valor != null) ? valor : 0,
      'serie': (serie != null) ? serie : '',
      'tipo': (tipo != null) ? tipo : '',
    };
  }
}

class Resumen {
  String? key;
  String? nombre;
  int? cantidad;
  int? buenos;
  int? malos;
  int? regulares;
  List<Articulo>? articulos;

  Resumen({
    this.key,
    this.nombre,
    this.cantidad,
    this.buenos,
    this.malos,
    this.regulares,
    this.articulos,
  });
  factory Resumen.fromFirebase(Map<dynamic, dynamic> json) {
    return Resumen(
      key: json['key'],
      nombre: json['nombre'],
      cantidad: json['cantidad'],
      buenos: json['buenos'],
      malos: json['malos'],
      regulares: json['regulares'],
    );
  }
  Map toJson() => {
        'key': key,
        'nombre': nombre,
        'cantidad': cantidad,
        'buenos': buenos,
        'malos': malos,
        'regulares': regulares,
      };
}

class Locations {
  Location? location;
  List<Location>? locations;
}

extension StringExtension on String {
  String capitalize() {
    String s = '';
    String xx = trim();
    List<String> listaxx = xx.toLowerCase().split(' ');
    for (var i = 0; i < listaxx.length; i++) {
      if (listaxx[i].isNotEmpty) {
        s += (i < listaxx.length)
            ? "${listaxx[i][0].toUpperCase()}${listaxx[i].substring(1)}" ' '
            : "${listaxx[i][0].toUpperCase()}${listaxx[i].substring(1)}";
      }
    }
    return s; //"${s[0].toUpperCase()}${s.substring(1)}";
  }
}

dynamic getLocationst(Map<dynamic, dynamic> json, String referncia) {
  dynamic referenciaf;
  Referencia sedet = Referencia(key: null, nombre: null);
  Referencia ubicaciont = Referencia(key: null, nombre: null);
  Referencia subUbicaciont = Referencia(key: null, nombre: null);
  String locationt = 'sede';

  if ((json['sede'] == null) && (json['ubicacion'] == null) && (json['subUbicacion'] == null)) {
    locationt = 'sede';
    sedet = Referencia.fromFirebase(json);
  } else if ((json['sede'] != null) &&
      (json['ubicacion'] == null) &&
      (json['subUbicacion'] == null)) {
    locationt = 'ubicacion';
    sedet = Referencia(key: json['sede'], nombre: json['sedeNombre']);
    ubicaciont = Referencia.fromFirebase(json);
  } else if ((json['sede'] != null) &&
      (json['ubicacion'] != null) &&
      (json['subUbicacion'] == null)) {
    locationt = 'subUbicacion';
    sedet = Referencia(key: json['sede'], nombre: json['sedeNombre']);
    ubicaciont = Referencia(key: json['ubicacion'], nombre: json['ubicacionNombre']);
    subUbicaciont = Referencia.fromFirebase(json);
  } else if ((json['sede'] != null) &&
      (json['ubicacion'] != null) &&
      (json['subUbicacion'] != null)) {
    locationt = 'inventario';
    sedet = Referencia(key: json['sede'], nombre: json['sedeNombre']);
    ubicaciont = Referencia(key: json['ubicacion'], nombre: json['ubicacionNombre']);
    subUbicaciont = Referencia(key: json['subUbicacion'], nombre: json['subUbicacionNombre']);
  }
  switch (referncia) {
    case 'location':
      referenciaf = locationt;
      break;
    case 'sede':
      referenciaf = sedet;
      break;
    case 'ubicacion':
      referenciaf = ubicaciont;
      break;
    case 'subUbicacion':
      referenciaf = subUbicaciont;
      break;
    default:
  }
  return referenciaf;
}

PreferredSize appBarInst(
  String titulo,
  double? titleSpacing,
  double? width, [
  String? subtitulo,
  String? articulo,
]) {
  return PreferredSize(
    preferredSize: (articulo != null)
        ? const Size.fromHeight(toolbarHeight)
        : const Size.fromHeight(toolbarHeight - 15),
    child: AppBar(
      elevation: 0,
      backgroundColor: (isDarkModeEnabled) ? primario.withOpacity(0.98) : Colors.white,
      iconTheme: IconThemeData(
        color: (isDarkModeEnabled)
            ? Colors.white
            : primario.withOpacity(0.98), //change your color here
      ),
      titleSpacing: titleSpacing,
      leadingWidth: 40,
      toolbarHeight: toolbarHeight,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {},
                child: Container(
                  decoration: (isDarkModeEnabled)
                      ? circleNeumorpDecorationBlack
                      : circleNeumorpDecorationWhite,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 38,
                    height: 38,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      // (widget.location == 'sedes')?widget.location.capitalize():
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.normal,
                        fontSize: fontSize * 1.3,
                        color: (isDarkModeEnabled) ? color4 : color5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    (articulo != null)
                        ? Column(
                            children: [
                              SizedBox(
                                width: width,
                                height: 20,
                                child: Text(
                                  (subtitulo != null) ? subtitulo : institucionEducativa,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize * 1.2,
                                    color: (isDarkModeEnabled) ? color1 : primario,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width,
                                height: 25,
                                child: Text(
                                  articulo,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize * 1.2,
                                    color: (isDarkModeEnabled) ? color1 : primario,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: width,
                            height: 20,
                            child: Text(
                              (subtitulo != null) ? subtitulo : institucionEducativa,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize * 1.2,
                                color: (isDarkModeEnabled) ? color1 : primario,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key? key,
    Locale? locale,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    bool use24hFormat = false,
    TextStyle? dateTextStyle,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    ValueChanged<DateTime>? onDateSelected,
    InputDecoration? decoration,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.date,
    DateTimeFieldCreator fieldCreator = DateTimeField.new,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (FormFieldState<DateTime> field) {
            // Theme defaults are applied inside the _InputDropdown widget
            final InputDecoration decorationWithThemeDefaults =
                decoration ?? const InputDecoration();

            final InputDecoration effectiveDecoration =
                decorationWithThemeDefaults.copyWith(errorText: field.errorText);

            void onChangedHandler(DateTime value) {
              if (onDateSelected != null) {
                onDateSelected(value);
              }
              field.didChange(value);
            }

            return fieldCreator(
              firstDate: firstDate,
              initialDate: initialDate,
              lastDate: lastDate,
              decoration: effectiveDecoration,
              initialDatePickerMode: initialDatePickerMode,
              dateFormat: dateFormat,
              onDateSelected: onChangedHandler,
              selectedDate: field.value,
              enabled: enabled,
              use24hFormat: use24hFormat,
              mode: mode,
              initialEntryMode: initialEntryMode,
              dateTextStyle: dateTextStyle,
            );
          },
        );

  @override
  FormFieldState<DateTime> createState() => FormFieldState<DateTime>();
}

// -----------------------
class DateRangeFormField extends FormField<DateTimeRange> {
  DateRangeFormField({
    Key? key,
    FormFieldSetter<DateTimeRange>? onSaved,
    FormFieldValidator<DateTimeRange>? validator,
    DateTimeRange? initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          builder: (FormFieldState<DateTimeRange> field) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final initialDateRange = field.value ??
                          DateTimeRange(
                            start: DateTime.now().add(const Duration(days: -1)),
                            end: DateTime.now(),
                          );
                      final newDateRange = await showDateRangePicker(
                        context: field.context,
                        firstDate: inicio_ano_lectivo,
                        lastDate: DateTime.now(),
                        initialDateRange: initialDateRange,
                        locale: const Locale('es', 'ES'),
                      );
                      if (newDateRange != null) {
                        field.didChange(newDateRange);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Rango de fechas del reporte',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            field.value == null
                                ? 'Selecciona un rango de fechas'
                                : '${DateFormat('EE dd MMMM', 'es').format(field.value!.start)} - ${DateFormat('EE dd MMMM', 'es').format(field.value!.end)}',
                            style: GoogleFonts.sora(
                              fontSize: 18,
                              // color: Colors.black87,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (field.hasError)
                    Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            );
          },
        );
}
