import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sharebowl/buyfood.dart';
import 'package:sharebowl/sellfood.dart';
import 'package:sharebowl/wallet.dart';

import 'login.dart';
import 'models/users.dart';

class FirstPage extends StatefulWidget {
  final Users userLoggedIn;
  final int tabIndex;
  final CameraDescription camera;
  const FirstPage(
      {super.key,
      required this.userLoggedIn,
      required this.tabIndex,
      required this.camera});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  var tabSectionTabs = [const BuyFoodTab(), const SellFoodTab()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[400],
          actions: [
            IconButton(
              icon: const Icon(Icons.wallet),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WalletPage(
                    user: widget.userLoggedIn,
                  );
                }));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage(
                    analytics: analytics,
                    observer: observer,
                  );
                }));
              },
            ),
          ],
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: tabSectionTabs,
            labelPadding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
          ),
          //title: Text("Share Bowl"),
        ),
        body: TabBarView(children: <Widget>[
          BuyFood(currentUser: widget.userLoggedIn),
          OfferFood(currentUser: widget.userLoggedIn, camera: widget.camera)
        ]),
      ),
    );
  }
}

class BuyFoodTab extends StatefulWidget {
  const BuyFoodTab({super.key});

  @override
  State<BuyFoodTab> createState() => _BuyFoodTabState();
}

class _BuyFoodTabState extends State<BuyFoodTab> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(child: const Text("Pick Up")),
      const Icon(Icons.restaurant_sharp)
    ]);
  }
}

class SellFoodTab extends StatefulWidget {
  const SellFoodTab({super.key});

  @override
  State<SellFoodTab> createState() => _SellFoodTabState();
}

class _SellFoodTabState extends State<SellFoodTab> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        child: const Text("Offer"),
      ),
      const Icon(Icons.food_bank_sharp)
    ]);
  }
}
