class RecipieDetails{
    final String? uid;
    final String dateUpdated;
    final String? category;
    final String? postedby;
    final String? quantity;
    final String? name;
    final String? cityLocation;
    final String? imageAddress;
    final List<String> requestedby;
    final String? pickedUpBy;
    final String? distancebtw;
    final double deliveryId;  
    final bool? isAvailable;
    double? rating;
    int totalfollowers;
    bool isfollowing;
    
    RecipieDetails(this.uid,this.category,this.cityLocation,this.dateUpdated,this.deliveryId,this.imageAddress,this.isAvailable,this.name,this.pickedUpBy,this.distancebtw,this.postedby,this.quantity,this.requestedby,this.totalfollowers,this.isfollowing,this.rating);

}

