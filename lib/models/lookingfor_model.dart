import 'package:flutter/material.dart';

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