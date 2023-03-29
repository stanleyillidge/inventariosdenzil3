import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventariosdenzil2/rutas.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'modelos/models.dart';
import 'vistas/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  (kIsWeb)
      ? Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyADk_J9HSGzKBvjnThqReo6M41Gz0wwTus",
            authDomain: "inventarios-develop.firebaseapp.com",
            projectId: "inventarios-develop",
            storageBucket: "inventarios-develop.appspot.com",
            messagingSenderId: "393183873945",
            appId: "1:393183873945:web:ab98e190215d7bd6bca108",
            measurementId: "G-C9SEQB0DSH",
          ),
        )
      : await Firebase.initializeApp();
  await initializeHive();
  getPackageInfo();
  login = await googleSignIn.isSignedIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 2460,
          minWidth: 320,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(320, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(580, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      initialRoute: Routes.home,
      onGenerateRoute: (RouteSettings settings) {
        return Routes.fadeThrough(settings, (context) {
          switch (settings.name) {
            case Routes.home:
              return const LoginPage();
            case Routes.post:
            // return const PostPage();
            case Routes.style:
            // return const TypographyPage();
            default:
              return const SizedBox.shrink();
          }
        });
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
