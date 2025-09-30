import 'dart:developer';

import 'package:dating_app/services/request_services.dart';
import 'package:dating_app/state/chat_bloc/chat_bloc.dart';
import 'package:dating_app/state/request_bloc/request_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/chat_screen.dart/chat_screen.dart';
import 'package:dating_app/view/home_screen/home_screen.dart';
import 'package:dating_app/view/notification_screen.dart/notification_screen.dart';
import 'package:dating_app/view/profile_screen.dart/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_cupertino_tabbar/bottom_cupertino_tabbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: bgcard.withOpacity(0.8), 
      
      overrideIconsColor: true,
      onTabPressed: (index, model, nestedNavigator) {
        if (index != model.currentTab) {
          if(index==2){
            context.read<RequestBloc>().add(FetchRequestsEvent());
          }
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
          page: ChatListScreen(),
        ),

        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            
            icon: Icon(Icons.notifications, size: 30),
            label: "Notification",
            
          ),
          page: NotificationScreen(),
        ),
        BottomCupertinoTab(
          tab: BottomCupertinoTabItem(
            
            icon: Icon(Icons.person, size: 30),
            label: "Profile",
            
          ),
          page: Scaffold(
            body: ProfileScreen(),
          ),
        ),

        
      ],
    );
  }
}