import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/services/user_actions_services.dart';
import 'package:equatable/equatable.dart';

part 'user_actions_event.dart';
part 'user_actions_state.dart';

class UserActionsBloc extends Bloc<UserActionsEvent, UserActionsState> {
  final service = UserActionsServices();
  UserActionsBloc() : super(UserActionsInitial()) {
    on<UserDislikeActionEvent>((event, emit) async {
      await service.dislikeAction(dislikeUserId: event.dislikeUserId);
      emit(UserActionSuccessState());
      log("User dislike success");
    });

    on<UserLikeActionEvent>((event, emit) async {
      await service.likeAction(
        image: event.image,
        currentUserId: event.currentUserId,
        currentUserName: event.currentUserName,
        likeUserId: event.likeUserId,
        likeUserName: event.likeUserName,
      );
      emit(UserActionSuccessState());
      log("User like  success");
    });
    on<SuperLikeEvent>((event, emit) async {
      // await service.likeAction(image: event.image, currentUserId: event.currentUserId,currentUserName: event.currentUserName,likeUserId: event.likeUserId,likeUserName: event.likeUserName);
      // emit(UserActionSuccessState());
      try {
        await service.addToFavorites(favoriteUserId: event.likeUserId);
        log("Added into favorite");
        // await service.likeAction(
        //   image: event.image,
        //   currentUserId: event.currentUserId,
        //   currentUserName: event.currentUserName,
        //   likeUserId: event.likeUserId,
        //   likeUserName: event.likeUserName,
        // );
        log("Added into like and request");
        log("Super User like  success");
      } catch (e) {
        log("something issue while add to fav $e");
      }
    });
  }
}
