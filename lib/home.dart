import 'dart:math';

import 'package:deskto_app/addPage.dart';
import 'package:deskto_app/db/sql_helper.dart';
import 'package:deskto_app/homegrid.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  getNotes() async {
    final notes = await SQLHelper.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#252525"),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // actions: [
          //   GestureDetector(
          //     onTap: () {},
          //     child: Container(
          //       margin: EdgeInsets.only(right: 30, top: 10, bottom: 10),
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       decoration: BoxDecoration(
          //           color: HexColor("#3B3B3B"),
          //           borderRadius: BorderRadius.circular(15)),
          //       child: Icon(Icons.search, size: 25),
          //     ),
          //   )
          // ],
          titleSpacing: 30,
          backgroundColor: HexColor("#252525"),
          elevation: 0,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Notes",
              style: TextStyle(fontSize: 33),
            ),
          ),
        ),
        body: HomeGrid(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 15),
          child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addPage', arguments: 0)
                    .then((value) {
                  setState(() {
                    getNotes();
                  });
                });
              },
              child: const Icon(
                Icons.add,
                size: 40,
              ),
              elevation: 10,
              backgroundColor: HexColor("#252525")),
        ),
      ),
    );
  }
}
