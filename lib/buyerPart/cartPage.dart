import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Cart page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 600,
              width: 500,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').where('isCheckout', isEqualTo: false).snapshots(),
                  builder: (context,snapshot){
                    final items = snapshot.data!.docs;
                    return Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                              itemCount: items.length,
                                itemBuilder: (context,index){
                                  final data = items[index].data() as Map<String,dynamic>;
                                  return Card(
                                    child: ListTile(
                                      leading: Image.memory(base64Decode(data['image']),height: 50,width: 60,),
                                      title: Text(data['name']),
                                      subtitle: Text("Price: ${data['price']}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                                          Text(data['qty'].toString()),
                                          IconButton(onPressed: (){}, icon: Icon(Icons.remove)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                            )
                        )
                      ],
                    );
                  },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
