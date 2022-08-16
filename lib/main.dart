import 'package:deskto_app/addPage.dart';
import 'package:deskto_app/home.dart';
import 'package:flutter/material.dart';
import 'package:deskto_app/route/route.dart';

import 'db/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        onGenerateRoute: PageRouting.generateRoute,
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}
