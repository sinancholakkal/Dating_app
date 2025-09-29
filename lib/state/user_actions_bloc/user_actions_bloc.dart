import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/services/user_actions_services.dart';
import 'package:equatable/equatable.dart';

part 'user_actions_event.dart';
part 'user_actions_state.dart';

class UserActionsBloc extends Bloc<UserActionsEvent, UserActionsState> {
  final service = UserActionsServices();
  UserActionsBloc() : super(UserActionsInitial()) {
    on<UserDislikeActionEvent>((event, emit)async {
      await service.dislikeAction(dislikeUserId: event.dislikeUserId);
      emit(UserActionSuccessState());
      log("User dislike success");
    });
  }
}
