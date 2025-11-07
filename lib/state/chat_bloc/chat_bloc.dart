import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/chat_user_model.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatServices _chatService;
  StreamSubscription? _chatsSubscription;
  ChatBloc(this._chatService) : super(ChatInitial()) {
    on<LoadChatsEvent>((event, emit) {
      emit(ChatLoading());
    
      _chatsSubscription?.cancel();
      
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      
      _chatsSubscription = _chatService.getChatsStream(currentUserId).listen(
        (chats) {
          //add(_ChatsUpdatedEvent(chats));
        },
        onError: (error) {
          // Handle stream errors
          emit(ChatError());
        },
      );
    });
    on<_ChatsUpdatedEvent>((event, emit) {
      emit(ChatLoaded(event.chats));
    });
  }

  // IMPORTANT: Close the stream subscription when the BLoC is closed
  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    return super.close();
  }
}
