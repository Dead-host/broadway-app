import 'dart:convert';

import 'package:broad/buyerPart/checkoutPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {

  Future<void> updateCart(String docId, int qty)async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').doc(docId).update(
        {'qty':qty});
  }

  double calculateTotal(List<QueryDocumentSnapshot> items) {
    double total=0.0;
    for(var item in items){
      final data = item.data() as Map<String,dynamic>;
      final price = double.tryParse(item['price'].toString());
      final qty = item['qty'];
      total += price! * qty;
    }
    return total;
  }

  Future<void> emptyCart()async{
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final collectionRef=FirebaseFirestore.instance.collection('users').doc(uid).collection('cart');
    final cartItems = await collectionRef.where('isCheckout',isEqualTo: false).get();
    for(var doc in cartItems.docs){
      await doc.reference.delete();
    }
  }

  Future<void> proceedToCheckout(List<QueryDocumentSnapshot> items, double totalPrice) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    List<Map<String, dynamic>> selectedItems = items.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'],
        'price': data['price'],
        'qty': data['qty'] ?? 1,
        'image': data['image'],
      };
    }).toList();


    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>Checkoutpage(selectedItems, totalPrice))
    );


    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout completed successfully!')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(child: Scaffold(
      appBar: AppBar(

        title: Text("Cart page"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            //delete cart item
            emptyCart();
          },
              icon: Icon(Icons.delete)
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').where('isCheckout', isEqualTo: false).snapshots(),
          builder: (context,snapshot){
            final items = snapshot.data!.docs;
            final totalPrice= calculateTotal(items);
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                        itemBuilder: (context,index){
                          final data = items[index].data() as Map<String,dynamic>;
                          final qty = data['qty'];
                          final docId = items[index].id;
                          return Card(
                            child: ListTile(
                              leading: Image.memory(base64Decode(data['image']),height: 50,width: 60,),
                              title: Text(data['name']??""),
                              subtitle: Text("Price: Rs ${data['price']??""}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        if(qty>1){
                                          updateCart(docId, qty-1);
                                        }
                                        else{
                                          FirebaseFirestore.instance.collection('users').doc(uid).collection('cart').doc(docId).delete();
                                        }
                                      },
                                      icon: Icon(Icons.remove)
                                  ),
                                  Text(data['qty'].toString()),
                                  IconButton(
                                      onPressed: (){
                                        updateCart(docId, qty+1);
                                      },
                                      icon: Icon(Icons.add)
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                    )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Total: Rs. ${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: (){
                          proceedToCheckout(items, totalPrice);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
      ),
    ));
  }
}
