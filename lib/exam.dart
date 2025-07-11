import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {


  String? punchline;
  
  Future getData() async{
    final response = await http.get(
      Uri.parse('https://official-joke-api.appspot.com/random_joke'),
      headers:{
        'Content-Type':'application/json',
        'Accept':'application/json',
      }
    );
    if(response.statusCode==200){

      setState(() {
        punchline=jsonDecode(response.body)['punchline'];
      });
    }
    else{
      print("Error");
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Exam"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(150.0),
        child: Column(

          children: [
            ElevatedButton(onPressed: (){getData();}, child: Text("Get data")),
            Text(punchline??""),
          ],
        ),
      ),
    ));
  }
}
