
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class FavLoadingWidget extends StatelessWidget {
  const FavLoadingWidget({
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
            GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
              itemBuilder: (context, index) {
                return FadeShimmer(
                  width: double.infinity,
                  height: 200,
                  radius: 20,
                  millisecondsDelay: index%2==0?500:20,
                  fadeTheme: FadeTheme.dark,
                );
              },
              itemCount: 4,
            ),
          ],
        ),
      ),
    );
  }
}
