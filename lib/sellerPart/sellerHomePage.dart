import 'package:broad/sellerPart/addItemPage.dart';
import 'package:broad/sellerPart/sellerProfilePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../loginPage.dart';

class Sellerhomepage extends StatefulWidget {
  const Sellerhomepage({super.key});

  @override
  State<Sellerhomepage> createState() => _SellerhomepageState();
}

class _SellerhomepageState extends State<Sellerhomepage> {

  final List<String> images=[
    'assets/profile1.jpg',
    'assets/profile2.jpg',
    'assets/profile3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home page"),
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person,size: 40,),
                  title: Text("Profile",style: TextStyle(fontSize: 20),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sellerprofilepage()));
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
                  padding: const EdgeInsets.only(top: 450.0),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Additempage()));
                        },
                        child: Text("Add Item"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ));;
  }
}
