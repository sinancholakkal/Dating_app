import 'dart:developer';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/widgets/lookingFor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LookingForStep extends StatefulWidget {
  final Function(List<LookingForModel> lookingFor) onContinue;
  const LookingForStep({super.key, required this.onContinue});

  @override
  State<LookingForStep> createState() => _LookingForStepState();
}

class _LookingForStepState extends State<LookingForStep> {
  List<LookingForModel> lookingFor = [];

@override
  void initState() {
    context.read<LookingforBloc>().add(LookingforFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Looking for',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Pick what you are open to right now',
            style: GoogleFonts.poppins(color: kWhite70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocConsumer<LookingforBloc, LookingforState>(
              listener: (context, state) {
                if(state is LookingforLoadedState) {
                  final items = state.lookingFor;
                  lookingFor = List.from(items);
                }
              },
              builder: (context, state) {
                if(state is LookingforLoadedState) {
                  final items = state.lookingFor;
                  return GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.80,
                        ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return LookingForCard(
                        item: item,
                        onTap: () {
                          log("onTap: ${item.keyValue}");
                          context.read<LookingforBloc>().add(LookingforUpdateEvent(index: index));
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final selectedLookingFor = lookingFor.where((element) => element.isSelected).toList();
              widget.onContinue(selectedLookingFor);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              backgroundColor: AppColors.kWhite,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Continue",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
