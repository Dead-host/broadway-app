import 'dart:convert';

import 'package:broad/buyerPart/cartPage.dart';
import 'package:broad/buyerPart/productDetail.dart';
import 'package:broad/buyerPart/profilePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../loginPage.dart';




class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String? name;
  TextEditingController searchController= TextEditingController();


  final List<String> images =[
    'assets/keyboard.jpg',
    'assets/mouse.png',
    'assets/nitro_five.png',
  ];

  @override
  void getData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  void addToCart(Map<String,dynamic> product) async{
    final user = _auth.currentUser;
    final cartRef = _firestore.collection('users').doc(user!.uid).collection('cart').doc(product['name']);

    await cartRef.set({
      'name':product['name'],
      'price':product['price'],
      'description':product['description'],
      'image':product['image'],
      'qty':1,
      'isCheckout': false,
      'isDelivered': false,
    });

  }

  initState(){
    super.initState();
    getData();
  }
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Home page",
            ),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Cartpage()));}, icon: Icon(Icons.shopping_cart))
            ],
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Profilepage()));
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
                //search bar
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search Item",
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
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 89/9,
                    viewportFraction: 0.8,
                  ),
                  items: images.map((imageUrl){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.cover
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 600,
                  width: 400,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('product').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Productdetail(data['name'],data['price'],data['description'],data['image'])));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: data['image'] != null && data['image'] != ""
                                        ? Image.memory(
                                      base64Decode(data['image']),
                                      fit: BoxFit.cover,
                                    )
                                        : const Icon(Icons.image, size: 80),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data['name'] ?? "No Name",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Price: Rs. ${data['price'] ?? 'N/A'}"),
                                        Text(
                                          data['description'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                      onPressed: (){
                                        addToCart(data);

                                      },
                                      child: Text("Add to Cart")),

                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


