import 'dart:convert';

import 'package:broad/sellerPart/sellerHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class Additempage extends StatefulWidget {
  const Additempage({super.key});

  @override
  State<Additempage> createState() => _AdditempageState();
}

class _AdditempageState extends State<Additempage> {

  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice= TextEditingController();
  TextEditingController itemDescription = TextEditingController();

  String? base64Image;


  Future<void> createItem()async{
    try{
      await FirebaseFirestore.instance.collection('product').add({
        'name':itemName.text,
        'price':itemPrice.text,
        'description':itemDescription.text,
        'image':base64Image,
      });
    }catch(e){
      print("Erroe: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async{
    final picker=ImagePicker();
    final pickedFile= await picker.pickImage(source: source,imageQuality: 70);

    if (pickedFile != null) {
      final compressed = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 70,
      );
      if (compressed != null) {
        setState(() {
          base64Image = base64Encode(compressed);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Add item here"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: TextFormField(
                  controller: itemName,
                  decoration: InputDecoration(
                    hintText: "Name of the Item",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: TextFormField(
                  controller: itemPrice,
                  decoration: InputDecoration(
                    hintText: "Price of the Item",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: TextFormField(
                  controller: itemDescription,
                  decoration: InputDecoration(
                    hintText: "Description ",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    pickImage(ImageSource.camera);
                  },
                      icon: Icon(Icons.camera_alt_outlined)),
                  IconButton(onPressed: (){
                    pickImage(ImageSource.gallery);
                  }, icon: Icon(Icons.photo)),
                ],
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sellerhomepage()));
                    createItem();
                  },
                  child: Text("Save"),
              ),

              if (base64Image != null)
                Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Preview:"),
                      Image.memory(base64Decode(base64Image!), height: 150),
                    ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
