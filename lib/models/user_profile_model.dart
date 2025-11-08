import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/lookingfor_model.dart';
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

   UserProfile({
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
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      imageUrls: null, // XFile objects are not serialized from JSON
      selfieImageUrl: null, // XFile objects are not serialized from JSON
      interests: Set<String>.from(json['interests'] ?? []),
      getImages: json['images'] != null ? List<String>.from(json['images']) : null,
      getSelfie: json['selfie'] as String?,
      currentGeoPoint: json['currentGeoPoint'] as GeoPoint?,
      distanceInMeters: json['distanceInMeters'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'bio': bio,
      'interests': interests.toList(),
      'images': getImages,
      'selfie': getSelfie,
      'currentGeoPoint': currentGeoPoint,
      'distanceInMeters': distanceInMeters,
    };
  }

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