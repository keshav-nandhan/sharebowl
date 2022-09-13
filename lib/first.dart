import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sharebowl/buyfood.dart';
import 'package:sharebowl/sellfood.dart';

import 'models/users.dart';

class FirstPage extends StatefulWidget {

final Users userLoggedIn;
final int tabIndex;
final CameraDescription camera;
FirstPage({Key? key, required this.userLoggedIn,required this.tabIndex,required this.camera}) : super(key: key);


  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
var tabSectionTabs = [
  const BuyFoodTab(),
  const SellFoodTab()
  ];


@override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[400],
          centerTitle: true,
          bottom:TabBar(isScrollable: true, tabs: tabSectionTabs,labelPadding:EdgeInsets.fromLTRB(50, 20, 50, 20) ,),
          title: Text("Share Bowl"),
        ),
        body: TabBarView(
          children:<Widget>[
          BuyFood(currentUser:widget.userLoggedIn),
          SellFood(currentUser:widget.userLoggedIn,camera:widget.camera)
          ]),
      ),);
  }
}

class BuyFoodTab extends StatefulWidget {
  const BuyFoodTab({Key? key}) : super(key: key);

  @override
  State<BuyFoodTab> createState() => _BuyFoodTabState();
}

class _BuyFoodTabState extends State<BuyFoodTab> {
  @override
  Widget build(BuildContext context) {
   return Row(children:[
Container(child: Text("Pick Up")),Icon(Icons.restaurant_sharp)
    ]);
  }
}


class SellFoodTab extends StatefulWidget {
  const SellFoodTab({Key? key}) : super(key: key);

  @override
  State<SellFoodTab> createState() => _SellFoodTabState();
}

class _SellFoodTabState extends State<SellFoodTab> {
  @override
  Widget build(BuildContext context) {
    return Row(children:[
Container(child: Text("Offer"),),Icon(Icons.food_bank_sharp)
    ]);
  }
}