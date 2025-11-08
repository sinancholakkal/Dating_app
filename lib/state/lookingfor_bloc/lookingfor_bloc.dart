import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/services/lookingfor_service.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:equatable/equatable.dart';

part 'lookingfor_event.dart';
part 'lookingfor_state.dart';

class LookingforBloc extends Bloc<LookingforEvent, LookingforState> {
  final lookingforService = di.get<LookingforService>();
  LookingforBloc() : super(LookingforInitial()) {
    on<LookingforFetchDefaultEvent>((event, emit) {
      emit(LookingforLoadedState(lookingFor: AppStrings.lookingForItems));
    });
    on<LookingforUpdateDefaultEvent>((event, emit) {
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
    on<LookingforFetchEvent>((event, emit)async {
      try{
        emit(LookingforLoadingState());
        final lookingFor = await lookingforService.getLookingfor();
        emit(LookingforLoadedState(lookingFor: lookingFor));
      }catch(e){
        log("Error fetching lookingfor: $e");
        emit(LookingforErrorState(message: e.toString()));
      }
      
    });
    on<LookingforUpdateEvent>((event, emit)async {
      try{
         lookingforService.updateLookingfor(event.lookingFor);
        emit(LookingforLoadedState(lookingFor: event.lookingFor));
      }catch(e){
        log("Error updating lookingfor: $e");
        emit(LookingforErrorState(message: e.toString()));
      }
    });
    on<LookingforAddEvent>((event, emit)async {
      try{
        emit(LookingforLoadingState());
        await lookingforService.addLookingfor(event.lookingFor);
      }catch(e){
        log("Error adding lookingfor: $e");
        emit(LookingforErrorState(message: e.toString()));
      }
    });
  }
}
