part of 'lookingfor_bloc.dart';

sealed class LookingforEvent extends Equatable {
  const LookingforEvent();

  @override
  List<Object> get props => [];
}
class LookingforFetchDefaultEvent extends LookingforEvent{}
class LookingforFetchEvent extends LookingforEvent{}
class LookingforUpdateDefaultEvent extends LookingforEvent{
  final int index;
  const LookingforUpdateDefaultEvent({required this.index});
}
class LookingforUpdateEvent extends LookingforEvent{
  final List<LookingForModel> lookingFor;
  final int index;
  const LookingforUpdateEvent({required this.lookingFor, required this.index});
}
class LookingforAddEvent extends LookingforEvent{
  final List<LookingForModel> lookingFor;
  const LookingforAddEvent({required this.lookingFor});
}
class LookingforIsLookingforExistsEvent extends LookingforEvent{}