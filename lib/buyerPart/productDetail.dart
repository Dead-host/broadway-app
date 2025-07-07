import 'dart:convert';

import 'package:broad/buyerPart/cartPage.dart';
import 'package:flutter/material.dart';

class Productdetail extends StatefulWidget {

  String? name;
  String? price;
  String? description;
  String? image;

  Productdetail(this.name,this.price,this.description,this.image);

  @override
  State<Productdetail> createState() => _ProductdetailState();
}

class _ProductdetailState extends State<Productdetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(base64Decode(widget.image!),height: 300,width: 500,),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.name!),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Price: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("Rs ${widget.price!}"),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.description!,),
                ],
              ),
            ),
            SizedBox(height: 100,),
            Center(
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Cartpage()));
                  },
                  child: Text("Go to cart"),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
