import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharebowl/providers/api.dart';

import 'config.dart';
import 'models/recipiemaster.dart';
import 'models/users.dart';

class BuyFood extends StatefulWidget {
  final Users currentUser;

  const BuyFood({super.key, required this.currentUser});

  @override
  State<BuyFood> createState() => _BuyFoodState();
}

class _BuyFoodState extends State<BuyFood>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Future<List<RecipieDetails>> _recipiesFeed;

  late AnimationController? _animationcontroller;
  TextEditingController foodnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the recipes asynchronously
    _fetchRecipies();
  }

  Future<void> _fetchRecipies() async {
    _recipiesFeed = FireStoreMethods().recipiesFeed();
    print(_recipiesFeed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RecipieDetails>>(
          future: _recipiesFeed,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<RecipieDetails> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return RecipiesFeed(data, widget.currentUser);
                },
              );
            }
            // Add a default return statement
            return const Center(child: Text('No data available'));
          }),
    );
  }
}

class RecipiesFeed extends StatelessWidget {
  final Users currentUser;

  final List<RecipieDetails> recipies;
  RecipiesFeed(this.recipies, this.currentUser, {super.key});

  var api = FireStoreMethods();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height,
        child: PageView.builder(
            itemCount: recipies.length,
            scrollDirection: Axis.vertical,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            itemBuilder: (context, index) {
              return CupertinoPageScaffold(
                child: Stack(children: [
                  Center(
                    child: SizedBox(
                      height: 400,
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
                                    : Image.network(
                                        recipies[index].imageAddress!,
                                        height: 250,
                                        width: 300,
                                        fit: BoxFit.fill),
                              ),
                            ),
                            BottomCenter(
                              child: Container(
                                width: 400,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: offWhite.withOpacity(0.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
                                ),
                                child:
                                    Center(child: Text(recipies[index].name!)),
                              ),
                            ),
                            BottomCenter(
                              child: Container(
                                width: 400,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: offWhite.withOpacity(0.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25)),
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
                  ),
                ]),
              );
            }));
  }
}
