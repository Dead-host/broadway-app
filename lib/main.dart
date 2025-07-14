import 'package:broad/buyerPart/checkoutPage.dart';
import 'package:broad/buyerPart/homePage.dart';
import 'package:broad/exam.dart';
import 'package:broad/functionssss.dart';
import 'package:broad/loginPage.dart';
import 'package:broad/practice.dart';
import 'package:broad/signupPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: 'test_public_key_5c5fa086bb704a54b1efd924a2acb036',
        builder: (context,e){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: Loginpage(),
            navigatorKey: e,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: [
              KhaltiLocalizations.delegate,
            ],
          );
        }
    );
  }
}


