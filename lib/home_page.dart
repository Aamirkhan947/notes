import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore? firebaseFireStore;
  CollectionReference? noteCollRef;

  @override
  void initState() {
    super.initState();
    firebaseFireStore = FirebaseFirestore.instance;
    //noteCollRef =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),

      /// StreamBuilder RealTime Data
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseFireStore!.collection("notes").snapshots(),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Somthing wrong data!! "));
          }
          if (snap.hasData) {
            List<QueryDocumentSnapshot> allNotes = snap.data!.docs;

            return allNotes.isNotEmpty
                ? ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> eachNotes =
                        allNotes[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(eachNotes['title']),
                      subtitle: Text(eachNotes['description']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                firebaseFireStore!
                                    .collection("notes")
                                    .doc(allNotes[index].id)
                                    .set({
                                      "title": "Title Update",
                                      "description": "Description Update",
                                    });
                                setState(() {});
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                firebaseFireStore!
                                    .collection("notes")
                                    .doc(allNotes[index].id)
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                : Center(child: Text("No notes found"));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                          decoration: InputDecoration(
                              hintText: 'title')
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'description'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              DocumentReference docRef =
                                  await firebaseFireStore!
                                      .collection("notes")
                                      .add({
                                        "title": "My Notes",
                                        "description": "This is my notes",
                                        "created_at":
                                            DateTime.now()
                                                .millisecondsSinceEpoch,
                                      });
                              print("DocId: ${docRef.id}");
                              Navigator.pop(context);
                            },
                            child: Text("Add"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              DocumentReference docRef = await noteCollRef!
                                  .add({
                                    "title": "My Notes",
                                    "description": "This is my notes",
                                    "created_at":
                                        DateTime.now().millisecondsSinceEpoch,
                                  });
                              print("DocId: ${docRef.id}");
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
