import 'package:broad/sellerPart/sellerHomePage.dart';
import 'package:flutter/material.dart';

import '../loginPage.dart';

class Sellerprofilepage extends StatefulWidget {
  const Sellerprofilepage({super.key});

  @override
  State<Sellerprofilepage> createState() => _SellerprofilepageState();
}

class _SellerprofilepageState extends State<Sellerprofilepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Sellerhomepage()));
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
      )
    ));
  }
}
