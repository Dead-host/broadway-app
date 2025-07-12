import 'dart:developer';
import 'package:broad/buyerPart/homePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginPage.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordChangeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool see=false;
  bool seePass=false;
  bool? light;
  bool? isFingerPrintEnable;


  void getData()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      light=_pref.getBool('isFingerEnable')??false;
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
                )
              ],
            ),
          ),
        ));
  }
}
