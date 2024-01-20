import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharebowl/models/recipiemaster.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// for

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String uploadPost(String uid,String userId, String category,String quantity,String name, String cityLocation, List<String> selected, String description, String imagePosted,String? username, String? photoURL, bool isdelivered, bool isAvailable) {
String res = "Some error occurred";
    try {
      RecipieDetails recipieDetails=RecipieDetails(
      uid: uid,
      category: category,
      cityLocation: cityLocation,
      description: description,
      dateUpdated: DateTime.now().toString(),
      imageAddress: imagePosted,
      isAvailable: isAvailable,
      name: username,
      pickedUpBy:"",
      postedby: userId,
      quantity: quantity,
      requestedby:[],
      comments: [],
        );
          
      _firestore.collection('Recipie_Master').doc(uid).set(recipieDetails.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;

  }


  // Future<String> uploadPost(String description, Uint8List file, String uid,
  //     String username, String profImage) async {
  //   // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
  //   String res = "Some error occurred";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('Memes', file, true);
  //    String docId=FirebaseFirestore.instance.collection("collection_name").doc().id;
  //       List<RecipieDetails> listDataSource=<RecipieDetails>[];
  //          FirebaseFirestore.instance.collection('recipie_master').doc(docId).set({
  //             'uid':docId,
  //             'dateupdated':DateTime.now().toString(),
  //             'category':"veg",
  //             'postedby':widget.currentUser.uid,
  //             'quantity':quantityController.text,
  //             'recipiename':foodnameController.text,
  //             'citylocation':'',
  //             'ingredients':selected,
  //             'descyourself':desccontroller.text,
  //             'imageaddress':await image?.readAsBytes(),
  //             'deliveryid':'',
  //             'username':widget.currentUser.displayName,
  //             'imageUrl':widget.currentUser.photoURL,
  //             'isdelivered':false,
  //             'isavailable':true
  //           },SetOptions(merge: true));
          
  //     _firestore.collection('Memes').doc(postId).set(post.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {

        // if the likes list contains the user uid, we need to remove it
      final documentReference = FirebaseFirestore.instance.collection('posts').doc(postId).collection("comments").doc();
      final commentId=documentReference.id;
        _firestore
            .collection('Memes')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('Memes').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

  
   List<RecipieDetails> recipiesFeed(){
    List<RecipieDetails> data=[];FirebaseAuth auth=FirebaseAuth.instance;
     _firestore.collection('Recipie_Master').where('isAvailable',isEqualTo: true).where('postedby',isNotEqualTo: auth.currentUser?.uid).snapshots().listen((event) => event.docs.forEach((element) { 
        if(element.exists){
        data.add(RecipieDetails(
          uid: element.data()["uid"],
      category: element.data()["category"],
      description:element.data()["description"],
      cityLocation: element.data()["cityLocation"],
      dateUpdated: element.data()["dateUpdated"],
      imageAddress: element.data()["imageAddress"],
      isAvailable: element.data()["isAvailable"],
      name: element.data()['name'],
      pickedUpBy:element.data()['pickedUpBy'],
      postedby: element.data()["postedby"],
      quantity: element.data()['quantity'],
      requestedby:element.data()['requestedby'],
      comments: element.data()['comments']
          ));
        }
       }) 
      );
    return data;
   }


}




class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName,String docId, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    
    Reference ref =_storage.ref().child(childName);
    if(isPost) {
      ref = ref.child(docId);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  
  // for picking up image from gallery
captureImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('No Image Selected');
}

}