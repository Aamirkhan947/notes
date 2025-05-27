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
    noteCollRef = firebaseFireStore!.collection("notes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async{
       DocumentReference docRef = await noteCollRef!.add({
           "title":"My Notes",
           "description": "This is My notes",
           "created_at": DateTime.now().millisecondsSinceEpoch.toString()
         });
       print("Documents: ${docRef.id}");
      },child: Icon(Icons.add),
      ),


    );
  }
}
