import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense/dashboard.dart';
import 'package:daily_expense/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class deposit extends StatefulWidget {
  final clientId;
  final clienttotal;
  deposit({super.key, required this.clientId, required this.clienttotal});

  @override
  State<deposit> createState() => _depositState();
}

class _depositState extends State<deposit> {
  String selectedValue = 'Cash';
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    //user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String tid = const Uuid().v4();
    User? userid = FirebaseAuth.instance.currentUser;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: drawer(),
        appBar: AppBar(
          title: Text('Income'),
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
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Income Amount",
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
                            hintText: "Remarks ",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Payment Mode:',
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          DropdownButton<String>(
                            value: selectedValue,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              }
                            },
                            items: <String>[
                              'Cash',
                              'Cheque',
                              'UPI',
                              'Net banking'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Container(
                            child: const Text(
                              'Add Income',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 18, 44, 114)),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 160)),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color.fromARGB(255, 11, 42, 110),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () async {
                                var amount = amountController.text.trim();
                                var remarks = remarksController.text.trim();
                                if (amount.isNotEmpty && remarks.isNotEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection("clients")
                                      .doc(widget.clientId)
                                      .update({
                                    'total':
                                        (widget.clienttotal + int.parse(amount))
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("transection")
                                      .add({
                                    "userid": "${userid!.uid}",
                                    "clientid": widget.clientId,
                                    "amount": amount,
                                    "remarks": remarks,
                                    'time': "${DateTime.now()}",
                                    'tid': tid,
                                    "paymentmode": selectedValue,
                                    'type': 'deposit'
                                  });
                                  Get.to(dashboard());
                                } else {
                                  print(widget.clienttotal.runtimeType);
                                  print("Fill details Properly");
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
