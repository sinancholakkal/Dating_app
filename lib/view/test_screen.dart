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
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Color(0xff242424),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: FadeShimmer(
                                height: 14,
                                width: double.infinity,
                                radius: 20,
                                millisecondsDelay: 20,
                                fadeTheme: FadeTheme.dark,
                              ),
                            ),
                            Expanded(
                              child: FadeShimmer(
                                height: 14,
                                width: double.infinity,
                                radius: 500,
                                millisecondsDelay: 20,
                                fadeTheme: FadeTheme.dark,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      FadeShimmer(
                                        height: 16,
                                        width: 140,
                                        radius: 20,
                                        millisecondsDelay: 20,
                                        fadeTheme: FadeTheme.dark,
                                      ),
                                      FadeShimmer(
                                        height: 35,
                                        width: 40,
                                        radius: 16,
                                        millisecondsDelay: 500,
                                        fadeTheme: FadeTheme.dark,
                                      ),
                                    ],
                                  ),
                                  FadeShimmer(
                                    height: 16,
                                    width: 140,
                                    radius: 20,
                                    millisecondsDelay: 20,
                                    fadeTheme: FadeTheme.dark,
                                  ),
                                ],
                              ),
                              Spacer(),
                              FadeShimmer(width: 50, height: 50, radius: 16, millisecondsDelay: 500, fadeTheme: FadeTheme.dark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
               
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff242424),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FadeShimmer.round(size: 45,  millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                        FadeShimmer.round(size: 50,  millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                        FadeShimmer.round(size: 45,  millisecondsDelay: 500, fadeTheme: FadeTheme.dark),
                        FadeShimmer.round(size: 50,  millisecondsDelay: 500, fadeTheme: FadeTheme.dark),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
