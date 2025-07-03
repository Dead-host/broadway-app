import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Checkoutpage extends StatefulWidget {

  final double price;
  final List<Map<String, dynamic>> selectedItem;
  Checkoutpage(this.selectedItem,this.price);

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Check Out Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: TextFormField(
                controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Email",
                      suffixIcon: Icon(Icons.email_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.purple
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      )
                  )
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      hintText: "Phone Number",
                      suffixIcon: Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.purple
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      )
                  )
              ),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                      hintText: "Location",
                      suffixIcon: Icon(Icons.location_on),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.purple
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      )
                  )
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){}, child: Text("Check Out")),

          ],
        ),
      ),
    ));
  }
}
