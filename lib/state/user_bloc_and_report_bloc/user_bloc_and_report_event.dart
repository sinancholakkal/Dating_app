part of 'user_bloc_and_report_bloc.dart';

sealed class UserBlocAndReportEvent extends Equatable {
  const UserBlocAndReportEvent();

  @override
  List<Object> get props => [];
}

class UserBlocEvent extends UserBlocAndReportEvent{
  final String chatRoomId;
  final String currentUserId;

  const UserBlocEvent({required this.chatRoomId, required this.currentUserId});
  
}

class UserUnblockEvent extends UserBlocAndReportEvent{
  final String chatRoomId;

  const UserUnblockEvent({required this.chatRoomId});
}