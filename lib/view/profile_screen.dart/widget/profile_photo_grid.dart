import 'dart:io';
import 'package:dating_app/state/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/view/widgets/show_diolog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoGrid extends StatelessWidget {
  final List<dynamic> images;
  final Function(dynamic) onImageAdded;
  final Function(int) onImageRemoved;

  const ProfilePhotoGrid({
    super.key,
    required this.images,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
      listener: (context, state) {
        if (state is ImageUploadedState) {
          onImageAdded(state.pickedFile);
        } else if (state is ImageRemovedState) {
          onImageRemoved(state.index);
        }
      },
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _AddPhotoCard(
                onTap: () {
                  context.read<ProfileSetupBloc>().add(
                    SelfieImageUploadEvent(source: ImageSource.gallery),
                  );
                },
              );
            }
            return _PhotoCard(
              image: images[index],
              onLongPress: () {
                showDiolog(
                  context: context,
                  title: "Remove",
                  content: "Are you sure want to remove?",
                  cancelTap: () => context.pop(),
                  confirmTap: () {
                    context.pop();
                    context.read<ProfileSetupBloc>().add(
                      ImageRemoveEvent(index: index),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _AddPhotoCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPhotoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kWhite.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: kWhite, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add Photo',
                      style: GoogleFonts.poppins(
                        color: kWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final dynamic image;
  final VoidCallback onLongPress;

  const _PhotoCard({
    required this.image,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kWhite.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(),
              _buildBottomGradient(),
              _buildPhotoIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (image is String) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            Icons.broken_image,
            color: kWhite54,
            size: 32,
          ),
        ),
      );
    } else {
      return Image.file(
        File(image.path),
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildBottomGradient() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 36,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0x99000000), Color(0x00000000)],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoIcon() {
    return Positioned(
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.photo,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}

