import 'dart:developer';

import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/state/user_actions_bloc/user_actions_bloc.dart';
import 'package:dating_app/state/user_bloc/user_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/interest_builder.dart';
import 'package:dating_app/view/widgets/privacy_blur_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemShowScreen extends StatefulWidget {
  final UserProfile userProfile;
  final int index;
  const ItemShowScreen({
    super.key,
    required this.userProfile,
    required this.index,
  });

  @override
  State<ItemShowScreen> createState() => _ItemShowScreenState();
}

class _ItemShowScreenState extends State<ItemShowScreen> {
  late int numberPhotos;
  int currentPhoto = 0;
  late UserProfile accUserProfile;
  @override
  void initState() {
    numberPhotos = widget.userProfile.getImages!.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is GetSuccessState) {
          accUserProfile = state.userProfile;
        }
      },
      child: Container(
        decoration: BoxDecoration(gradient: appGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Hero(
                            tag: "imageTag${widget.index}",
                            child: Stack(
                              children: [
                                //Image adding-----------
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      (MediaQuery.of(context).size.height *
                                          0.6) -
                                      25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        widget
                                            .userProfile
                                            .getImages![currentPhoto],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.3),
                                        ],
                                        stops: [0.0, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                                if (currentPhoto != 0)
                                  PrivacyBlurCard(
                                    imageUrl: widget
                                        .userProfile
                                        .getImages![currentPhoto],
                                    isMatched: false,
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentPhoto != 0) {
                                            setState(() {
                                              currentPhoto = currentPhoto - 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          height:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.6) -
                                              25,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (currentPhoto <
                                              (numberPhotos - 1)) {
                                            setState(() {
                                              currentPhoto = currentPhoto + 1;
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(
                                            context,
                                          ).size.width,
                                          height:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.6) -
                                              25,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width -
                                          40,
                                      height: 4,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: numberPhotos,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, int i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 6.0,
                                            ),
                                            child: Container(
                                              width:
                                                  ((MediaQuery.of(
                                                        context,
                                                      ).size.width -
                                                      (40 +
                                                          ((numberPhotos + 1) *
                                                              6))) /
                                                  numberPhotos),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: currentPhoto == i
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(0.4),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(25),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                              child: Row(
                                children: [
                                  //Name display--------
                                  Text(
                                    widget.userProfile.name,
                                    style: GoogleFonts.poppins(
                                      color: kWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  //Age display
                                  Text(
                                    widget.userProfile.age,
                                    style: GoogleFonts.poppins(
                                      color: kWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Km away----------
                            // Padding(
                            // 	padding: const EdgeInsets.symmetric(horizontal: 16),
                            // 	child: Row(
                            // 		children: [
                            // 			Icon(
                            // 				CupertinoIcons.placemark,
                            // 				color: Colors.grey.shade600,
                            // 				size: 15,
                            // 			),
                            // 			const SizedBox(width: 5,),
                            // 			Text(
                            // 				"25 km away",
                            // 				style: TextStyle(
                            // 					color: Colors.grey.shade600,
                            // 					fontWeight: FontWeight.w300,
                            // 					fontSize: 15
                            // 				),
                            // 			),
                            // 		],
                            // 	),
                            // ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.08),
                                    Colors.white.withOpacity(0.04),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.person_outline,
                                            color: primary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "About Me",
                                          style: GoogleFonts.poppins(
                                            color: kWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      widget.userProfile.bio,
                                      style: GoogleFonts.poppins(
                                        color: kWhite70, 
                                        fontSize: 16,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.08),
                                    Colors.white.withOpacity(0.04),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.favorite_outline,
                                            color: primary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "Interests",
                                          style: GoogleFonts.poppins(
                                            color: kWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    InterestBuilderWidget(
                                      userInterests: widget.userProfile.interests,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dislike button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.red.withOpacity(0.2),
                              Colors.red.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              log("Noped ${widget.userProfile.name}");
                              context.read<UserActionsBloc>().add(
                                UserDislikeActionEvent(dislikeUserId: widget.userProfile.id),
                              );
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red.shade300,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Super like button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.2),
                              Colors.blue.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              log("Superliked ${widget.userProfile.name}");
                              context.read<UserActionsBloc>().add(
                                SuperLikeEvent(
                                  likeUserId: widget.userProfile.id,
                                  likeUserName: widget.userProfile.name,
                                  currentUserId: accUserProfile.id,
                                  currentUserName: accUserProfile.name,
                                  image: accUserProfile.getImages![0],
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.blue.shade300,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Like button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green.withOpacity(0.2),
                              Colors.green.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              context.read<UserActionsBloc>().add(
                                UserLikeActionEvent(
                                  likeUserId: widget.userProfile.id,
                                  likeUserName: widget.userProfile.name,
                                  currentUserId: accUserProfile.id,
                                  currentUserName: accUserProfile.name,
                                  image: accUserProfile.getImages![0],
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.green.shade300,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
