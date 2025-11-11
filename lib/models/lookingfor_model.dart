import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LookingForModel {
  final String keyValue;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;

  LookingForModel({required this.keyValue, required this.title, required this.description, required this.icon, required this.isSelected});

  factory LookingForModel.fromJson(Map<String, dynamic> json) {
    final IconData icon = _getIconFromKeyValue(json['keyValue'] as String? ?? '');
    
    return LookingForModel(
      keyValue: json['keyValue'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: icon,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  static List<LookingForModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => LookingForModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }


static IconData _getIconFromKeyValue(String keyValue) {
  switch (keyValue) {
    case 'casual':
      return Icons.favorite_border;
    case 'long_term':
      return Icons.favorite;
    case 'virtual':
      return Icons.chat_bubble_outline;
    case 'non_monogamy':
      return Icons.group_outlined;
    case 'anything_but_boring':
      return Icons.mood_outlined;
  
    case 'cosplay':
      return Icons.theater_comedy;
    case 'cuddles':
      return Icons.favorite; 
    case 'kisses':
      return FontAwesomeIcons.faceKiss;
    case 'massage':
      return Icons.self_improvement;
    case 'music':
      return Icons.music_note;
    case 'being_watched':
      return Icons.visibility;
    case 'literature':
      return Icons.menu_book;
    case 'film_buff':
      return Icons.local_movies;
    case 'into_feet':
      return Icons.directions_walk;
    case 'scents':
      return Icons.air;
    case 'oral_sex':
      return Icons.tag_faces;
    case 'biting':
      return Icons.bug_report;
    case 'bushes':
      return Icons.cut;
    case 'slowmance':
      return Icons.pause_circle_filled;
    case 'fantasies':
      return Icons.lightbulb_outline;
    case 'dirty_talk':
      return Icons.chat_bubble_outline; 
    case 'sapiosexuality':
      return Icons.psychology_outlined;
    case 'sexting':
      return Icons.message_outlined;
    case 'breakfast':
      return Icons.local_cafe_outlined;
    case 'hotel':
      return Icons.hotel_outlined;
    case 'feminism':
      return Icons.flag_outlined;
    case 'im_a_dom':
      return Icons.control_point;
    case 'im_a_sub':
      return Icons.lock_open_outlined;
    case 'switch':
      return Icons.change_circle_outlined;
    case 'love_is_love':
      return Icons.favorite_border;
    case 'spanking':
      return Icons.flash_on;
    case 'vintage':
      return Icons.access_time;
    case 'drag_magic':
      return FontAwesomeIcons.crown;
    case 'gender_play':
      return Icons.transgender;
    case 'stand_up_comedy':
      return Icons.mic_external_on_outlined;
    case 'dry_dating':
      return FontAwesomeIcons.mugHot;
    case 'wellness_vibes':
      return FontAwesomeIcons.leaf;
    case 'been_to_therapy':
      return FontAwesomeIcons.brain;
    case 'nerdy_stuff':
      return FontAwesomeIcons.microscope;
    case 'blindfold':
      return FontAwesomeIcons.eyeSlash;
    case 'tattoo_piercing':
      return FontAwesomeIcons.paintBrush;
    case 'outdoor_bangs':
      return FontAwesomeIcons.tree;
    case 'vanilla':
      return FontAwesomeIcons.circle;
    case 'artsy_dates':
      return FontAwesomeIcons.image;
    case 'lets_dance':
      return FontAwesomeIcons.shoePrints;
    case 'gaming':
      return FontAwesomeIcons.gamepad;
    case 'anime':
      return FontAwesomeIcons.faceGrinHearts;
    case 'board_games':
      return FontAwesomeIcons.diceD20;
          default:
      return Icons.favorite_border;
  }
}

  Map<String, dynamic> toJson() {
    return {
      'keyValue': keyValue,
      'title': title,
      'description': description,
      'isSelected': isSelected,
      'icon': icon.codePoint,
    };
  }

  LookingForModel copyWith({
    String? keyValue,
    String? title,
    String? description,
    IconData? icon,
    bool? isSelected,
  }) {
    return LookingForModel(
      keyValue: keyValue ?? this.keyValue,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}