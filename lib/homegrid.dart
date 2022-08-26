import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                  return MasonryGridView.count(
                      crossAxisCount: 2,
                      itemCount: noteData.data.length,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/addPage',
                                    arguments: noteData.data[index]['id'])
                                .then((value) {
                              {
                                setState(() {
                                  getNotes();
                                });
                              }
                            });
                          },
                          // onLongPress: ,
                          child: Container(
                            decoration: BoxDecoration(
                                color: (noteData.data[index].length == 0)
                                    ? Colors.transparent
                                    : pickColour(noteData, index),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (noteData.data[index]['title'] == '')
                                        ? 'UNTITLED'
                                        : noteData.data[index]['title'],
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: (noteData.data[index]['title'] !=
                                                "")
                                            ? const Color.fromARGB(
                                                255, 22, 26, 11)
                                            : const Color.fromARGB(
                                                55, 22, 26, 11),
                                        fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    noteData.data[index]['body'],
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
                                    noteData.data[index]['date_created'],
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
      print(e);
    }
    return null;
  }
}
