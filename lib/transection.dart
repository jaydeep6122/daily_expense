import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense/clienttransection.dart';
import 'package:daily_expense/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class transection extends StatefulWidget {
  const transection({super.key});

  @override
  State<transection> createState() => _transectionState();
}

class _transectionState extends State<transection> {
  List sortedItem = [];
  double subtotal = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? userid;
    userid = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("History"),
      ),
      drawer: drawer(),
      body: Container(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("transection")
                        .where("userid", isEqualTo: userid!.uid)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // setState(() {
                      //   sortedItem = (snapshot.data!.docs);
                      // });
                      // print(sortedItem);
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var remarks =
                                  snapshot.data!.docs[index]['remarks'];
                              var time = snapshot.data!.docs[index]['time'];
                              var amount = snapshot.data!.docs[index]['amount'];
                              var type = snapshot.data!.docs[index]['type'];

                              return Center(
                                  child: Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.sizeOf(context).width * 0.05,
                                    vertical: MediaQuery.sizeOf(context).width *
                                        0.01),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text("${type[0]}"),
                                  ),
                                  title: Row(
                                    children: [
                                      Text("${remarks}"),
                                      Spacer(),
                                      if (type == "deposit")
                                        Text(
                                          "+${amount}",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      if (type == "withdraw")
                                        Text(
                                          "-${amount}",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                    ],
                                  ),
                                  subtitle: Text("${time}"),
                                ),
                              ));
                            });
                      }
                      // if (snapshot.connectionState == ConnectionState.active) {
                      //   QuerySnapshot querySnapshot = snapshot.data;
                      // }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double calculateSubtotal(List<DocumentSnapshot> documents) {
  double total = 0.0;
  for (var value in documents) {
    total = total + value['total'];
  }
  return total;
}
