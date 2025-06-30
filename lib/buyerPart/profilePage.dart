import 'package:broad/buyerPart/homePage.dart';
import 'package:broad/buyerPart/myDrawer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../loginPage.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {





  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile page"),
            centerTitle: true,
          ),
          drawer: Mydrawer(),
        ));
  }
}
