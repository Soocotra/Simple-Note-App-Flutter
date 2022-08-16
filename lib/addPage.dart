import 'dart:math';

import 'package:deskto_app/db/sql_helper.dart';
import 'package:deskto_app/home.dart';
import 'package:deskto_app/homegrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class AddNotesPage extends StatefulWidget {
  final int idNotes;
  const AddNotesPage({Key? key, this.idNotes = 0}) : super(key: key);

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    RefreshNotes();
    print('reloaded');
    super.initState();
  }

  void RefreshNotes() async {
    final data = await SQLHelper.getNotes();
    setState(() {
      Home.notes = data;
    });
    try {
      if (widget.idNotes != 0) {
        final dataNotes =
            Home.notes.firstWhere((element) => element['id'] == widget.idNotes);
        titleController.text = dataNotes['title'];
        bodyController.text = dataNotes['body'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNotes() async {
    String date = DateFormat.yMMMEd().format(DateTime.now());
    var randColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    await SQLHelper.postNote(
      titleController.text,
      bodyController.text,
      randColor,
      date,
    );
    RefreshNotes();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Note Added"),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> editNotes(int id, String title, String body) async {
    await SQLHelper.editNotes(id, title, body);
    RefreshNotes();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: const Text("Note Edited")));
  }

  void deleteNotes(int id) async {
    await SQLHelper.deleteNotes(id);
    RefreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: (widget.idNotes > 0)
            ? [
                deleteButton(),
                const SizedBox(
                  width: 20,
                )
              ]
            : [],
      ),
      backgroundColor: HexColor("#252525"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 20),
          child: Column(
            children: [
              TextInputData(
                controller: titleController,
                hint: "Title",
                fontSize: 40,
              ),
              const SizedBox(height: 20),
              TextInputData(
                controller: bodyController,
                hint: "Notes",
                fontSize: 15,
                multilines: true,
                fontWeight: FontWeight.w900,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 100,
        width: 100,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 20),
          child: FittedBox(
            child: FloatingActionButton(
                onPressed: () async {
                  (widget.idNotes == 0)
                      ? await addNotes().then((value) {
                          return Navigator.pop(context);
                        })
                      : await editNotes(widget.idNotes, titleController.text,
                              bodyController.text)
                          .then((value) {
                          return Navigator.pop(context);
                        });
                },
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                child: Icon(
                  color: Colors.black,
                  (widget.idNotes == 0) ? Icons.save : Icons.update,
                  size: 35,
                )),
          ),
        ),
      ),
    ));
  }

  IconButton deleteButton() {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return CupertinoAlertDialog(
                  insetAnimationCurve: Curves.easeOutQuad,
                  content: const Text("Delete Note ?"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("NO"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        deleteNotes(widget.idNotes);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: const Text("Note Deleted")));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        },
        icon: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 241, 81, 69),
          size: 35,
        ));
  }
}

class TextInputData extends StatelessWidget {
  const TextInputData(
      {Key? key,
      required this.controller,
      required this.fontSize,
      required this.hint,
      this.multilines = false,
      this.fontWeight = FontWeight.w700})
      : super(key: key);

  final TextEditingController controller;
  final double fontSize;
  final String hint;
  final bool multilines;
  final FontWeight fontWeight;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: multilines
          ? null
          : const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Colors.white, style: BorderStyle.solid))),
      child: TextField(
        minLines: (multilines) ? 30 : null,
        maxLines: (multilines) ? null : 1,
        keyboardType: (multilines) ? TextInputType.multiline : null,
        controller: controller,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white),
        showCursor: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: const Color.fromARGB(70, 141, 141, 141))),
      ),
    );
  }
}
