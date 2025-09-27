import 'package:image_picker/image_picker.dart';

class UserProfile {
  final String id;
  final String name;
  final String age;            
  final String gender;       
  final String bio;          
  final List<XFile> imageUrls;
  final XFile selfieImageUrl; 
  final Set<String> interests;

  const UserProfile({
    required this.id,
    required this.name,           
    required this.age,           
    required this.gender,      
    required this.bio,            
    required this.imageUrls,      
    required this.selfieImageUrl, 
    required this.interests,      
  });
}