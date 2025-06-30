import 'package:broad/buyerPart/myDrawer.dart';
import 'package:broad/buyerPart/profilePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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

  final List<String> images =[
    'https://www.w3schools.com/w3images/lights.jpg',
    'https://www.w3schools.com/w3images/mountains.jpg',
    'https://www.w3schools.com/w3images/forest.jpg',
  ];

  @override
  void getData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name");
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
          ),
          drawer: Mydrawer(),
          body: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              children: [
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
                            image: NetworkImage(imageUrl),
                          fit: BoxFit.cover
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ));
  }
}


