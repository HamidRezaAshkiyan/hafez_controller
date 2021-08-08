import 'package:flutter/material.dart';
import 'package:hafez_controller/pages/home.dart';
import 'package:hafez_controller/pages/loading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Hafez Controller',
  theme: ThemeData(
      fontFamily: 'Vazir',
      // colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(backgroundColor: Colors.orange)
  ),
  initialRoute: '/home',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
  },
  localizationsDelegates: [
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [
    Locale("fa", "IR"),
  ],
));