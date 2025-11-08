part of 'lookingfor_bloc.dart';

sealed class LookingforState extends Equatable {
  const LookingforState();
  
  @override
  List<Object> get props => [];
}

final class LookingforInitial extends LookingforState {}
class LookingforLoadedState extends LookingforState{
  final List<LookingForModel> lookingFor;
  const LookingforLoadedState({required this.lookingFor});
  @override
  List<Object> get props => [lookingFor];
}
class LookingforLoadingState extends LookingforState{}
class LookingforErrorState extends LookingforState{
  final String message;
  const LookingforErrorState({required this.message});
  @override
  List<Object> get props => [message];
}