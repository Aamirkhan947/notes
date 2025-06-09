import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  FirebaseFirestore? firebaseFireStore;
  CollectionReference? noteCollRef;

  @override
  void initState() {
    super.initState();
    firebaseFireStore = FirebaseFirestore.instance;
    noteCollRef = firebaseFireStore!.collection("notes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: StreamBuilder<QuerySnapshot>(
        stream: noteCollRef!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> allNotes = snapshot.data!.docs;

            return allNotes.isNotEmpty
                ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> eachNotes =
                  allNotes[index].data() as Map<String, dynamic>;
                  String documentId = allNotes[index].id;
                  return Dismissible(
                    key: Key(documentId),
                    onDismissed: (direction) {
                      deleteNote(documentId);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Note deleted')));
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(eachNotes['title'] ?? ''),
                      subtitle: Text(eachNotes['description'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editNote(context, documentId,
                                  eachNotes['title'] ?? '', eachNotes['description'] ?? '');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteNote(documentId);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                })
                : const Center(child: Text("No notes found"));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addNote(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addNote(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  await addNote(title, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editNote(BuildContext context, String documentId, String initialTitle, String initialDescription) async {
    TextEditingController titleController = TextEditingController(text: initialTitle);
    TextEditingController descriptionController = TextEditingController(text: initialDescription);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  await updateNote(documentId, title, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> addNote(String title, String description) async {
    DocumentReference docRef = await noteCollRef!.add({
      "title": title,
      "description": description,
      "created_at": DateTime.now().millisecondsSinceEpoch.toString(),
    });
    print("Documents: ${docRef.id}");
  }

  Future<void> updateNote(String documentId, String title, String description) async {
    try {
      await noteCollRef!.doc(documentId).update({
        "title": title,
        "description": description,
      });
      print('Note updated successfully!');
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Future<void> deleteNote(String documentId) async {
    try {
      await noteCollRef!.doc(documentId).delete();
      print('Note deleted successfully!');
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}