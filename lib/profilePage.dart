import 'package:broad/homePage.dart';
import 'package:broad/myDrawer.dart';
import 'package:broad/settingsPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {



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
            title: Text("Profile page"),
            centerTitle: true,
          ),
          drawer: Mydrawer(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: CarouselSlider(
                    options:CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                    ),
                  items: images.map((imgurl){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(imgurl),
                          fit: BoxFit.cover,
                        )
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ));
  }
}
