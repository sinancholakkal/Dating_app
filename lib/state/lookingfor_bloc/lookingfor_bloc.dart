import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:equatable/equatable.dart';

part 'lookingfor_event.dart';
part 'lookingfor_state.dart';

class LookingforBloc extends Bloc<LookingforEvent, LookingforState> {
  LookingforBloc() : super(LookingforInitial()) {
    on<LookingforFetchEvent>((event, emit) {
      emit(LookingforLoadedState(lookingFor: AppStrings.lookingForItems));
    });
    on<LookingforUpdateEvent>((event, emit) {
      log("Updating looking from bloc");
      final currentState = state;
      if (currentState is LookingforLoadedState) {
        final List<LookingForModel> updated = List<LookingForModel>.from(currentState.lookingFor);
        final toggled = updated[event.index]
            .copyWith(isSelected: !updated[event.index].isSelected);
        updated[event.index] = toggled;
        emit(LookingforLoadedState(lookingFor: updated));
      }
    });
  }
}
