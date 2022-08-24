import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final firestore = FirebaseFirestore.instance;
  String? name;
  String? phoneNumber;

  // var S = Uuid();
  // var v1 = S.v1();

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("notes").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firebase',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add note"),
                  content: Container(
                    width: 400,
                    height: 100,
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (newValue) {
                            name = newValue;
                          },
                          decoration: InputDecoration(
                            hintText: 'Please, type your name',
                          ),
                        ),
                        TextFormField(
                          onChanged: (newValue) {
                            phoneNumber = newValue;
                          },
                          decoration: InputDecoration(
                            hintText: 'Please, type your phone number',
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          firestore.collection('notes').add({
                            'id': '',
                            'name': '$name',
                            'phone': '$phoneNumber',
                          });
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('notes').snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['phone']),
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.delete),
                      //   color: Colors.red,
                      //   onPressed: () {
                      //     setState(() {
                      //       snapshot.data!.docs.removeAt(index);
                      //     });
                      //   },
                      // ),
                    );
                  },
                )
              : snapshot.hasError
                  ? Text('Error is Happened')
                  : CircularProgressIndicator();
        },
      ),
    );
  }
}
