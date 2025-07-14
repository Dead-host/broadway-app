import 'dart:developer';

import 'package:flutter/material.dart';

class Functionssss extends StatefulWidget {
  const Functionssss({super.key});

  @override
  State<Functionssss> createState() => _FunctionssssState();
}

class _FunctionssssState extends State<Functionssss> {


  double? sum;
  double? mul;
  double?div;
  String? evenOdd;

  TextEditingController a=TextEditingController();
  TextEditingController b=TextEditingController();

  void add(double a, double b)async{
    setState(() {

      div =(a*b)/(a+b);
      log(div.toString());
      if(div! % 2==0.0){
        evenOdd="even";
      }
      else{
        evenOdd="odd";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Functionssss"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: TextFormField(
              controller: a,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "1st number",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20,)
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: TextFormField(
              controller: b,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "2nd number",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20,)
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            add(double.parse(a.text), double.parse(b.text));
            log(sum.toString());

          }, child: Text("div")),
          SizedBox(height: 20,),
          // Text(sum.toString()),
          // Text(mul.toString()),
          Text(div==null?"0.0":div!.toStringAsFixed(2)),
          Text(evenOdd.toString()),
        ],
      ),
    ));
  }
}
