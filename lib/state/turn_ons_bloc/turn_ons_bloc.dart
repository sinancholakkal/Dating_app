import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/models/lookingfor_model.dart';
import 'package:dating_app/services/turn_ons_servie.dart';
import 'package:dating_app/state/lookingfor_bloc/lookingfor_bloc.dart';
import 'package:dating_app/utils/app_string.dart';
import 'package:equatable/equatable.dart';

part 'turn_ons_event.dart';
part 'turn_ons_state.dart';

class TurnOnsBloc extends Bloc<TurnOnsEvent, TurnOnsState> {
  final turnOnsService = di.get<TurnOnsService>();
  TurnOnsBloc() : super(TurnOnsInitial()) {
    on<TurnOnsFetchDefaultEvent>((event, emit) {
      emit(TurnOnsLoadedState(turnOns: AppStrings.turnOns));
    });
    on<TurnOnsFetchEvent>((event, emit)async {
      try{
        emit(TurnOnsLoadingState());
        final turnOns = await turnOnsService.getTurnOns();
        emit(TurnOnsLoadedState(turnOns: turnOns));
      }catch(e){
        log("Error fetching turnOns: $e");
        emit(TurnOnsErrorState(message: e.toString()));
      }
      
    });
      on<TurnOnsUpdateDefaultEvent>((event, emit) {
      log("Updating turn ons from bloc");
      final currentState = state;
      if (currentState is TurnOnsLoadedState) {
        final List<LookingForModel> updated = List<LookingForModel>.from(currentState.turnOns);
        final toggled = updated[event.index]
            .copyWith(isSelected: !updated[event.index].isSelected);
        updated[event.index] = toggled;
        emit(TurnOnsLoadedState(turnOns: updated));
      }
    });
    on<TurnOnsUpdateEvent>((event, emit)async {
      try{
        await turnOnsService.updateTurnOns(event.turnOns);
        final updated = List<LookingForModel>.from(event.turnOns);
        if(updated[event.index].isSelected){
          final model =updated.removeAt(event.index);
          updated.insert(0, model);
        }else{
          final model =updated.removeAt(event.index);
          updated.add(model);
        }
        emit(TurnOnsUpdatedState(turnOns: updated));
      }catch(e){
        log("Error updating turnOns: $e");
        emit(TurnOnsErrorState(message: e.toString()));
      }
    });
    on<TurnOnsAddEvent>((event, emit)async {
      try{
        await turnOnsService.addTurnOns(event.turnOns);
        emit(TurnOnsAddedState());
      }catch(e){
        log("Error adding lookingfor: $e");
        emit(TurnOnsErrorState(message: e.toString()));
      }
    });
    on<TurnOnsIsTurnOnsExistsEvent>((event, emit)async {
      try{
        final isExists = await turnOnsService.isTurnOnsExists();
        if(!isExists){
          emit(TurnOnsNotExistedEvent());
        }
      }catch(e){
        log("Error checking if lookingfor exists: $e");
      }
    });
  }
}
