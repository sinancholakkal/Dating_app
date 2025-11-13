
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class NotiLoadingWidget extends StatelessWidget {
  const NotiLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: double.infinity  ,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff242424),
                      borderRadius: BorderRadius.circular(16),
                    ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeShimmer.round(size: 60, millisecondsDelay: 600, fadeTheme: FadeTheme.dark),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            FadeShimmer(height: 20, width: 130, radius: 20, millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                            FadeShimmer(height: 20, width: 160, radius: 20, millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                          ],
                        ),
                        FadeShimmer.round(size: 40, millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                        FadeShimmer.round(size: 40, millisecondsDelay: 20, fadeTheme: FadeTheme.dark),
                      ],
                     ),
                   ),
                  ),
                );
              },
              itemCount: 5,
            ),
          ],
        ),
      ),
    );
  }
}