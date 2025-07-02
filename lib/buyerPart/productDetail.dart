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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.memory(base64Decode(widget.image!)),
            SizedBox(height: 50,),
            Text(widget.name!,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            Text(widget.price!,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(widget.description!,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Cartpage()));
                },
                child: Text("Add to cart"),
            ),
          ],
        ),
      ),
    ));
  }
}
