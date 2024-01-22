import 'package:daily_expense/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = true;

  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   isLoading = false;
  // }

  @override
  Widget build(BuildContext context) {
    return
        //isLoading
        //? Center(child: const CircularProgressIndicator())
        //:
        Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                'https://i.pinimg.com/736x/48/bd/06/48bd06bacac88355e51e9b8131de858e.jpg',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.orangeAccent[700],

                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height * 0.70,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.1),
                    margin: const EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Expanse Tracker',
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: "NotoSerif",
                                color: Color.fromRGBO(96, 63, 131, 1)),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.email),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )),
                            validator: (value) {
                              if (value!.length == 0) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              emailController.text = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _isObscure3,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure3
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure3 = !_isObscure3;
                                    });
                                  }),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              enabled: true,
                            ),
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return "Password cannot be empty";
                              }
                              if (!regex.hasMatch(value)) {
                                return ("please enter valid password min. 6 character");
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              passwordController.text = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot Password ? ",
                                      style: TextStyle(
                                          color: Color.fromRGBO(1, 79, 131, 20),
                                          decoration: TextDecoration.underline),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            // color: Color.fromRGBO(1, 79, 131, 20),
                            width: 200,
                            child: MaterialButton(
                              //splashColor: Color.fromRGBO(1, 79, 134, 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              elevation: 5.0,
                              height: 50,
                              onPressed: () async {
                                setState(() {
                                  visible = true;
                                });
                                //var email = emailController.text;

                                String email = emailController.text.trim();
                                String pass = passwordController.text.trim();
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: pass)
                                    .then((value) => Get.off(dashboard()));
                              },
                              color: Color.fromRGBO(1, 79, 131, 20),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: const Center(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
