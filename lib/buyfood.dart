
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
  List<RecipieDetails>? _recipiesFeed;
  late AnimationController? _animationcontroller;
  final _formKey = GlobalKey<FormState>();
  TextEditingController foodnameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _recipiesFeed = FireStoreMethods().recipiesFeed();
    print(_recipiesFeed!.length);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if(_recipiesFeed!=null)
    // return RecipiesFeed(context,_recipiesFeed);
    // else
    // return Container(child: Text("No Dishes Found",));
    return Scaffold(
      body: PageView.builder(
        itemCount: _recipiesFeed!.length,
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: 0, viewportFraction: 1),
        itemBuilder: (context, index) {
          return Container(
            child: (RecipiesFeed(
                context, _recipiesFeed![index], widget.currentUser)),
          );
        },
      ),
    );
  }

  RecipiesFeed(
      BuildContext context, RecipieDetails recipies, Users currentUser) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    var api = FireStoreMethods();
    return CupertinoPageScaffold(
        child: Stack(children: [
      Center(
        child: SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black54)),
                padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 10.0),
                margin: const EdgeInsets.all(10),
                child: Container(
                  child: recipies.imageAddress == null
                      ? Image.asset('sharebowl.jpg')
                      : Image.network(recipies.imageAddress!,
                          height: 250, width: 300, fit: BoxFit.fill),
                ),
              ),
              BottomCenter(
                child: Container(
                  width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                    color: offWhite.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(child: Text(recipies.name!)),
                ),
              ),
              BottomCenter(
                child: Container(
                  width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                    color: offWhite.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
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
    ]));
  }
}
