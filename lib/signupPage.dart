
import 'package:broad/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool see=true;
  bool seePass=true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    try {

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(
            {
              'uid': user.uid,
              'email': user.email,
              'name': nameController.text,
              'phone': phoneController.text,
              'address': addressController.text,
            });

        print("User registered and added to Firestore");
      }
    } catch (e, stacktrace) {
      print("Registration Error: $e");
      print("StackTrace: $stacktrace");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                        "Lets get started",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      suffixIcon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.purple
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey
                      )
                      )
                  )
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                          hintText: "Address",
                          suffixIcon: Icon(Icons.home),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.purple
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          )
                      )
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: "Phone number",
                          suffixIcon: Icon(Icons.phone),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.purple
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          )
                      )
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "email",
                          suffixIcon: Icon(Icons.email_outlined),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.purple
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          )
                      )
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                      controller: passwordController,
                      obscureText: see,
                      decoration: InputDecoration(
                          hintText: "password",
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  see=!see;
                                });
                              },
                              icon: Icon(see?Icons.visibility:Icons.visibility_off),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.purple
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          )
                      )
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: seePass,
                      decoration: InputDecoration(
                          hintText: "confirm password",
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  seePass=!seePass;
                                  });
                                },
                              icon: Icon(seePass?Icons.visibility:Icons.visibility_off),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.purple
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          )
                      )
                  ),
                ),
                SizedBox(height: 50,),
                ElevatedButton(onPressed: (){
                  registerUser();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                }, child: Text("Register")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account"),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                      },
                        child: Text(
                            "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,

                          ),

                        ),),
                  ],
                )

              ],
            ),
          ),
        ));
  }
}
