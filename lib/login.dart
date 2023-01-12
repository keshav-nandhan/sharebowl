import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'first.dart';
import 'models/users.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

 class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

   @override
  _LoginPageState createState() => _LoginPageState();
 }

 class _LoginPageState extends State<LoginPage> {
 late CameraController? _controller;
 late CameraDescription camera;
  late Future<void> _initializeControllerFuture;
 @override void initState() {
    super.initState();
  }

   @override

   Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body:
     Container(
      child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: const Text(
            "ShareBowl",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[200]!.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff1bccba),
                      Color(0xff22e2ab),
                    ],
                  ),
                ),
                child: GestureDetector(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_outlined),
                    color: Colors.white,
                    iconSize: 32,
                     onPressed: () async {
    try {
      await availableCameras().then((value) => camera=value.first);
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
  
        final GoogleSignInAuthentication googleAuth =await googleUser!.authentication;
        
        
        final GoogleAuthCredential googleAuthCredential =GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken) as GoogleAuthCredential;
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      
      final Users currentuser= Users(userCredential.user!.displayName, userCredential.user!.email, userCredential.user!.photoURL, userCredential.user!.uid);
         FirebaseFirestore.instance.collection("Users").doc(currentuser.uid).set({
                    'displayName':currentuser.displayName, 'email':currentuser.email,'photoURL':currentuser.photoURL,'uid':currentuser.uid,'last_LoggedIn':DateTime.now().toString()
                  },SetOptions(merge:true));
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return FirstPage(userLoggedIn:currentuser,tabIndex: 0,camera:camera);                      
                }));
  
} on FirebaseAuthException catch (e) {
  FirebaseCrashlytics.instance.log(e.message.toString());
    }
    
      },
                  ),
                ),
              ),
            ],
            
          ),
        ),
        
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Text("Sign In With Google")
          ],
        )
      ],
    ),
      ),
     
     );
   }
 }

