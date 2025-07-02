import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {

  String? base64Image;

  Future<void> pickImage(ImageSource source) async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source,imageQuality: 70);

    if(pickedFile!=null){
      final compressed = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 70
      );
      if(compressed!=null){
        setState(() {
          base64Image = base64Encode(compressed);
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text("Practice"),centerTitle: true,),
      body: Column(
        children: [
          Container(
            height: 600,
            width: 400,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('product').snapshots(),
                builder: (context,snapshot){
                  final docs= snapshot.data!.docs;

                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context,index){
                        final data = docs[index].data() as Map<String,dynamic>;

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child:data['image']!=null && data['image']!=""? Image.memory(
                                    base64Decode(data['image']),
                                    fit: BoxFit.cover,
                                  ):Icon(Icons.image,size: 50,)
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name']??'No name',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("Price: ${data['price']}"),
                                  Text(
                                    data['description'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                ],
                              ),
                              OutlinedButton(onPressed: (){}, child: Text("Add to cart")),
                            ],
                          ),
                          );
                      },
                  );
                },
            ),
          )
        ],
      )
    ));
  }
}
