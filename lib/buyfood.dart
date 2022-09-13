import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

import 'models/users.dart';

class BuyFood extends StatefulWidget {
  final Users currentUser;
  
  const BuyFood({Key? key,required this.currentUser}) : super(key: key);

  @override
  State<BuyFood> createState() => _BuyFoodState();
}

class _BuyFoodState extends State<BuyFood>
    with WidgetsBindingObserver,TickerProviderStateMixin {
  late AnimationController? _animationcontroller;
  final _formKey = GlobalKey<FormState>();
    TextEditingController foodnameController = TextEditingController();
    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: (
        Column(
          children:[])
      ),);
      }
    }