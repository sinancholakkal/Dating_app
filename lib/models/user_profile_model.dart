import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends Equatable{
  final String id;
  final String name;
  final String age;            
  final String gender;       
  final String bio;          
   List<XFile>? imageUrls;
   XFile? selfieImageUrl; 
  final Set<String> interests;
  List<String>?getImages;
  String?getSelfie;
  final GeoPoint? currentGeoPoint;
    final double? distanceInMeters; 
    final List<Map<String, dynamic>> lookingFor;

   UserProfile({
    required this.lookingFor,
    required this.id,
    required this.name,           
    required this.age,           
    required this.gender,      
    required this.bio,            
     this.imageUrls,      
     this.selfieImageUrl, 
    required this.interests,     
    this.getImages,
    this.getSelfie, 
    this.currentGeoPoint,
    this.distanceInMeters
  });
  UserProfile copyWith({
    List<Map<String, dynamic>>? lookingFor,
    String? id,
    String? name,
    String? age,
    String? gender,
    String? bio,
    List<XFile>? imageUrls,
    XFile? selfieImageUrl,
    Set<String>? interests,
    List<String>? getImages,
    String? getSelfie,
    GeoPoint? currentGeoPoint,
    double? distanceInMeters,
  }) {
    return UserProfile(
      lookingFor: lookingFor?? this.lookingFor,
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      imageUrls: imageUrls ?? this.imageUrls,
      selfieImageUrl: selfieImageUrl ?? this.selfieImageUrl,
      interests: interests ?? this.interests,
      getImages: getImages ?? this.getImages,
      getSelfie: getSelfie ?? this.getSelfie,
      currentGeoPoint: currentGeoPoint ?? this.currentGeoPoint,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
    );
  }
    @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        bio,
        imageUrls,
        selfieImageUrl,
        interests,
      ];
      
}