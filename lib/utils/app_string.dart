
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:flutter/material.dart';

class AppStrings {
  static const String forgotPassword = "Forgot Password";
  static const String login = "Sign In";
  static const String signup = "Sign Up";
  static const String email = "Email";
  static const String password = "Password";
  static const String dontaccount = "Don't have an account?";
  static const String welcomeback = "Welcome Back!";
  static const String createAnAcc = "Create an Account";
  static const String name = "Name";
  static const String contactno = "Contact No";
  static const String conformpassword = "Confirm Password";
  static const String alreadycc = "Already have an account";
  static const String lSuccessMsg = "Successfully logged in";
  static const String userSetup = "Your account has been set up successfully";
  static const String cancel = "cancel";
  static const conform = "Yes, Confirm";
  static const logout = "Logout";
  static const logoutContent = "Are you sure you want to logout?";
  static const logoutS = "Logout successful";
  static const logoutF = "Logout failed";
 static final List<String> genders = ["Male", "Female", "Other"];
 static const createdAcc = "Account registered";
  static const vault = "Vault";
  static const updateMsg = "Updated";
  static const addMsg = "Added";
    static const delete = "Are you sure you want to delete?";
    static const continuePh = "Continue with Phone";
    static const continueG = "Continue with Google";
    static const continueE = "Continue with Email";
    static const enterValidNo = "Please enter a valid phone number.";
    static const phVerified = "Phone number verified!";
    static const enterNo = "Please enter your phone number";
    static final List<Map<String, String>> onboardingData = [
    {
      "title": "Find Your Match ❤️",
      "subtitle": "Swipe and discover people nearby who share your interests.",
    },
    {
      "title": "Chat Instantly 💬",
      "subtitle": "Start conversations and make meaningful connections in real-time.",
    },
    {
      "title": "Safe & Secure 🔒",
      "subtitle": "Your privacy and safety are our top priority.",
    },
  ];
 static final List<String> allInterests = const [
    'Travel', 'Photography', 'Movies', 'Gaming', 'Music', 'Art',
    'Cooking', 'Reading', 'Fitness', 'Dancing', 'Sports', 'Tech'
  ];
  static final List<LookingForModel> lookingForItems = [
    LookingForModel(keyValue: 'casual', title: 'Casual', description: "Let's take it easy and see where things go", icon: Icons.favorite_border, isSelected: false),
    LookingForModel(keyValue: 'long_term', title: 'Long-term', description: 'Ready for a genuine connection', icon: Icons.favorite, isSelected: false),
    LookingForModel(keyValue: 'virtual', title: 'Virtual', description: "Here for a good time, online. Let's chat!", icon: Icons.chat_bubble_outline, isSelected: false),
    LookingForModel(keyValue: 'non_monogamy', title: 'Non-monogamy', description: 'Ethically, lovingly, consensually', icon: Icons.group_outlined, isSelected: false),
    LookingForModel(keyValue: 'anything_but_boring', title: 'Anything but boring', description: 'Looking for something exciting', icon: Icons.mood_outlined, isSelected: false),
  ];
}
