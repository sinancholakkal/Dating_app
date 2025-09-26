import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/home_screen/tab/home_screen.dart';
import 'package:dating_app/view/home_screen/tab/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_cupertino_tabbar/bottom_cupertino_tabbar.dart';

// Make sure to import your app's color constants

class EasyTabbar extends StatefulWidget {
  const EasyTabbar({super.key});

  @override
  State<EasyTabbar> createState() => _EasyTabbarState();
}

class _EasyTabbarState extends State<EasyTabbar> {
  @override
  Widget build(BuildContext context) {
    return BottomCupertinoTabbar(
      activeColor: primary,
      inactiveColor: kWhite70,
      
      // --- Style Update ---
      backgroundColor: bgcard.withOpacity(0.8), // Use your dark card color with some transparency
      
      overrideIconsColor: true,
      onTabPressed: (index, model, nestedNavigator) {
        if (index != model.currentTab) {
          model.changePage(index);
        } else {
          if (nestedNavigator[index]?.currentContext != null) {
            Navigator.of(nestedNavigator[index]!.currentContext!)
                .popUntil((route) => route.isFirst);
          }
        }
      },
      notificationsBadgeColor: Colors.transparent,
      firstActiveIndex: 0,
      children: const [
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          page: HomeScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            icon: Icon(Icons.chat, size: 30),
            label: "Chat",
          ),
          page: Scaffold(
            body: Center(child: Text("Chat Screen")),
          ),
        ),

        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            
            icon: Icon(Icons.person, size: 30),
            label: "Profile",
            
          ),
          page: Scaffold(
            body: ProfileScreen(),
          ),
        )
      ],
    );
  }
}