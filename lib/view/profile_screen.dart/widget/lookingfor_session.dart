import 'dart:developer';

import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:dating_app/view/widgets/lookingFor_card.dart';
import 'package:dating_app/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LookingForSession extends StatelessWidget {
  const LookingForSession({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LookingforBloc, LookingforState>(
      builder: (context, state) {
        if(state is LookingforLoadingState){
          return const Center(child: CircularProgressIndicator());
        }
        if(state is LookingforErrorState){
          return Center(child: Text(state.message));
        }
        if (state is LookingforLoadedState || state is LookingforUpdatedState) {
          if(state is LookingforUpdatedState){
            flutterToast(msg: "Looking for updated");
          }
        if((state is LookingforLoadedState && state.lookingFor.isEmpty) || (state is LookingforUpdatedState && state.lookingFor.isEmpty)){
          return const Center(child: Text("No looking for found"));
        }
      
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (state is LookingforLoadedState ? state.lookingFor.length : (state is LookingforUpdatedState ? state.lookingFor.length : 0)),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = (state is LookingforLoadedState ? state.lookingFor[index] : (state is LookingforUpdatedState ? state.lookingFor[index] : null));
              
              return LookingForCard(
                item: item!,
                onTap: () {
                  log("onTap: ${item.keyValue}");
                  final List<LookingForModel> newItemList = List.from((state is LookingforLoadedState ? state.lookingFor : (state is LookingforUpdatedState ? state.lookingFor : [])));
                  newItemList[index] = item.copyWith(isSelected: !item.isSelected);
                  context.read<LookingforBloc>().add(LookingforUpdateEvent(lookingFor: newItemList, index: index));
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
