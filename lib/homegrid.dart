import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'db/sql_helper.dart';

class HomeGrid extends StatefulWidget {
  const HomeGrid({Key? key}) : super(key: key);

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> with RouteAware {
  getNotes() async {
    final notes = await SQLHelper.getNotes();
    return notes;
  }

  void deleteNotes(int id) {
    showDialog(
        useRootNavigator: false,
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
                  SQLHelper.deleteNotes(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Note Deleted")));
                  Navigator.pop(context);
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        getNotes();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNotes(),
        builder: (context, AsyncSnapshot<dynamic> noteData) {
          switch (noteData.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            case ConnectionState.done:
              {
                if (noteData.data == null) {
                  return const Center(
                    child: Text(
                      "Create a new one !",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  return StretchingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: MasonryGridView.count(
                          crossAxisCount: 2,
                          itemCount: noteData.data.length,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          itemBuilder: (context, index) {
                            int reverseIndex = noteData.data.length - 1 - index;
                            return FocusedMenuHolder(
                              menuOffset: 10,
                              menuWidth: 200,
                              onPressed: () {},
                              menuItems: [
                                FocusedMenuItem(
                                    title: const Text("Open"),
                                    trailingIcon:
                                        const Icon(CupertinoIcons.up_arrow),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/addPage',
                                              arguments: noteData
                                                  .data[reverseIndex]['id'])
                                          .then((value) {
                                        setState(() {
                                          getNotes();
                                        });
                                      });
                                    }),
                                FocusedMenuItem(
                                    title: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    trailingIcon: const Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deleteNotes(
                                          noteData.data[reverseIndex]['id']);
                                    })
                              ],
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/addPage',
                                          arguments: noteData.data[reverseIndex]
                                              ['id'])
                                      .then((value) {
                                    {
                                      setState(() {
                                        getNotes();
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: (noteData
                                                  .data[reverseIndex].length ==
                                              0)
                                          ? Colors.transparent
                                          : pickColour(noteData, reverseIndex),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          noteData.data[reverseIndex]
                                              ['date_created'],
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  202, 22, 26, 11),
                                              fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          (noteData.data[reverseIndex]
                                                      ['title'] ==
                                                  '')
                                              ? 'UNTITLED'
                                              : noteData.data[reverseIndex]
                                                  ['title'],
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  (noteData.data[reverseIndex]
                                                              ['title'] !=
                                                          "")
                                                      ? const Color.fromARGB(
                                                          255, 22, 26, 11)
                                                      : const Color.fromARGB(
                                                          55, 22, 26, 11),
                                              fontSize: 25),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          noteData.data[reverseIndex]['body'],
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 22, 26, 11),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }
              }
            case ConnectionState.none:
              return Container();
            case ConnectionState.active:
              return Container();

            default:
              return Container();
          }
        });
  }

  Color? pickColour(AsyncSnapshot<dynamic> noteData, index) {
    try {
      String colorString =
          noteData.data[index]['color'].toString(); // Color(0x12345678)
      late String valueString =
          colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
      int value = int.parse(valueString, radix: 16);
      return Color(value);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}
