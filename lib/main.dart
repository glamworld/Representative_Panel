import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Projects/flutter/representative_panel/lib/pages/login_page.dart';
import 'file:///C:/Projects/flutter/representative_panel/lib/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:representative_panel/providers/auth_provider.dart';
import 'package:representative_panel/providers/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    //RGB Color Code (0, 194, 162)
    50: Color.fromRGBO(0, 197, 164, .1),
    100: Color.fromRGBO(0, 197, 164, .2),
    200: Color.fromRGBO(0, 197, 164, .3),
    300: Color.fromRGBO(0, 197, 164, .4),
    400: Color.fromRGBO(0, 197, 164, .5),
    500: Color.fromRGBO(0, 197, 164, .6),
    600: Color.fromRGBO(0, 197, 164, .7),
    700: Color.fromRGBO(0, 197, 164, .8),
    800: Color.fromRGBO(0, 197, 164, .9),
    900: Color.fromRGBO(0, 197, 164, 1),
  };
  String id;
  String pass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id');
      pass = preferences.get('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
        ChangeNotifierProvider(create: (context) => FirebaseProvider(),),
      ],
      child: MaterialApp(
        title: 'DakterBari',
        theme: ThemeData(
            primarySwatch: MaterialColor(0xff00C5A4, color),
            //HEX Color Code(0xff00C5A4)
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            cursorColor: Colors.black,
            //BottomNavigationBar Theme...
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 50,
              showUnselectedLabels: true,
              unselectedIconTheme: IconThemeData(color: Colors.grey[800]),
            )),
        debugShowCheckedModeBanner: false,
        home: id == null ? LogIn() : HomePage(),
      ),
    );
  }
}