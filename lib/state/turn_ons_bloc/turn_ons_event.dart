part of 'turn_ons_bloc.dart';

sealed class TurnOnsEvent extends Equatable {
  const TurnOnsEvent();

  @override
  List<Object> get props => [];
}
class TurnOnsFetchDefaultEvent extends TurnOnsEvent{}
class TurnOnsFetchEvent extends TurnOnsEvent{}
class TurnOnsUpdateDefaultEvent extends TurnOnsEvent{
  final int index;
  const TurnOnsUpdateDefaultEvent({required this.index});
}
class TurnOnsUpdateEvent extends TurnOnsEvent{
  final List<LookingForModel> turnOns;
  final int index;
  const TurnOnsUpdateEvent({required this.turnOns, required this.index});
}
class TurnOnsAddEvent extends TurnOnsEvent{
  final List<LookingForModel> turnOns;
  const TurnOnsAddEvent({required this.turnOns});
}
class TurnOnsIsTurnOnsExistsEvent extends TurnOnsEvent{}