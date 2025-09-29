import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/request_model.dart';
import 'package:dating_app/services/request_services.dart';
import 'package:equatable/equatable.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final service = RequestServices();
  RequestBloc() : super(RequestInitial()) {
    on<FetchRequestsEvent>((event, emit) async{
      emit(FetchLoadingState());
      try{
        final datas = await service.fetchRequests();
        if(datas.isEmpty){
          emit(EmptyRequestState(message: "No new requests yet."));

        }else{
          emit(FetchLoadedState(requests: datas));
        }
      }catch(e){
        log(e.toString());
      }
    });
  }
}
