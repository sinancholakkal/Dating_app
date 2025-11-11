part of 'turn_ons_bloc.dart';

sealed class TurnOnsState extends Equatable {
  const TurnOnsState();
  
  @override
  List<Object> get props => [];
}

final class TurnOnsInitial extends TurnOnsState {}
class TurnOnsLoadedState extends TurnOnsState{
  final List<LookingForModel> turnOns;
  const TurnOnsLoadedState({required this.turnOns});
  @override
  List<Object> get props => [turnOns];
}
class TurnOnsLoadingState extends TurnOnsState{}
class TurnOnsErrorState extends TurnOnsState{
  final String message;
  const TurnOnsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
class TurnOnsNotExistedEvent extends TurnOnsState{}
class TurnOnsAddedState extends TurnOnsState{}
class TurnOnsUpdatedState extends TurnOnsState{
  final List<LookingForModel> turnOns;
  const TurnOnsUpdatedState({required this.turnOns});
  @override
  List<Object> get props => [turnOns];
}