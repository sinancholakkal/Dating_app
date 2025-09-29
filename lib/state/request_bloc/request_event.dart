part of 'request_bloc.dart';

sealed class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class FetchRequestsEvent extends RequestEvent{}