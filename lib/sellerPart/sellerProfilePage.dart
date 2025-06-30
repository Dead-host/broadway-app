import 'package:broad/sellerPart/sellersDrawer.dart';
import 'package:flutter/material.dart';

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
      drawer: Sellersdrawer(),
    ));
  }
}
