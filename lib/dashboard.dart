import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_expense/addclient.dart';
import 'package:daily_expense/clienttransection.dart';
import 'package:daily_expense/drawer.dart';
import 'package:daily_expense/transection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  double subtotal = 0.0;

  @override
  Widget build(BuildContext context) {
    User? userid = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer(),
      body: SafeArea(
        child: Container(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                    height: 100.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Color.fromRGBO(179, 64, 224, 1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 2)),
                        builder: (context, snapshot) {
                          return Container(
                              height: MediaQuery.sizeOf(context).height * 0.1,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                "Balance : $subtotal ₹",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              )));
                        })),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [Text("Client's Name"), Spacer(), Text("Amount")],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("clients")
                          .where("userid", isEqualTo: userid!.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }
                        if (snapshot.data != null) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var clientname =
                                    snapshot.data!.docs[index]['name'];
                                var clienttotal =
                                    snapshot.data!.docs[index]['total'];
                                var clientid =
                                    snapshot.data!.docs[index]['clientid'];

                                subtotal =
                                    calculateSubtotal(snapshot.data!.docs);

                                return Center(
                                    child: GestureDetector(
                                  onTap: () {
                                    Get.to(clienttransection(
                                        clientId: clientid,
                                        clientname: clientname,
                                        clienttotal: clienttotal));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(width: 0.1),
                                    )),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            "$clientname",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (clienttotal >= 0)
                                            Text(
                                              "₹ ${clienttotal}",
                                              style: const TextStyle(
                                                  color: Colors.green),
                                            ),
                                          if (clienttotal < 0)
                                            Text(
                                              "₹ ${clienttotal}",
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                              });
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(dashboard());
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50.0,
                          //width: MediaQuery.sizeOf(context).width * 0.3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(179, 64, 224, 1),
                                Colors.black
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
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
                              child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ))),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(addclient());
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50.0,
                          //width: MediaQuery.sizeOf(context).width * 0.4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.grey, Colors.black],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
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
                              child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              Text(
                                "Add Client",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ))),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(transection());
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50.0,
                          //width: MediaQuery.sizeOf(context).width * 0.3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.black,
                                Color.fromRGBO(179, 64, 224, 1)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
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
                              child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.white,
                              ),
                              Text(
                                "History",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: AnimatedNotchBottomBar(
      //   notchBottomBarController: _controller,
      //   color: Colors.white,
      //   showLabel: false,

      //   notchColor: Colors.black87,

      //   /// restart app if you change removeMargins
      //   //removeMargins: false,
      //   bottomBarWidth: 500,
      //   durationInMilliSeconds: 300,
      //   bottomBarItems: [
      //     const BottomBarItem(
      //       inActiveItem: Icon(
      //         Icons.home_filled,
      //         color: Colors.blueGrey,
      //       ),
      //       activeItem: Icon(
      //         Icons.home_filled,
      //         color: Colors.blueAccent,
      //       ),
      //       itemLabel: 'Page 1',
      //     ),
      //     const BottomBarItem(
      //       inActiveItem: Icon(
      //         Icons.star,
      //         color: Colors.blueGrey,
      //       ),
      //       activeItem: Icon(
      //         Icons.star,
      //         color: Colors.blueAccent,
      //       ),
      //       itemLabel: 'Page 2',
      //     ),

      //     ///svg example
      //   ],
      //   onTap: (index) {
      //     _pageController.jumpToPage(index);
      //   },
      // ),
    );
    //other params
  }
}

double calculateSubtotal(List<DocumentSnapshot> documents) {
  double total = 0.0;
  for (var value in documents) {
    total = total + value['total'];
  }
  return total;
}
