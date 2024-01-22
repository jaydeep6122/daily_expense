import 'package:daily_expense/addclient.dart';
import 'package:daily_expense/dashboard.dart';
import 'package:daily_expense/loginpage.dart';
import 'package:daily_expense/transection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer drawer() {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            "Home",
          ),
          onTap: () {
            Get.to(dashboard());
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            "Add Client",
          ),
          onTap: () {
            Get.to(addclient());
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text(
            "History",
          ),
          onTap: () {
            Get.to(transection());
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            "Log out",
          ),
          onTap: () async {
            await FirebaseAuth.instance
                .signOut()
                .then((value) => Get.offAll(() => LoginPage()));
          },
        ),
      ],
    ),
  );
}
