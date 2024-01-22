import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense/dashboard.dart';
import 'package:daily_expense/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class addclient extends StatefulWidget {
  const addclient({super.key});

  @override
  State<addclient> createState() => _addclientState();
}

class _addclientState extends State<addclient> {
  TextEditingController nameController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    //user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? userid = FirebaseAuth.instance.currentUser;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: drawer(),
        appBar: AppBar(
          title: Text('Add Client'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Full Name",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          controller: remarksController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Remarks (Brother/sister/etc)",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Container(
                            child: const Text(
                              'Add Client',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 18, 44, 114)),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 120)),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color.fromARGB(255, 11, 42, 110),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () async {
                                String clientId = const Uuid().v4();
                                var name = nameController.text.trim();
                                var remarks = remarksController.text.trim();
                                if (name.isNotEmpty && remarks.isNotEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection("clients")
                                      .doc(clientId)
                                      .set({
                                    "userid": "${userid!.uid}",
                                    "clientid": clientId,
                                    "name": name,
                                    "remarks": remarks,
                                    "total": 0
                                  });
                                  Get.to(dashboard());
                                }
                              },
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
