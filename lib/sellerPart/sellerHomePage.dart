import 'package:broad/sellerPart/addItemPage.dart';
import 'package:broad/sellerPart/sellersDrawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../buyerPart/myDrawer.dart';

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
          drawer: Sellersdrawer(),
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
