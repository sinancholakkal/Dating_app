import 'package:dating_app/models/lookingfor_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      "subtitle":
          "Start conversations and make meaningful connections in real-time.",
    },
    {
      "title": "Safe & Secure 🔒",
      "subtitle": "Your privacy and safety are our top priority.",
    },
  ];
  static final List<String> allInterests = const [
    'Travel',
    'Photography',
    'Movies',
    'Gaming',
    'Music',
    'Art',
    'Cooking',
    'Reading',
    'Fitness',
    'Dancing',
    'Sports',
    'Tech',
  ];
  static final List<LookingForModel> lookingForItems = [
    LookingForModel(
      keyValue: 'casual',
      title: 'Casual',
      description: "Let's take it easy and see where things go",
      icon: Icons.favorite_border,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'long_term',
      title: 'Long-term',
      description: 'Ready for a genuine connection',
      icon: Icons.favorite,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'virtual',
      title: 'Virtual',
      description: "Here for a good time, online. Let's chat!",
      icon: Icons.chat_bubble_outline,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'non_monogamy',
      title: 'Non-monogamy',
      description: 'Ethically, lovingly, consensually',
      icon: Icons.group_outlined,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'anything_but_boring',
      title: 'Anything but boring',
      description: 'Looking for something exciting',
      icon: Icons.mood_outlined,
      isSelected: false,
    ),
    
  ];

  static final List<LookingForModel> turnOns = [
    LookingForModel(
      keyValue: 'cosplay',
      title: 'Cosplay',
      description: 'We could be heroes, me and you',
      icon: Icons.theater_comedy,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'cuddles',
      title: 'Cuddles',
      description: "Who doesn't like some aftercare?",
      icon: Icons.favorite,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'kisses',
      title: 'Kisses',
      description: 'Mouth to mouth is exactly how I want it',
      icon: FontAwesomeIcons.faceKiss,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'massage',
      title: 'Massage',
      description: 'My superpower is being good with my hands',
      icon: Icons.self_improvement,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'music',
      title: 'Music',
      description: 'Techno, indie, rock - pick our soundtrack',
      icon: Icons.music_note,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'being_watched',
      title: 'Being watched',
      description: "Sit and relax. We'll put on a show!",
      icon: Icons.visibility,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'literature',
      title: 'Literature',
      description: 'Talk nerdy to me...',
      icon: Icons.menu_book,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'film_buff',
      title: 'Film buff',
      description: "Passion for film, popcorn's on me",
      icon: Icons.local_movies,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'into_feet',
      title: 'Into feet',
      description: 'The way to my heart is feet',
      // Suggestion for Feet: closest match to a foot/step
      icon: Icons.directions_walk,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'scents',
      title: 'Scents',
      description: 'Perfume, lotion, scents - little details turn me on',
      // Suggestion for Scents/Perfume: bottle or air-related
      icon: Icons.air,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'oral_sex',
      title: 'Oral sex',
      description: 'I like to keep my mouth occupied',
      // Suggestion for Mouth/Lips: most expressive face/symbol for feeling
      icon: Icons.tag_faces,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'biting',
      title: 'Biting',
      description: "Let's do it vampire-style",
      // Suggestion for Biting/Teeth: tooth-like symbol
      icon: Icons.bug_report, // The closest tooth/sharp object
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'bushes',
      title: 'Bushes',
      description: 'Nothing is more attractive than your natural hairstyle!',
      // Suggestion for Hair/Bushes: haircut or abstract texture
      icon: Icons.cut,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'slowmance',
      title: 'Slowmance',
      description: "Let's take the scenic route to intimacy",
      // Suggestion for Slow/Pace: a turtle is too specific; a pause/stop symbol works
      icon: Icons.pause_circle_filled,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'fantasies',
      title: 'Fantasies',
      description: 'Sensual daydreaming requires creativity. I have it!',
      // Suggestion for Fantasies/Daydreaming/Imagination
      icon: Icons.lightbulb_outline,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'dirty_talk',
      title: 'Dirty Talk',
      description: 'Thinking about it - great. Talking about it? Even better',
      // Suggestion for Talking/Audio/Whisper: ear or conversation bubble
      icon: Icons.chat_bubble_outline,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'sapiosexuality',
      title: 'Sapiosexuality',
      description: 'I have a weakness for clever minds',
      // Suggestion for Clever Minds/Intelligence: brain or lightbulb
      icon: Icons.psychology_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'sexting',
      title: 'Sexting',
      description: 'Virtual encounter with a not-so-virtual finish',
      // Suggestion for Sexting/Virtual Encounter: phone or message
      icon: Icons.message_outlined,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'breakfast',
      title: 'Breakfast',
      description: 'I prefer mine sweet. Just like you',
      // Suggestion for Breakfast/Food/Sweet: food symbol or coffee/tea
      icon: Icons.local_cafe_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'hotel',
      title: 'Hotel',
      description: 'Room service with consent',
      // Suggestion for Hotel/Room/Privacy: bed or a door
      icon: Icons.hotel_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'feminism',
      title: 'Feminism',
      description: 'Let\'s dismantle the patriarchy together',
      // Suggestion for Feminism/Power/Equality: flag or power symbol
      icon: Icons.flag_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'im_a_dom',
      title: 'I\'m a dom',
      description: 'I\'m in charge today. Get on your knees!',
      // Suggestion for Being in Charge/Control: a crown or a strong hand
      icon: Icons.control_point,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'im_a_sub',
      title: 'I\'m a sub',
      description: 'I want to lose control entirely tonight',
      // Suggestion for Sub/Control: the opposite of control, or binding/following
      icon: Icons.lock_open_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'switch',
      title: 'Switch',
      description: 'To whip or be whipped, that is the question',
      // Suggestion for Switch/Change/Versatility: a toggle or arrows
      icon: Icons.change_circle_outlined,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'love_is_love',
      title: 'Love is Love',
      description: 'Celebrating LGBTQ+ pride and beautiful diversity',
      // Suggestion for Pride/Diversity: a rainbow or heart
      icon: Icons.favorite_border,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'spanking',
      title: 'Spanking',
      description: 'Let\'s talk about intensity',
      // Suggestion for Spanking/Intensity: a lightning bolt or strike
      icon: Icons.flash_on,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'vintage',
      title: 'Vintage',
      description: 'Let\'s thrift and flirt',
      // Suggestion for Vintage/Thrifting/Old style: classic item or a clock
      icon: Icons.access_time,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'drag_magic',
      title: 'Drag Magic',
      description: 'Admiring queens, comedy and dramatic flair',
      // Suggestion for Queens/Dramatic Flair/Performance: a crown or a stage mask
      icon: FontAwesomeIcons.crown, // A good representation of royalty/queens
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'gender_play',
      title: 'Gender play',
      description: 'Vibing with fluidity and crossdressing freedom',
      // Suggestion for Fluidity/Gender: a symbol combining male and female
      icon: Icons.transgender,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'stand_up_comedy',
      title: 'Stand-up comedy',
      description: 'Two single people walk into a bar...',
      // Suggestion for Comedy/Performance/Talking: microphone or stage
      icon: Icons.mic_external_on_outlined,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'dry_dating',
      title: 'Dry dating',
      description: '100% presence',
      // Icon: A cup/tea/coffee symbol for a dating setting without alcohol
      icon: FontAwesomeIcons.mugHot,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'wellness_vibes',
      title: 'Wellness vibes',
      description: 'Turned on by (your) breathwork',
      // Icon: Air/Breathing/Relaxation/Yoga
      icon: FontAwesomeIcons.leaf,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'been_to_therapy',
      title: 'Been to therapy',
      description: 'Mindful relationship with myself & others',
      // Icon: Brain/Mind/Mental Health
      icon: FontAwesomeIcons.brain,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'nerdy_stuff',
      title: 'Nerdy stuff',
      description: 'Your secret lab or mine?',
      // Icon: Science/Microscope/Lab
      icon: FontAwesomeIcons.microscope,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'blindfold',
      title: 'Blindfold',
      description: 'Eyes wide shut',
      // Icon: Blind/Eyes/Mask
      icon: FontAwesomeIcons.eyeSlash,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'tattoo_piercing',
      title: 'Tattoo & Piercing',
      description: 'Body art gets me going',
      // Icon: Tattoo needle or abstract art symbol
      icon: FontAwesomeIcons.paintBrush,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'outdoor_bangs',
      title: 'Outdoor bangs',
      description: 'Fresh air. Dirty thoughts.',
      // Icon: Nature/Outdoors
      icon: FontAwesomeIcons.tree,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'vanilla',
      title: 'Vanilla',
      description: 'A classic one, please',
      // Icon: A circle or simple checkmark for 'classic/simple'
      icon: FontAwesomeIcons.circle,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'artsy_dates',
      title: 'Artsy dates',
      description: 'Let\'s make sense of the world through art?',
      // Icon: Art/Picture Frame
      icon: FontAwesomeIcons.image,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'lets_dance',
      title: 'Let\'s dance',
      description: 'Put on your red shoes and dance the blues',
      // Icon: Dancing/Music/Shoes
      icon: FontAwesomeIcons.shoePrints,
      isSelected: false,
    ),
    LookingForModel(
      keyValue: 'gaming',
      title: 'Gaming',
      description: 'Forget the tutorial. Ready for mischief and play?',
      // Icon: Game Controller/Console
      icon: FontAwesomeIcons.gamepad,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'anime',
      title: 'Anime',
      description: 'You look anime-zing',
      // Icon: Face/Stylized Eye (often used for anime/manga)
      icon: FontAwesomeIcons.faceGrinHearts,
      isSelected: false,
    ),

    LookingForModel(
      keyValue: 'board_games',
      title: 'Board games',
      description: 'Ready to play with magic',
      // Icon: Dice/Tabletop game
      icon: FontAwesomeIcons.diceD20,
      isSelected: false,
    ),
  ];
}
