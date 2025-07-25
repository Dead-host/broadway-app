import 'dart:io';
import 'dart:math';

import 'package:broad/buyerPart/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart'as pw;


enum PaymentMethod{cod,khalti}

class Checkoutpage extends StatefulWidget {

  final double price;
  final List<Map<String, dynamic>> selectedItem;
  Checkoutpage(this.selectedItem,this.price);

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {

  String currentAddress='';
  double latitude=0.0;
  double longitude=0.0;
  PaymentMethod? selectedPaymentMethod;
  bool isProcessing=false;
  String? orderId='';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      currentAddress = '${place.subLocality}, ${place.locality}, ${place.country}';
    });
  }


  Future<void> saveOrderToFirestore() async{
    orderId=DateTime.now().millisecondsSinceEpoch.toString();
    final user=_auth.currentUser;
    if(user!=null){
      try{
        await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('orders').doc(orderId).set({
          'user':user.uid,
          'orderDate':FieldValue.serverTimestamp(),
          'orderId':orderId,
          'items':widget.selectedItem,
          'subTotal':widget.price,
          'shippingCost':50,
          'tax':100,
          'totalPrice':widget.price+150,
          'paymentMethod':selectedPaymentMethod.toString()??'unknown',
          'currentAddress':{
            'lat':27.6889087,
            'long':85.3492267
          },
          'deliveryAddress':{
            'lat':latitude,
            'long':longitude
          },
          'officeAddress':{
            'lat':27.6889087,
            'long':85.3492267
          },
          'status':'delivered',
          

        });
        for (int i =0;i<widget.selectedItem.length;i++){
          String itemId = widget.selectedItem[i]['name'];
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cart').doc(itemId).update({'isCheckout':true});
        }
      }catch(e){
        print(e);
      }
    }
  }

  Future<void> proceedToPayment() async{
    if(selectedPaymentMethod==PaymentMethod.khalti){
      KhaltiScope.of(context).pay(
        config: PaymentConfig(
            amount: (widget.price * 100).toInt(),
          //  productIdentity: 'shopping-items-$orderId',
            productName: 'Shopping Items',
            productIdentity: 'gjh'
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
        ],
        onSuccess: (success) async {
          print("Payment Success: $success");

          try {
            // await sendOrderEmail(widget.selectedItems);
            await saveOrderToFirestore();

            //await generateAndDownloadPDF();

            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Payment Successful'),
                    content: const Text('Your order has been placed successfully!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          generateAndDownloadPDF();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          } catch (e) {
            print("Error processing successful payment: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error processing your order. Please contact support.')),
            );
          } finally {
            setState(() {
              isProcessing = false;
            });
          }
        },
        onFailure: (failure) {
          print("Payment Failed: $failure");
          setState(() {
            isProcessing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment failed. Please try again.')),
          );
        },
      );
    }
  }

  Future<void> generateAndDownloadPDF() async {
    final pdf = pw.Document();
    final formatter = DateFormat('dd-MM-yyyy hh:mm a');
    final currentDate = formatter.format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Order ID: $orderId'),
                    pw.Text('Date: $currentDate'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Customer Details:'),
                    pw.Text('Phone: ${phoneController.text}'),
                    pw.Text('Email: ${emailController.text}'),
                    pw.Text('Address: ${locationController.text}'),
                    pw.Text('Location: $currentAddress'),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('Order Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Product', 'Quantity', 'Unit Price', 'Total'],
              data: widget.selectedItem.map((item) {
                int qty = item['qty'] ?? 1;
                double price = double.tryParse(item['price'].toString()) ?? 0.0;
                double itemTotal = qty * price;
                return [
                  item['name'],
                  qty.toString(),
                  'Rs.${price.toStringAsFixed(2)}',
                  'Rs.${itemTotal.toStringAsFixed(2)}',
                ];
              }).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.${widget.price.toStringAsFixed(2)}'),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Shipping:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.50.00'),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rs.100.00'),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text('Rs.${(widget.price + 150).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('Payment Information', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Payment Method: ${selectedPaymentMethod?.name.toUpperCase() ?? "N/A"}'),
            pw.Text('Payment Status: Completed'),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text('Thank you for your purchase!', style: pw.TextStyle(fontSize: 16)),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text('For any questions, please contact customer support.'),
            ),
          ];
        },
      ),
    );

    try {
      final directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final path = '${directory.path}/Invoice_$orderId.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      print('Invoice saved to $path');
      OpenFile.open(path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice saved to $path')),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate invoice. Please try again.')),
      );
    }
  }



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
                      hintText: currentAddress==''?"Location":currentAddress,
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
            TextButton(onPressed: (){
              getCurrentLocation();
            }, child: Text("Get curent location")),
            SizedBox(height: 50,),
           // Text(widget.price.toString()), Edit this make it beautiful as per the requirement
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: DropdownButtonFormField<PaymentMethod>(
                  value: selectedPaymentMethod,
                  items: PaymentMethod.values.map((method){
                    return DropdownMenuItem(
                      value: method,
                        child: Text(method.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (method){
                    setState(() {
                      selectedPaymentMethod=method;
                    });
                  },
                decoration: InputDecoration(
                  labelText: 'Selected payment method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: (){
                  if(selectedPaymentMethod==PaymentMethod.khalti){
                    proceedToPayment();
                  }
                  else{
                    saveOrderToFirestore();
                    generateAndDownloadPDF();
                  }
                },
                child: Text("Check Out")
            ),

          ],
        ),
      ),
    ));
  }
}
