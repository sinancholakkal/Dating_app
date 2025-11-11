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
        await lookingforService.updateLookingfor(event.lookingFor);
        final updated = List<LookingForModel>.from(event.lookingFor);
        if(updated[event.index].isSelected){
          final model =updated.removeAt(event.index);
          updated.insert(0, model);
        }else{
          final model =updated.removeAt(event.index);
          updated.add(model);
        }
        emit(LookingforUpdatedState(lookingFor: updated));
      }catch(e){
        log("Error updating lookingfor: $e");
        emit(LookingforErrorState(message: e.toString()));
      }
    });
    on<LookingforAddEvent>((event, emit)async {
      try{
        await lookingforService.addLookingfor(event.lookingFor);
        emit(LookingforAddedState());
      }catch(e){
        log("Error adding lookingfor: $e");
        emit(LookingforErrorState(message: e.toString()));
      }
    });
    on<LookingforIsLookingforExistsEvent>((event, emit)async {
      try{
        final isExists = await lookingforService.isLookingforExists();
        if(!isExists){
          emit(LookingforNotExistedEvent());
        }
      }catch(e){
        log("Error checking if lookingfor exists: $e");
      }
    });
  }
}
