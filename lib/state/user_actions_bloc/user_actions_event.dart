part of 'user_actions_bloc.dart';

sealed class UserActionsEvent extends Equatable {
  const UserActionsEvent();

  @override
  List<Object> get props => [];
}

class UserDislikeActionEvent extends UserActionsEvent{
  final String dislikeUserId;

  const UserDislikeActionEvent({required this.dislikeUserId});

}