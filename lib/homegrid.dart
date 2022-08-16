import 'dart:math';

import 'package:deskto_app/addPage.dart';
import 'package:deskto_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'db/sql_helper.dart';

class HomeGrid extends StatefulWidget {
  List<Map<String, dynamic>> notes;
  static bool isEmptyGrid = true;
  HomeGrid({Key? key, required this.notes}) : super(key: key);

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return (HomeGrid.isEmptyGrid)
        ? const Center(
            child: Text(
              "Create a new one !",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        : MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: widget.notes.length,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/addPage',
                          arguments: widget.notes[index]['id'])
                      .then((_) async {
                    final data = await SQLHelper.getNotes();
                    setState(() {
                      Home.notes = data;
                      widget.notes = Home.notes;
                      if (Home.notes.length == 0) {
                        HomeGrid.isEmptyGrid = true;
                      } else {
                        HomeGrid.isEmptyGrid = false;
                      }
                    });
                  });
                },
                // onLongPress: ,
                child: Container(
                  decoration: BoxDecoration(
                      color: (widget.notes[index].length == 0)
                          ? Colors.transparent
                          : pickColour(index),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.notes[index]['title'] == '')
                              ? 'UNTITLED'
                              : widget.notes[index]['title'],
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: (widget.notes[index]['title'] != "")
                                  ? const Color.fromARGB(255, 22, 26, 11)
                                  : const Color.fromARGB(55, 22, 26, 11),
                              fontSize: 25),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.notes[index]['body'],
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 22, 26, 11),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.notes[index]['date_created'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 22, 26, 11),
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
  }

  Color? pickColour(index) {
    try {
      String colorString =
          widget.notes[index]['color'].toString(); // Color(0x12345678)
      late String valueString =
          colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
      int value = int.parse(valueString, radix: 16);
      return Color(value);
    } catch (e) {
      print(e);
    }
  }
}
