   class SportsFieldApi {
     final int id;
     final String turfName;
     final String location;
     final double rating;
     final int courts;
     final String imageUrl;
     final int discounts;
     final String category;

     SportsFieldApi({
       required this.id,
       required this.turfName,
       required this.location,
       required this.rating,
       required this.courts,
       required this.imageUrl,
       required this.discounts,
       required this.category,
     });

     factory SportsFieldApi.fromJson(Map<String, dynamic> json) {
       return SportsFieldApi(
         id: json['id'],
         turfName: json['turfName'],
         location: json['location'],
         rating: json['rating'],
         courts: json['courts'],
         imageUrl: json['imageUrl'],
         discounts: json['discounts'],
         category: json['category'],
       );
     }
   }