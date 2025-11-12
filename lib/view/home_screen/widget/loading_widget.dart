import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FadeShimmer(
              height: 550,
              width: double.infinity,
              radius: 20,
              millisecondsDelay: 20,
              fadeTheme: FadeTheme.dark,
            ),
            FadeShimmer(
              height: 100,
              width: double.infinity,
              radius: 20,
              fadeTheme: FadeTheme.dark,
              millisecondsDelay: 20,
            ),
          ],
        ),
      ),
    );
  }
}
