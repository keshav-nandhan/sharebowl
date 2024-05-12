import 'package:cloud_firestore/cloud_firestore.dart';

class RecipieDetails{
    final String? uid;
    final String dateUpdated;
    final String? category;
    final String? description;
    final String? postedby;
    final String? quantity;
    final String? name;
    final String? cityLocation;
    final String? imageAddress;
    final requestedby;
    final String? pickedUpBy;
    final bool? isAvailable;
    final comments;
    
    //RecipieDetails(this.uid,this.category,this.cityLocation,this.dateUpdated,this.deliveryId,this.imageAddress,this.isAvailable,this.name,this.pickedUpBy,this.distancebtw,this.postedby,this.quantity,this.requestedby,this.totalfollowers,this.isfollowing,this.rating);
    RecipieDetails({required this.uid,required this.category,required this.description,required this.cityLocation,required this.dateUpdated,
    required this.imageAddress,required this.isAvailable,required this.name,required this.pickedUpBy,
    required this.postedby,required this.quantity,required this.requestedby,required this.comments});

    static RecipieDetails fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return RecipieDetails(
      uid: snapshot["uid"],
      category: snapshot["category"],
      description:snapshot["description"],
      cityLocation: snapshot["cityLocation"],
      dateUpdated: snapshot["dateUpdated"],
      imageAddress: snapshot["imageAddress"],
      isAvailable: snapshot["isAvailable"],
      name: snapshot['name'],
      pickedUpBy:snapshot['pickedUpBy'],
      postedby: snapshot["postedby"],
      quantity: snapshot['quantity'],
      requestedby:snapshot['requestedby'],
      comments: snapshot['comments']
    );
    
  }
  
   Map<String, dynamic> toJson() => {
      "uid": uid,
      "category": category,
      "description":description,
      "cityLocation": cityLocation,
      "dateUpdated": dateUpdated,
      "imageAddress": imageAddress,
      "isAvailable": isAvailable,
      "name": name,
      "pickedUpBy":pickedUpBy,
      "postedby": postedby,
      "quantity": quantity,
      "requestedby":requestedby,
      "comments": comments,
      };


}

