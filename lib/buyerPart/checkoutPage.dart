import 'package:broad/buyerPart/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

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
