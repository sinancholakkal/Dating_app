import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.appGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: double.infinity,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Color(0xff242424),
                      borderRadius: BorderRadius.circular(16),
                    ),
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
          ),
        ),
      ),
    );
  }
}
