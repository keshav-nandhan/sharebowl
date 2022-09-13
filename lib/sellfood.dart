import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharebowl/models/recipiemaster.dart';
import 'models/users.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiselect/multiselect.dart';

class SellFood extends StatefulWidget {
   final Users currentUser;final CameraDescription camera;
  const SellFood({Key? key,required this.currentUser,required this.camera}) : super(key: key);

  @override
  State<SellFood> createState() => _SellFoodState();
}

class _SellFoodState extends State<SellFood>
    with TickerProviderStateMixin  {
  double? _swipeOverride;
  bool _fadeInOnNextBuild = false;Position? _currentPosition;
  late XFile image;
  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    await Future.delayed(Duration(milliseconds: 100));
    _swipeOverride = null;
    _fadeInOnNextBuild = true;
  }
  late final _VerticalSwipeController _swipeController = _VerticalSwipeController(this, _showDetailsPage);

  late AnimationController _animationcontroller;
    late CameraController _controller;
   FirebaseStorage _storage = FirebaseStorage.instance;

  List<String> selected = [];

  late Future<void> _initializeControllerFuture;
  final _formKey = GlobalKey<FormState>();
    TextEditingController foodnameController = TextEditingController();
    TextEditingController desccontroller = TextEditingController();

    TextEditingController quantityController = TextEditingController();
    List<String> Ingredients=[];
    Map<String,dynamic> IngredientsList=new Map();
    String? _category="";
       
 setSelectedRadioTile(String? val) {
    setState(() {
      _category = val;
    });
  }
 
  @override

  void initState(){
     super.initState();
    setState(() {
      FirebaseFirestore.instance.collection("Ingredients").doc("ingredientsmaster").snapshots().listen((event) =>IngredientsList=event.data()!);
    });

   
     _controller = CameraController(
      widget.camera,
      ResolutionPreset.max
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    _animationcontroller = AnimationController(vsync: this);
  }
  
Future<CameraDescription> _asyncMethod() async{
  late CameraDescription cam;
   await availableCameras().then((value) => {cam=value.first});
  return cam;
}
  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: (
          Column(
            children:[
              Form(
  key: _formKey,child:Column(
  children: [
  TextFormField(
 controller: foodnameController,
 decoration: InputDecoration(
 border: InputBorder.none,
 contentPadding: EdgeInsets.all(10.0),
 filled: true,
 fillColor: Colors.black12,
 labelText: 'Enter Dish Name',
    ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value!.isEmpty) {
     return 'Please Enter Dish Name';
     }
  
   },
 ), 
   TextFormField(
 controller: quantityController,
 decoration: InputDecoration(
 border: InputBorder.none,
 contentPadding: EdgeInsets.all(10.0),
 filled: true,
 fillColor: Colors.black12,
 labelText: '500g/1ltr/serves 3',
    ),
   // The validator receives the text that the user has entered.
   validator: (value) {
     if (value!.isEmpty) {
     return 'Please Enter Quantity';
     }
    }
   
   ),
   SizedBox(
    child:Column(
      children: [
   RadioListTile(
    toggleable: true,
    value: "Male",
    groupValue: _category,
    title: Text("Veg"),
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.black,
    selected: true,
  ),
 
  RadioListTile(
    toggleable: true,
    value: "Female",
    groupValue: _category,
    title: Text("Non-Veg"),
    onChanged: (dynamic val) {
 setSelectedRadioTile(val);
    },
    activeColor: Colors.black,
    selected: false,
  ),],)
 ),
FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
            return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropDownMultiSelect(
          onChanged: (List<String> x) {
            setState(() {
              selected =x;
            });
          },
          options: IngredientsList.keys.toList(),
          selectedValues: selected,
          whenEmpty: 'Select Ingredients',
        ),
      ),
    );
            }
),
Container(
  height: 60,
  width: 300,
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.only(left: 12),
  decoration: BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      width: .5,
    ),
  ),
  child: TextFormField(
controller: desccontroller,
decoration: InputDecoration(
  border: InputBorder.none,
 labelText: 'what"s on your mind?',),
  
  ),
),

            RawMaterialButton(
            fillColor: Colors.black12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            constraints: BoxConstraints.tightFor(height: 50.0,width: 150.0),
            elevation:4.0,
            child: Text("Add Image"),
             onPressed: () async {
      try {
      final XFile image=await _controller.takePicture();
      print(await image.readAsBytes());
     setState(() {
       
     });
      //_storage.ref('recipies/$widget.currentUser.uid').putData(await image.readAsBytes());
        

        //FirebaseFirestore.instance.collection("Recipies").doc("image1").set({"data":image},SetOptions(merge: true));

    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
             },
          ),
//          if(_controller.value.isInitialized) 
//          Container(
//             height: 250.0,width: 500.0,
//             child: FutureBuilder<void>(
//   future: _initializeControllerFuture,
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       // If the Future is complete, display the preview.
//       return CameraPreview(_controller);
//     } else {
//       // Otherwise, display a loading indicator.
//       return const Center(child: CircularProgressIndicator());
//     }
//   },
// ),
//           ),
RawMaterialButton(
            fillColor: Colors.red[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            constraints: BoxConstraints.tightFor(height: 50.0,width: 150.0),
            elevation:4.0,
            child: Text("Click to Post"),
             onPressed: () async {
      try {
        String docId=FirebaseFirestore.instance.collection("collection_name").doc().id;
        List<RecipieDetails> listDataSource=<RecipieDetails>[];
           FirebaseFirestore.instance.collection('recipie_master').doc(docId).set({
                  'uid':docId,
                  'dateupdated':DateTime.now().toString(),
                  'category':"veg",
                  'postedby':widget.currentUser.uid,
                  'quantity':quantityController.text,
                  'recipiename':foodnameController.text,
                  'citylocation':'',
                  'ingredients':selected,
                  'descyourself':desccontroller.text,
                  'imageaddress':await image.readAsBytes(),
                  'deliveryid':'',
                  'username':widget.currentUser.displayName,
                  'imageUrl':widget.currentUser.photoURL,
                  'isdelivered':false,
                  'isavailable':true
                },SetOptions(merge: true));
              
      
     setState(() {
       
     });          //var list=  Firestore.instance.collection("register_team").where('gender',isEqualTo: gender).where('favouritesport',isEqualTo: sport).snapshots().toList();
           
              }
      
      
      //_storage.ref('recipies/$widget.currentUser.uid').putData(await image.readAsBytes());
        

        //FirebaseFirestore.instance.collection("Recipies").doc("image1").set({"data":image},SetOptions(merge: true));

   catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
             },
          ),                ],
              ),)
            ]
        )),
      ),
    );
    
  }

   /// Utility method to wrap a gesture detector and wire up the required handlers.
 
  futureloaderdelay() {
            return Future.delayed(Duration(milliseconds: 1000),);
        }
}


class _VerticalSwipeController {
  _VerticalSwipeController(this.ticker, this.onSwipeComplete);
  final TickerProvider ticker;
  final swipeAmt = ValueNotifier<double>(0);
  final isPointerDown = ValueNotifier<bool>(false);
  late final swipeReleaseAnim = AnimationController(vsync: ticker)..addListener(handleSwipeReleaseAnimTick);
  final double _pullToViewDetailsThreshold = 150;
  final VoidCallback onSwipeComplete;

  /// When the _swipeReleaseAnim plays, sync its value to _swipeUpAmt
  void handleSwipeReleaseAnimTick() => swipeAmt.value = swipeReleaseAnim.value;
  void handleTapDown() => isPointerDown.value = true;
  void handleTapCancelled() => isPointerDown.value = false;

  void handleHorizontalSwipeUpdate(DragUpdateDetails details) {
    print(details);
    if (swipeReleaseAnim.isAnimating) swipeReleaseAnim.stop();
    if (details.delta.dy > 0) {
      swipeAmt.value = 0;
    } else {
      isPointerDown.value = true;
      double value = (swipeAmt.value - details.delta.dy / _pullToViewDetailsThreshold).clamp(0, 1);
        if (value== 1.0) {
          onSwipeComplete();
      }
    }
    //print(_swipeUpAmt.value);
  }

  /// Utility method to wrap a couple of ValueListenableBuilders and pass the values into a builder methods.
  /// Saves the UI some boilerplate when subscribing to changes.
  Widget buildListener(
      {required Widget Function(double swipeUpAmt, bool isPointerDown, Widget? child) builder, Widget? child}) {
    return ValueListenableBuilder<double>(
      valueListenable: swipeAmt,
      builder: (_, swipeAmt, __) => ValueListenableBuilder<bool>(
        valueListenable: isPointerDown,
        builder: (_, isPointerDown, __) {
          return builder(swipeAmt, isPointerDown, child);
        },
      ),
    );
  }

  /// Utility method to wrap a gesture detector and wire up the required handlers.
  Widget wrapGestureDetector(Widget child, {Key? key}) => Semantics(
        button: false,
        child: GestureDetector(
            key: key,
            onTapDown: (_) {
              handleTapDown();
            },
            onTapUp: (_) => handleTapCancelled(),
            onHorizontalDragUpdate: handleHorizontalSwipeUpdate,
            behavior: HitTestBehavior.translucent,
            child: child),
      );
}
