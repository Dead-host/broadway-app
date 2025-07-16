import 'dart:developer';
import 'package:broad/buyerPart/changePassword.dart';
import 'package:broad/buyerPart/homePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginPage.dart';

enum Gender{male,female,others}

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool? light;
  bool? isFingerPrintEnable;
  Gender? selectedGender;
  String? email;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void getData()async{
    final user = _auth.currentUser;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      light=_pref.getBool('isFingerEnable')??false;
      email=user!.email;
    });
  }
  void updateUserInfo()async{
    final user = _auth.currentUser;
    final userRef = _firestore.collection('users').doc(user!.uid);

    await userRef.update(
        {
          'name':userNameController.text,
          'address':addressController.text,
          'phone':phoneController.text,
        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile page"),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  child:Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/default_image.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                shape:BoxShape.circle,
                                color: Colors.white,
                                border:Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.person,size: 20,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home,size: 40,),
                  title: Text("Home",style: TextStyle(fontSize: 20),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person,size: 40,),
                  title: Text("Profile",style: TextStyle(fontSize: 20),),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout,size: 40,),
                  title: Text("Logout",style: TextStyle(fontSize: 20),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
                  child: Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blueGrey),
                    child: Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage('assets/default_image.jpg'),

                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 140,
                          child: GestureDetector(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                shape:BoxShape.circle,
                                color: Colors.white,
                                border:Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.edit,size: 20,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                        hintText: email,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.green),
                      )

                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.drive_file_rename_outline),
                        hintText: "Change User Name",
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
                    controller: addressController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.home_outlined),
                        hintText: "Change Address",
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
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.phone),
                        hintText: "Change Phone number",
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
                  child: DropdownButtonFormField<Gender>(
                    value: selectedGender,
                      items: Gender.values.map((method){
                        return DropdownMenuItem(
                          value: method,
                            child: Text(method.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (method){
                        setState(() {
                          selectedGender=method;
                        });
                      },
                    decoration: InputDecoration(
                      labelText: "Select Gender",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Enable Biometric ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          Icon(Icons.fingerprint),
                        ],
                      ),
                      Switch(
                          value: light!,
                          activeColor: Colors.greenAccent,
                          onChanged: (bool value) async {

                            SharedPreferences pref = await SharedPreferences.getInstance();

                            pref.setBool('isFingerEnable', value);
                            pref.setBool('isFingerEnable', value);

                            setState(() {
                              light=value;
                            });

                          }
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 30,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change Password ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Changepassword()));
                        },
                        icon:Icon(Icons.password,size: 30,color: Colors.deepPurple,)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: (){
                  if(userNameController.text!=null){
                    updateUserInfo();
                    Fluttertoast.showToast(
                      msg: "Updated",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: "Name cannot be empty",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }

                },
                    child: Text("Update Profile")),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ));
  }
}
