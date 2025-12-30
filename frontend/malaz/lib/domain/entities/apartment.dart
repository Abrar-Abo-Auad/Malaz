import 'package:equatable/equatable.dart';

class Apartment extends Equatable {
  final int id;
  final int ownerId;
  final String status;
  final String title;
  final int price;
  final String city;
  final String governorate;
  final String address;
  final String description;
  final String type;
  final int rooms;
  final int bathrooms;
  final int bedrooms;
  final int area;
  final num rating;
  final int numberOfReviews;
  final String mainImageUrl;
  final bool isFav;

  Apartment({
    required this.id,
    required this.ownerId,
    required this.status,
    required this.title,
    required this.price,
    required this.city,
    required this.governorate,
    required this.address,
    required this.description,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.bedrooms,
    required this.area,
    this.rating=0,
    this.numberOfReviews=0,
    required this.mainImageUrl,
    this.isFav = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id,ownerId,status,title,price,city,governorate,address,description,type,rooms,bathrooms,bedrooms,area,rating,numberOfReviews,mainImageUrl,isFav];
}