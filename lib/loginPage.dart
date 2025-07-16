import 'dart:convert';
import 'dart:developer';

import 'package:broad/buyerPart/homePage.dart';
import 'package:broad/sellerPart/sellerHomePage.dart';
import 'package:broad/signupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
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
  int _tabTextIndexSelected=0;
  bool see=true;
  bool isLoading=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      if(didAuthenticate){
        loginUserWithBiometric();
      }else{

      }
    } on PlatformException catch (e) {
      if (e.code == 'LockedOut') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Too many failed attempts. Please try again in 30 seconds.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint(e.toString());
      }
    }

  }

  List<DataTab> get _listTextTabToggle => [
  DataTab(title: "Buyer"),
  DataTab(title:"Seller"),
  ];



  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    signInOption: SignInOption.standard,
  );

  bool?  isFingerPrintEnable ;


  void getDetail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFingerPrintEnable = preferences.getBool('isFingerEnable')??false;
    });

  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
      googleUser ??= await _googleSignIn.signIn();
      if (googleUser == null) {
        log("Google sign-in was cancelled by the user.");
        return null;
      }
      log("Google User Selected:");
      log("Email: ${googleUser.email}");
      log("Display Name: ${googleUser.displayName}");
      log("ID: ${googleUser.id}");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        log("Firebase User Info:");
        log("UID: ${user.uid}");
        log("Email: ${user.email}");
        log("Name: ${user.displayName}");
        log("Photo URL: ${user.photoURL}");
      }
      return userCredential;
    } catch (e, stacktrace) {
      print("Google Sign-In Error: $e");
      print("StackTrace: $stacktrace");
      return null;
    }
    }

  Future<User?> loginUser() async {

    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading=true;
    });
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      _pref.setString('email',emailController.text,);
      _pref.setString( 'password',passwordController.text,);

      final User? user = userCredential.user;

      if(user != null){

        if(_tabTextIndexSelected==0){
          setState(() {
            isLoading=false;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
        }
        else{
          setState(() {
            isLoading=false;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Sellerhomepage()));
        }
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

  Future<User?> loginUserWithBiometric() async {

    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading=true;
    });
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _pref.getString('email')??"",
        password: _pref.getString('password')??"",
      );



      final User? user = userCredential.user;

      if(user != null){

        if(_tabTextIndexSelected==0){
          setState(() {
            isLoading=false;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
        }
        else{
          setState(() {
            isLoading=false;
          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Sellerhomepage()));
        }
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

    }

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
    
  }//api get

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body:isLoading?SpinKitSpinningLines(color: Colors.purple,size: 100,):
        SingleChildScrollView(
          child:Column(

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Icon(Icons.computer_rounded,size: 150,),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    "Hello Again",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Welcome back, you have been missed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 20,),
              FlutterToggleTab(
                width: 90,
                borderRadius: 50,
                height: 50,
                selectedIndex: _tabTextIndexSelected,
                selectedBackgroundColors: [Colors.deepPurple],
                selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                unSelectedTextStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                unSelectedBackgroundColors: [Colors.white],
                dataTabs: _listTextTabToggle,
                selectedLabelIndex: (index)=> setState(() {
                  _tabTextIndexSelected=index;
                }),
                isScroll: false,
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: 20,),
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
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: ()async{
                        loginUser();
                        //SharedPreferences prefs = await SharedPreferences.getInstance();
                        //loginStat();
                        //getDataInfo();
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                      },
                      child: Text("Login")),
                  Visibility(
                    visible: isFingerPrintEnable!,
                    child: IconButton(
                        onPressed: (){_authenticateWithBiometrics();},
                        icon: Icon(Icons.fingerprint)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () async {

                    UserCredential? userCredential = await signInWithGoogle();


                    if (userCredential != null) {

                      if (_tabTextIndexSelected == 1) {

                      } else {

                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Google Sign-In failed. Please try again.",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },

                  icon: Image.asset('assets/google_icon.png', height: 24),
                  label: const Text("Sign in with Google"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row (
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
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),

        ),

      ),
    );
  }
}
