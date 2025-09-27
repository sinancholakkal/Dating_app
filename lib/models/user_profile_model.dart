class UserProfile {
  final String id;
  final String name;
  final int age;            
  final String gender;       
  final String bio;          
  final List<String> imageUrls;
  final String selfieImageUrl; 
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