import 'package:broad/homePage.dart';
import 'package:broad/loginPage.dart';
import 'package:broad/myDrawer.dart';
import 'package:broad/profilePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings page"),
            centerTitle: true,
          ),
          drawer:Mydrawer(),
        ));
  }
}
