import 'package:broad/buyerPart/profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {

  TextEditingController passwordChangeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPass = TextEditingController();
  bool see=true;
  bool seePass=true;
  bool seeOldPass=true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void updateData()async{
    final user = _auth.currentUser;
    final userRef = _firestore.collection('users').doc(user!.uid);

    await userRef.update(
        {
          'password':passwordChangeController.text,
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: TextFormField(
              obscureText: seeOldPass,
              controller: oldPass,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          seeOldPass=!seeOldPass;
                        });
                      },
                      icon: Icon(seeOldPass?Icons.visibility:Icons.visibility_off)),
                  hintText: "Previos Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  )
              ),

            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: TextFormField(
              obscureText: see,
              controller: passwordChangeController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          see=!see;
                        });
                      },
                      icon: Icon(see?Icons.visibility:Icons.visibility_off)),
                  hintText: "Change Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: TextFormField(
              obscureText: seePass,
              controller: confirmPasswordController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          seePass=!seePass;
                        });
                      },
                      icon: Icon(seePass?Icons.visibility:Icons.visibility_off)),
                  hintText: "Confirm Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  )
              ),

            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: (){
                if(passwordChangeController.text==confirmPasswordController.text){
                  updateData();
                  Fluttertoast.showToast(
                    msg: "Password Changed Successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profilepage()));
                  // passwordChangeController.clear();
                  // confirmPasswordController.clear();
                }
                else{
                  Fluttertoast.showToast(
                    msg: "Password not match",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Text("Change Password")
          ),
        ],
      ),
    ));
  }
}
