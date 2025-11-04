import 'package:bloc/bloc.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/services/swip_service.dart';
import 'package:equatable/equatable.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final swipService = di.get<SwipeServices>();
  AdBloc() : super(AdInitial()) {
    on<AdCompletedAndSwipResetEvent>((event, emit)async {
      emit(SwipResetLoadingState());
      await swipService.resetDailySwipeCount();
      emit(SwipResetedState());
    });
  }
}
