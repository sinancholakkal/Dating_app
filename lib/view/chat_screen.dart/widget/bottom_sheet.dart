import 'dart:developer';

import 'package:dating_app/models/chat_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

void showActionSheetUnbloc(BuildContext context,{required void Function() onPressed}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      
      message: Text(
        'Select an action you would like to take.',
        style: GoogleFonts.poppins(),
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: onPressed,
          
          child: const Text('Unblock'),
        ),
        
      ],

      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    ),
  );
}

