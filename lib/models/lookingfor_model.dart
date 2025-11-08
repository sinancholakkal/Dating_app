import 'package:flutter/material.dart';

class LookingForModel {
  final String keyValue;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;

  LookingForModel({required this.keyValue, required this.title, required this.description, required this.icon, required this.isSelected});

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