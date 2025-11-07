import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/services/moderation_services.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:dating_app/state/conversation_bloc/conversation_event.dart';
import 'package:dating_app/state/conversation_bloc/conversation_state.dart';
import 'package:dating_app/view/widgets/toast.dart';
// Import your service, events, and states

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatServices _chatService;
  StreamSubscription? _messagesSubscription;
 final UserProfileService _userProfileServices = di.get<UserProfileService>();

  ConversationBloc(this._chatService) : super(ConversationLoading()) {
    on<LoadMessagesEvent>((event, emit) {
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatService
          .getMessagesStream(chatRoomId: event.chatRoomId)
          .listen((snapshot) {
            add(MessagesUpdatedEvent(snapshot.docs));
          });
    });

    on<MessagesUpdatedEvent>((event, emit) {
      emit(ConversationLoaded(event.messages));
    });

    on<SendMessageEvent>((event, emit) {
      _chatService.sendMessage(
        recipientId: event.recipientId,
        chatRoomId: event.chatRoomId,
        messageText: event.messageText,
        senderId: event.senderId,
      );
    });

    on<SendImageEvent>((event, emit) async {
      log("Image upload service called");
      final message = await _userProfileServices.uploadImageToFirebase(
        File(event.image.path),
        event.chatRoomId,
        false,
        collection: "chat_images",
      );
       _chatService.sendMessage(
          recipientId: event.recipientId,
          chatRoomId: event.chatRoomId,
          messageText: message,
          senderId: event.senderId,
        );
      log("Image uploased: $message");
      // if (await ModerationServices().checkContentModeration(
      //       imageUrl: message,
      //     ) ==
      //     "YES") {
      //       log("Image is moderated");
      //   flutterToast(msg: "Image is moderated");
      //   await _userProfileServices.deleteImageFromFirebase(message);
      //   log("moderated image deleted from firebase storage");
      //   return;
      // } else {
      //   log("Image is not moderated");
      //   log("Image url upload in chat");
       
      // }
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
