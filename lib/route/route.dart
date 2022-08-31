import 'dart:io';

import 'package:deskto_app/addPage.dart';
import 'package:deskto_app/home.dart';
import 'package:flutter/material.dart';

class PageRouting {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => Home());
      case '/addPage':
        if (args is int) {
          return MaterialPageRoute(
              builder: (context) => AddNotesPage(
                    idNotes: args,
                  ));
        } else {
          return _errorRoute();
        }
      default:
        return exit(0);
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Home();
    });
  }
}
