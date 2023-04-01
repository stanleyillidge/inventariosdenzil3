// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:math';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:flutter/foundation.dart" show kDebugMode, kIsWeb;
import "dart:io" show Platform;
import "package:hive/hive.dart";
import "package:path_provider/path_provider.dart";

import "../estilos.dart";
import "../modelos/models.dart";
import '_sedes.dart';

Image? myImage;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.title, this.nueva}) : super(key: key);

  final String? title;
  final double? nueva;

  @override
  LoginPageState createState() => LoginPageState();
}

class User {
  String? uid;
  String? email;
  String? photoUrl;
  String? displayName;

  User({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });
}

logout() async {
  login = false;
  await loginState.put('login', login);
  await googleSignIn.signOut();
}

Future refreshSignInWithGoogle() async {
  try {
    if (kDebugMode) {
      print([DateTime.now().toLocal(), "refreshSignInWithGoogle()"]);
    }
    googleSignInAccount = await googleSignIn.signInSilently();
    if (kDebugMode) {
      print([DateTime.now().toLocal(), googleSignInAccount!.displayName]);
    }
    await adecuarUsuario(googleSignInAccount);
  } catch (e) {
    if (kDebugMode) {
      print(["Error en el login", e]);
    }
  }
}

Future<bool> adecuarUsuario(GoogleSignInAccount? googleSignInAccount) async {
  try {
    googleAuth = await googleSignInAccount!.authentication;
    accessToken = googleAuth!.accessToken;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth!.accessToken,
      idToken: googleAuth!.idToken,
    );
    if (kDebugMode) {
      print(['googleAuth', googleAuth]);
    }
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (kDebugMode) {
      print(['googleSignInAccount', googleSignInAccount]);
    }
    if (googleSignInAccount.email == 'inventarios@denzilescolar.edu.co') {
      googleUser = GoogleUser(
        name: Name(
          fullName: googleSignInAccount.displayName,
        ),
        primaryEmail: googleSignInAccount.email,
        id: googleSignInAccount.id,
        emails: [
          Emails(
            address: googleSignInAccount.email,
          )
        ],
        organizations: [],
      );
      return true;
    } else {
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print(["Error en adecua usuario", e]);
    }
    return false;
  }
}

class LoginPageState extends State<LoginPage> {
  signInWithGoogle() async {
    try {
      bool t = false;
      googleSignInAccount = await googleSignIn.signIn();
      t = await adecuarUsuario(googleSignInAccount);
      setState(() {
        login = true;
      });
      return t;
    } catch (e) {
      if (kDebugMode) {
        print(["Error en el login", e]);
      }
      showAlertDialog(context, e.toString(), "Error el el login");
      return false;
    }
  }

  showAlertDialog(BuildContext context, String texto, String titulo) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(texto),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future initializeHive() async {
    loginState = await Hive.openBox('loginState');
    googleAuthStorage = await Hive.openBox('googleAuthStorage');
    login = await loginState.get('login');
    if (kIsWeb) {
      // print(["Flutter Web"]);
      // print('Hive web is ok');
    } else if (Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      // print('Hive Android is ok');
    }
    sedes = [];
    ubicaciones = [];
    subUbicaciones = [];
    // await mapLocations();
  }

  @override
  void initState() {
    super.initState();
    initializeHive();
    myImage = Image.asset(
      "assets/logos/google.png",
      width: 80,
      height: 80,
    );
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      googleSignInAccount = account;
      bool a = await adecuarUsuario(account);
      if (a) {
        if (kDebugMode) {
          print(['Login en initState', googleUser?.name?.fullName]);
        }
        setState(() {
          login = login;
          googleUser = googleUser;
        });
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return const SedesPage();
            },
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return Align(
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
      } else {
        await logout();
        showAlertDialog(context, 'Lo siento no eres un usuario valido', 'Ups!');
      }
    });
    googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> fondos = [
    'assets/img/login.gif',
  ];

  final _random = Random();

  snack(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('¡Ups! Debes ser un docente!'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('es'), // Spanish, no country code
      ],
      debugShowCheckedModeBanner: false,
      home: Container(
        // color: Color(0xFFF144d8b),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(fondos[_random.nextInt(fondos.length)]),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        decoration: circleNeumorpDecorationBlack,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: Image.asset(
                          'assets/logo.png',
                          width: 25,
                          height: 25,
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700),
                        onPressed: () async {
                          // print("Login with Google");
                          bool a = await signInWithGoogle();
                          if (a) {
                            sedes = [];
                            ubicaciones = [];
                            subUbicaciones = [];
                            /* print([
                              'Login antes de SetState',
                              googleUser?.name?.fullName,
                              asignaciones.length
                            ]); */
                            setState(() {
                              login = login;
                              googleUser = googleUser;
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SedesPage();
                                },
                              ),
                            );
                          } else {
                            // await snack(context);
                            // print('¡Ups! Debes ser un docente!');
                            await logout();
                          }
                        },
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Iniciar sesion',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
