part of 'lookingfor_bloc.dart';

sealed class LookingforEvent extends Equatable {
  const LookingforEvent();

  @override
  List<Object> get props => [];
}
class LookingforFetchEvent extends LookingforEvent{}
class LookingforUpdateEvent extends LookingforEvent{
  final int index;
  const LookingforUpdateEvent({required this.index});
}