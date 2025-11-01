import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/text_feild.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final String text;
  final Widget? icon;
  final FontWeight fontWeight;
  void Function()? onTap;
   CustomButton({
    super.key,
     this.color = Kred,
     this.width = 80,
     this.height = 40,
     required this.text,
     this.onTap,
     this.icon,
     this.fontWeight = FontWeight.w600
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
      
        child: Center(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(text: text, size: 14,fontWeight: fontWeight,),
            if(icon != null) icon!,
          ],
        )),
      ),
    );
  }
}
