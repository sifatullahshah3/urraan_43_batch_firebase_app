import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class FirestoreSimpleDemo extends StatefulWidget {
  const FirestoreSimpleDemo({super.key});

  @override
  State<FirestoreSimpleDemo> createState() => _FirestoreSimpleDemoState();
}

class _FirestoreSimpleDemoState extends State<FirestoreSimpleDemo> {
  var _controllerName = TextEditingController();
  var _controllerRollNo = TextEditingController();

  var studentRef = FirebaseFirestore.instance.collection("students");

  @override
  void initState() {
    super.initState();
  }

  loadEvents() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'FirestoreSimpleDemo',
      parameters: {'datetime': DateTime.now().toString()},
    );
  }

  void addStudent() {
    String name = _controllerName.text.toString();
    int rollNo = int.parse(_controllerRollNo.text.toString());

    Map<String, dynamic> data = {"name": name, "rollNo": rollNo};

    studentRef.add(data);
  }

  String? selectedStudentId;

  void deleteStudent(String docId) {
    studentRef.doc(docId).delete();
  }

  void updateStudent() {
    String name = _controllerName.text.toString();
    int rollNo = int.parse(_controllerRollNo.text.toString());

    Map<String, dynamic> data = {"name": name, "rollNo": rollNo};

    studentRef.doc(selectedStudentId).update(data);
    selectedStudentId = null;
    _controllerName.text = "";
    _controllerRollNo.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final stream = studentRef
        .where("rollNo", isGreaterThan: 0)
        .orderBy("rollNo", descending: false)
        .limit(2)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Simple Demo")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controllerName,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _controllerRollNo,
              decoration: const InputDecoration(hintText: "Roll No"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                try {
                  Future<void>.delayed(const Duration(milliseconds: 200), () {
                    throw StateError("Real uncaught async crash");
                  });
                } catch (e) {
                  print(e.toString());
                }
                return;
                if (selectedStudentId != null)
                  updateStudent();
                else
                  addStudent();
              },
              child: Text(
                selectedStudentId != null ? "Update Student" : "Add Student",
              ),
            ),

            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: stream,
                builder: (context, builder) {
                  if (!builder.hasData) {
                    return CircularProgressIndicator();
                  } else if (builder.hasError) {
                    return Text("Something went wrong");
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: builder.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = builder.data!.docs[index];

                        var studentData = data.data() as Map<String, dynamic>;

                        String id = data.id;

                        loadData(id);

                        String? name = studentData["name"];
                        int? rollNo = studentData["rollNo"];

                        return ListTile(
                          onTap: () {
                            _controllerName.text = name.toString();
                            _controllerRollNo.text = rollNo.toString();
                            selectedStudentId = id;
                            setState(() {});
                          },
                          leading: Icon(Icons.person_2_outlined),
                          title: Text(name.toString()),
                          subtitle: Text(
                            "${rollNo.toString()}, Examtotal marks = 100",
                          ),
                          trailing: InkWell(
                            onTap: () {
                              deleteStudent(id);
                            },
                            child: Icon(Icons.delete),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadData(id) async {
    Query sss = studentRef.doc(id).collection("examMarks");

    AggregateQuerySnapshot totalMarks = await sss
        .aggregate(sum("totalMarks"))
        .get();

    print(totalMarks.getSum("totalMarks"));
  }
}
