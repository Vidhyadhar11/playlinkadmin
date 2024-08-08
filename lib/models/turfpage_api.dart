class SportsFieldApi {
  final String imageUrl;
  final String category;
  final String turfName;
  final int courts; 
  final String location;
  final String description;
  final List<String> amenities;
  final double rating;
  final List<Map<String, dynamic>> slots;
  final int discounts;
  final String id;
  bool isLiked;

  SportsFieldApi({
    required this.imageUrl,
    required this.category,
    required this.turfName,
    required this.courts,
    required this.location,
    required this.description,
    required this.amenities,
    required this.rating,
    required this.slots,
    required this.discounts,
    required this.id,
    this.isLiked = false,
  });

  factory SportsFieldApi.fromsnapshot(Map<String, dynamic> json) {
    // Handle the 'amenties' field which might be a string or an iterable
    List<String> amenities = [];
    if (json['amenties'] != null) {
      if (json['amenties'] is Iterable) {
        for (var amenityList in json['amenties']) {
          if (amenityList is Iterable) {
            amenities.addAll(List<String>.from(amenityList));
          } else {
            amenities.add(amenityList.toString());
          }
        }
      } else if (json['amenties'] is String) {
        amenities.add(json['amenties']);
      }
    }

    return SportsFieldApi(
      imageUrl: json['images'] ?? '',
      category: json['category'] ?? '',
      turfName: json['turfname'] ?? '',
      courts: json['court'] != null ? int.parse(json['court'].toString()) : 0,
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      amenities: amenities,
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      slots: json['slots'] != null ? List<Map<String, dynamic>>.from(json['slots']) : [],
      discounts: json['discounts'] != null ? int.parse(json['discounts'].toString()) : 0,
      id: json['_id'] ?? '',
      isLiked: false,
    );
  }

  static SportsFieldApi? fromJson(Map<String, dynamic> data) {
    return data != null ? SportsFieldApi.fromsnapshot(data) : null;
  }
}
