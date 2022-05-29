import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/model.dart';
import 'package:untitled2/server.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color themeColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    populateState();
  }

  void populateState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    listNote = prefs
        .getStringList("textNote")!
        .map((e) => Note.fromMap(json.decode(e)))
        .toList();

    setState(() {});
  }
//--------------------------------------------------------------------------------

  final textController = TextEditingController();

  final prefranceServer _prefrance = prefranceServer();

  List<Note>? listNote = [];

//**************************************
  addNoteTxt() async {
    final textNoteEdit = Note(textController.text);
    var textNote = await _prefrance.saveServer(textNoteEdit);
    listNote!.add(textNote);
    print(textNote);
    Navigator.of(context).pop();
  }

  update() async {}
//**************************************

  editDialog(Note note) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        deleteNote(note);
                      });
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const MyHomePage()));
                    },
                    child: const Text("Delete"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(themeColor),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          null;
                        } else {
                          setState(() {
                            editNote(note, Note(textController.text));
                          });
                        }
                      },
                      child: const Text("Edit"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      )),
                ],
              )
            ],
            content: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Edit Note "),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 20,
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "Edit Note",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: themeColor,
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.note,
                          color: themeColor,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      cursorColor: themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  addDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        if (textController.text.isEmpty) {
                          null;
                        } else {
                          setState(() {
                            addNote(Note(textController.text));
                          });
                        }
                      },
                      child: const Text("Add"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      )),
                ],
              )
            ],
            content: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Add New Note "),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 20,
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "New Note",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: themeColor,
                        ),
                        hintStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.note,
                          color: themeColor,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      cursorColor: themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget emptyList() {
    return const Center(
        child: Text('Add Note ......',
            style: TextStyle(
                color: Colors.black, letterSpacing: .5, fontSize: 25)));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: listNote!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = listNote![index];
        return Dismissible(
          key: Key(item.textNote.toString()),
          confirmDismiss: (DismissDirection direction) async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        "Are You Sure You Want To Delete This ${item.textNote}"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: themeColor),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              listNote!.removeAt(index);
                              deleteNote(Note(item.textNote));
                            });
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: themeColor),
                          )),
                    ],
                  );
                });
            return null;
          },
          onDismissed: (DismissDirection direction) {
            setState(() {
              listNote!.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    setState(() {
                      listNote!.insert(index, item);
                      addNote(item);
                    });
                  },
                ),
              ));
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: const Icon(Icons.delete_forever),
          ),
          child: ListTile(
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              height: 70,
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(item.textNote,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            onTap: () {
              editDialog(item);
              textController.text = item.textNote;
            },
          ),
        );
      },
    );
  }

// ----------------------Add TextNote And Save It-----------------------------

  void saveData() async {
    List<String> stringList =
        listNote!.map((item) => json.encode(item.toMap())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('textNote', stringList);
    print(prefs.getStringList('textNote'));
  }

  void addNote(Note note) {
    listNote!.add(note);
    saveData();
    Navigator.of(context).pop();
  }

  void deleteNote(Note note) {
    listNote!.remove(note);
    saveData();
    Navigator.of(context).pop();
  }

  void editNote(Note oldNote, Note newNote) {
    int index = listNote!.indexOf(oldNote);
    listNote!.remove(oldNote);
    listNote!.insert(index, newNote);
    saveData();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                "Change Color",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text(
                  "Red",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const PopupMenuItem(
                child: Text(
                  "Blue",
                  style: TextStyle(color: Colors.blue),
                ),
                value: 2,
              ),
              const PopupMenuItem(
                child: Text(
                  "Green",
                  style: TextStyle(color: Colors.green),
                ),
                value: 3,
              ),
              const PopupMenuItem(
                child: Text(
                  "Yellow",
                  style: TextStyle(color: Colors.yellow),
                ),
                value: 4,
              ),
            ],
            onSelected: (value) {
              setState(() {
                if (value == 1) {
                  themeColor = Colors.red;
                } else if (value == 2) {
                  themeColor = Colors.blue;
                } else if (value == 3) {
                  themeColor = Colors.green;
                } else if (value == 4) {
                  themeColor = Colors.yellow;
                }
              });
            },
          )
        ],
        title: const Text('Notes'),
        centerTitle: true,
        backgroundColor: themeColor,
      ),
      body: listNote!.isEmpty ? emptyList() : buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog();
          textController.text = "";
        },
        child: const Icon(Icons.add),
        backgroundColor: themeColor,
      ),
    );
  }
}
