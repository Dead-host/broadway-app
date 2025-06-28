import 'dart:convert';
import 'dart:developer';

import 'package:broad/homePage.dart';
import 'package:broad/signupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool see=true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> loginUser() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final User? user = userCredential.user;

      if(user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
      }

      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      final userData = userSnapshot.data() as Map<String, dynamic>?;
      log("user email:"+userData.toString());
      print("Login successful: ${user?.email}");
      return user;
    } catch (e, stacktrace) {
      print("Login Error: $e");
      print("StackTrace: $stacktrace");
      Fluttertoast.showToast(msg: "Invalid username or password");
      return null;
    }
    } // firebase auth login

  Future loginStat() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse('https://api-barrel.sooritechnology.com.np/api/v1/user-app/login'),
        headers:{
          'Content-Type':'application/json',
          'Accept':'application/json',
        },
      body: json.encode({
        "userName": emailController.text,
        "password": passwordController.text,
      }),
    );

    if(response.statusCode==200){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
    }
    else{
      Fluttertoast.showToast(
          msg: "Invalid credentials",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return response;
  }// api call
  
  Future getDataInfo() async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    
    final response = await http.get(
      Uri.parse('https://api-barrel.sooritechnology.com.np/api/v1/barrel-app/barrel-inbound-code'),
      headers: {
        'Content-Type':'application/json',
        'Accept':'application/json',
      },
    );

    if(response.statusCode==200){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
    }
    else{
      Fluttertoast.showToast(msg: "Error");
    }
    return response;
    
  } //api get
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                    "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                  "to the login page",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
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
                ),
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: TextFormField(
                obscureText: see,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "password",
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            see=!see;
                          });
                        },
                        icon: Icon(see?Icons.visibility:Icons.visibility_off)),
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
                ),
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: ()async{
                  loginUser();
                  //SharedPreferences prefs = await SharedPreferences.getInstance();
                  //loginStat();
                  //getDataInfo();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                },
                child: Text("Login")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Signuppage()));
                  },
                    child: Text(
                        "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
