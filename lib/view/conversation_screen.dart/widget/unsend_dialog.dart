import 'package:flutter/material.dart';

void showUnsendDialog(BuildContext context,void Function()? onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0), 
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              ListTile(
                leading: const Icon(
                  Icons.undo,
                  color: Colors.red,
                ),
                title: const Text(
                  'Unsend',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: onTap
              ),
            ],
          ),
        );
      },
    );
  }