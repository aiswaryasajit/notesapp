import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _myNoteBox = Hive.box('notes');
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> _notes = [];

  Future<dynamic> getNotes() async {
    final data = _myNoteBox.keys.map((key) {
      final note = _myNoteBox.get(key);
      return {
        "key": key,
        "title": note['title'],
        "description": note['description']
      };
    }).toList();
    setState(() {
      _notes = data;
    });
  }

  Future<dynamic> createNote(Map<String, dynamic> newNote) async {
    await _myNoteBox.add(newNote);
    print(_myNoteBox.length);
  }

  Future<dynamic> deleteNote({required int key}) async {
    await _myNoteBox.delete(key);
    print('called');
    print(_myNoteBox.length);
    getNotes();
  }

  Future<dynamic> updateNote(
      {required int key, required Map<String, dynamic> updateNote}) async {
    setState(() {
      titleController.text = updateNote['title'];
      descriptionController.text = updateNote['description'];
    });
    getNotes();
    titleController.text = '';
    descriptionController.text = '';
  }
    void _showForm(BuildContext context, int key)async{
      if(key != null){
        getNotes();

      }
    

    // await _myNoteBox.put(key, updateNote);
    

  void _showForm(BuildContext context) async {
    showModalBottomSheet(
        elevation: 5,
        context: context,
        builder: (_) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.blueAccent.withOpacity(1),
                    spreadRadius: 1,
                    offset: Offset(0, 3)),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20)),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                  child: Text(
                    'Create Note',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Note title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      String title = titleController.text;
                      String description = descriptionController.text;
                      if (title.isNotEmpty && description.isNotEmpty) {
                        createNote({
                          'title': title.toString(),
                          'description': description.toString(),
                        });
                        titleController.text = '';
                        descriptionController.text = '';
                      }

                      getNotes();
                    },
                    child: Text('create'))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 49, 49),
        title: Text(
          'Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                tileColor: const Color.fromARGB(255, 147, 147, 147),
                title: Text(
                  _notes[index]['title'],
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                subtitle: Text(
                  _notes[index]['description'],
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          deleteNote(key: _notes[index]['key']);
                        },
                        icon: Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          updateNote(key: _notes[index]['key'], updateNote: {
                            'title': _notes[index]['title'],
                            "description": _notes[index]['description']
                          });
                          // deleteNote(key: _notes[index]['key']);
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context);
        },
        backgroundColor: const Color.fromARGB(255, 220, 220, 220),
        child: Icon(Icons.add),
      ),
    );
  }
}
