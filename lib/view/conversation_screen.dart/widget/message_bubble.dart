import 'package:dating_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  const MessageBubble({required this.isMe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child:text.startsWith("https://firebasestorage.googleapis.com")?Container(
        width: 180,
        height: 230,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(20)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: InstaImageViewer(child: Image.network(text,fit: BoxFit.cover,))),
      ): Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? primary : kWhite.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe
                ? const Radius.circular(20)
                : const Radius.circular(4),
            bottomRight: isMe
                ? const Radius.circular(4)
                : const Radius.circular(20),
          ),
        ),
        child: Text(text, style: GoogleFonts.poppins(color: kWhite)),
      ),
    );
  }
}