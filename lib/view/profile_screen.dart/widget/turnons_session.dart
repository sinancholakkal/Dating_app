import 'dart:developer';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/state/turn_ons_bloc/turn_ons_bloc.dart';
import 'package:dating_app/view/widgets/lookingFor_card.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TurnOnsSession extends StatelessWidget {
  const TurnOnsSession({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnOnsBloc, TurnOnsState>(
      builder: (context, state) {
        if (state is TurnOnsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TurnOnsErrorState) {
          return Center(child: Text(state.message));
        }
        if (state is TurnOnsLoadedState || state is TurnOnsUpdatedState) {
          if (state is TurnOnsUpdatedState) {
            flutterToast(msg: "Turn Ons updated");
          }
          if ((state is TurnOnsLoadedState && state.turnOns.isEmpty) ||
              (state is TurnOnsUpdatedState && state.turnOns.isEmpty)) {
            return const Center(child: Text("No turn ons found"));
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (state is TurnOnsLoadedState
                ? state.turnOns.length
                : (state is TurnOnsUpdatedState ? state.turnOns.length : 0)),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = (state is TurnOnsLoadedState
                  ? state.turnOns[index]
                  : (state is TurnOnsUpdatedState
                      ? state.turnOns[index]
                      : null));

              return LookingForCard(
                item: item!,
                onTap: () {
                  log("onTap: ${item.keyValue}");
                  final List<LookingForModel> newItemList = List.from((state
                          is TurnOnsLoadedState
                      ? state.turnOns
                      : (state is TurnOnsUpdatedState ? state.turnOns : [])));
                  newItemList[index] =
                      item.copyWith(isSelected: !item.isSelected);
                  context
                      .read<TurnOnsBloc>()
                      .add(TurnOnsUpdateEvent(turnOns: newItemList, index: index));
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

