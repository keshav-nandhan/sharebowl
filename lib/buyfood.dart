import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharebowl/providers/api.dart';

import 'config.dart';
import 'models/recipiemaster.dart';
import 'models/users.dart';

class BuyFood extends StatefulWidget {
  final Users currentUser;

  const BuyFood({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<BuyFood> createState() => _BuyFoodState();
}

class _BuyFoodState extends State<BuyFood>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Stream<QuerySnapshot> _recipiesFeed;

  late AnimationController? _animationcontroller;
  final _formKey = GlobalKey<FormState>();
  TextEditingController foodnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _recipiesFeed = FireStoreMethods().recipiesFeed();
    print(_recipiesFeed!.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if(_recipiesFeed!=null)
    List<RecipieDetails> data = [];
    // return RecipiesFeed(context,_recipiesFeed);
    // else
    // return Container(child: Text("No Dishes Found",));
    return Scaffold(
      body: Container(
          child: StreamBuilder(
              stream: _recipiesFeed,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _recipiesFeed.listen((event) => event.docs.forEach((element) {
                        if (element.exists) {
                          print(element.data());
                          data.add(RecipieDetails(
                              uid: element.data()!["uid"],
                              category: element.data()!["category"],
                              description: element.data()!["description"],
                              cityLocation: element.data()!["cityLocation"],
                              dateUpdated: element.data()!["dateUpdated"],
                              imageAddress: element.data()!["imageAddress"],
                              isAvailable: element.data()!["isAvailable"],
                              name: element.data()!['name'],
                              pickedUpBy: element.data()!['pickedUpBy'],
                              postedby: element.data()!["postedby"],
                              quantity: element.data()!['quantity'],
                              requestedby: element.data()!['requestedby'],
                              comments: element.data()!['comments']));
                        }
                      }));
                  return RecipiesFeed(data, widget.currentUser);
                } else {
                  return CircularProgressIndicator();
                }
              })),
    );
  }
}

class RecipiesFeed extends StatelessWidget {
  final Users currentUser;

  final List<RecipieDetails> recipies;
  RecipiesFeed(this.recipies, this.currentUser);

  var api = FireStoreMethods();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return PageView.builder(
        itemCount: recipies.length,
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        itemBuilder: (context, index) {
          return CupertinoPageScaffold(
            child: Stack(children: [
              Center(
                child: SizedBox(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 22.0, horizontal: 10.0),
                        margin: const EdgeInsets.all(10),
                        child: Container(
                          child: recipies[index].imageAddress == null
                              ? Image.asset('sharebowl.jpg')
                              : Image.network(recipies[index].imageAddress!,
                                  height: 250, width: 300, fit: BoxFit.fill),
                        ),
                      ),
                      BottomCenter(
                        child: Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            color: offWhite.withOpacity(0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(child: Text(recipies[index].name!)),
                        ),
                      ),
                      BottomCenter(
                        child: Container(
                          width: 400,
                          height: 40,
                          decoration: BoxDecoration(
                            color: offWhite.withOpacity(0.8),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                              child: ElevatedButton(
                            onPressed: () async {},
                            child: const Text("Request PickUp"),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }
}
