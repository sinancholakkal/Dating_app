import 'dart:developer';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/state/turn_ons_bloc/turn_ons_bloc.dart';
import 'package:dating_app/utils/app_color.dart';
import 'package:dating_app/utils/app_color.dart' as AppColors;
import 'package:dating_app/view/widgets/lookingFor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';



class TuntOnsWidget extends StatefulWidget {
  final Function(List<LookingForModel> lookingFor) onContinue;
  const TuntOnsWidget({super.key, required this.onContinue});

  @override
  State<TuntOnsWidget> createState() => _LookingForStepState();
}

class _LookingForStepState extends State<TuntOnsWidget> {
  List<LookingForModel> lookingFor = [];

  @override
  void initState() {
    context.read<TurnOnsBloc>().add(TurnOnsFetchDefaultEvent());
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
            'Turn Ons',
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
            child: BlocConsumer<TurnOnsBloc, TurnOnsState>(
              listener: (context, state) {
                if (state is TurnOnsLoadedState) {
                  final items = state.turnOns;
                  lookingFor = List.from(items);
                }
              },
              builder: (context, state) {
                if (state is TurnOnsLoadedState) {
                  final items = state.turnOns;
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
                          context.read<TurnOnsBloc>().add(
                            TurnOnsUpdateDefaultEvent(index: index),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onContinue(lookingFor);
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
