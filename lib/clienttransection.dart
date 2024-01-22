import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense/deposit.dart';
import 'package:daily_expense/drawer.dart';
import 'package:daily_expense/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class clienttransection extends StatefulWidget {
  final clientId;
  final clientname;
  final clienttotal;
  clienttransection({
    super.key,
    required this.clientId,
    required this.clientname,
    required this.clienttotal,
  });

  @override
  State<clienttransection> createState() => _clienttransectionState();
}

class _clienttransectionState extends State<clienttransection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          bottomNavigationBar: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(deposit(
                      clientId: widget.clientId,
                      clienttotal: widget.clienttotal));
                },
                child: Container(
                    height: 50.0,
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Income",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(withdraw(
                      clientId: widget.clientId,
                      clienttotal: widget.clienttotal));
                },
                child: Container(
                    height: 50.0,
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Expense",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))),
              ),
            ],
          ),
          drawer: drawer(),
          appBar: AppBar(
            title: Text(
              "${widget.clientname}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 100.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "₹ ${widget.clienttotal}",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ))),
              SizedBox(
                height: 20,
              ),
              Text("All Expenses"),
              Expanded(
                child: Container(
                  child: Scaffold(
                    body: Center(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("transection")
                            .where("clientid", isEqualTo: widget.clientId)
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(snapshot.error.toString()));
                          }
                          if (snapshot != null && snapshot.data != null) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var remarks =
                                      snapshot.data!.docs[index]['remarks'];
                                  var time = snapshot.data!.docs[index]['time'];
                                  var amount =
                                      snapshot.data!.docs[index]['amount'];
                                  var type = snapshot.data!.docs[index]['type'];
                                  var paymentmode =
                                      snapshot.data!.docs[index]['paymentmode'];
                                  print(type);
                                  return Center(
                                      child: Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.sizeOf(context).width *
                                                0.05,
                                        vertical:
                                            MediaQuery.sizeOf(context).width *
                                                0.01),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text("${remarks}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          Spacer(),
                                          if (type == "deposit")
                                            Text(
                                              "+${amount}",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          if (type == "withdraw")
                                            Text(
                                              "-${amount}",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        "${time}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ));
                                });
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
