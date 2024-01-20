import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharebowl/providers/api.dart';
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

class _SellFoodState extends State<SellFood>{
   Uint8List? image;

    late CameraController _controller;
   final FirebaseStorage _storage = FirebaseStorage.instance;

  List<String> selected = [];

  final _formKey = GlobalKey<FormState>();
    TextEditingController foodnameController = TextEditingController();
    TextEditingController desccontroller = TextEditingController();

    TextEditingController quantityController = TextEditingController();
    List<String> ingredients=[];
    Map<String,dynamic> ingredientsList={};
    String? _category="";
       
 setSelectedRadioTile(String? val) {
    setState(() {
      _category = val;
    });
  }
  void clearImage() {
    setState(() {
      image = null;
    });
  }

  @override
  void initState(){
    super.initState();
    _controller = CameraController(
    widget.camera,
    ResolutionPreset.max
    );
    setState(() {
      FirebaseFirestore.instance.collection("Ingredients").doc("ingredientsmaster").snapshots().listen((event) =>ingredientsList=event.data()!);
    });
  }

    @override
    void dispose() {
    super.dispose();
    _controller.dispose();
    }

    
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await  StorageMethods().captureImage(ImageSource.camera);
                  setState(() {
                    image = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await StorageMethods().captureImage(ImageSource.gallery);
                  setState(() {
                    image = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: (
          Form(
  key: _formKey,child:Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
  TextFormField(
 controller: foodnameController,
 decoration: const InputDecoration(
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
     return null;
  
   },
 ), 
   TextFormField(
 controller: quantityController,
 decoration: const InputDecoration(
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
     return null;
    }
   
   ),
   Row(
     children: [
   Flexible(
    flex: 1,
     child: RadioListTile(
     toggleable: true,
     value: "Male",
     groupValue: _category,
     title: const Text("Veg"),
     onChanged: (dynamic val) {
      setSelectedRadioTile(val);
     },
     activeColor: Colors.black,
     selected: true,
     ),
   ),
    
   Flexible(
    flex: 1,
     child: RadioListTile(
     toggleable: true,
     value: "Female",
     groupValue: _category,
     title: const Text("Non-Veg"),
     onChanged: (dynamic val) {
      setSelectedRadioTile(val);
     },
     activeColor: Colors.black,
     selected: false,
     ),
   ),],),
FutureBuilder(
      future: futureloaderdelay(),//it will return the future type result
            builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(5),
        height: 90,
        width: 300,
        child: DropDownMultiSelect(
          onChanged: (List<String> x) {
            setState(() {
          selected =x;
            });
          },
          options: ingredientsList.keys.toList(),
          selectedValues: selected,
          whenEmpty: 'Select Ingredients',
        ),
    );
            }
),
Container(
  height: 60,
  width: 350,
  alignment: Alignment.centerLeft,
  padding: const EdgeInsets.only(left: 12),
  decoration: BoxDecoration(
    color: Colors.black12,
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      width: .5,
    ),
  ),
  child: TextFormField(
controller: desccontroller,
decoration: const InputDecoration(
  border: InputBorder.none,
 labelText: "what's on your mind?",),
  
  ),
),

image == null? RawMaterialButton(
              hoverColor: Colors.amberAccent,
            fillColor: Colors.black12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            constraints: const BoxConstraints.tightFor(height: 50.0,width: 150.0),
            elevation:4.0,
            child: const Text("Add Photo"),
             onPressed: ()  => _selectImage(context),
          ):
           Stack(
             children: [
               SizedBox(
                          height: 150.0,
                          width: 150.0,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(image!),
                              )),
                            ),
                          ),
                        ),
                        ElevatedButton(onPressed: clearImage, child: const Text("Cancel"))
             ],
           ),
RawMaterialButton(
            fillColor: Colors.red[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            constraints: const BoxConstraints.tightFor(height: 50.0,width: 150.0),
            elevation:4.0,
            child: const Text("Click to Post"),
             onPressed: () async {
      try {
        String docId=FirebaseFirestore.instance.collection("Recipie_Master").doc().id;
        String imagePosted="";
        if(image!=null){
         imagePosted=await StorageMethods().uploadImageToStorage('Recipies',docId,image!,true);  
        }
        
        String response=FireStoreMethods().uploadPost(docId,widget.currentUser.uid,"veg",quantityController.text,foodnameController.text,'',selected,desccontroller.text,imagePosted,widget.currentUser.displayName,widget.currentUser.photoURL,false,true);
      if(response=='success'){
        showSnackBar(context,'Posted!');
        setState(() {
        });
      }
      else{
        showSnackBar(context,'Some Error Occured!');
      }
          }
      //_storage.ref('recipies/$widget.currentUser.uid').putData(await image.readAsBytes());
        //FirebaseFirestore.instance.collection("Recipies").doc("image1").set({"data":image},SetOptions(merge: true));
   catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
             },
          ),                ],
          ),)),
      ),
    );
    
  }

   /// Utility method to wrap a gesture detector and wire up the required handlers.
 
  futureloaderdelay() {
            return Future.delayed(const Duration(milliseconds: 1000),);
        }
        showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
}

