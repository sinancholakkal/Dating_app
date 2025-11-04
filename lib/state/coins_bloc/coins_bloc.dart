import 'package:bloc/bloc.dart';
import 'package:dating_app/di/di.dart';
import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/coins_service.dart';
import 'package:equatable/equatable.dart';
part 'coins_event.dart';
part 'coins_state.dart';

class CoinsBloc extends Bloc<CoinsEvent, CoinsState> {
  final CoinsServices coinsServices = di.get<CoinsServices>();
  CoinsBloc() : super(CoinsInitial()) {
    on<AddCoinsEvent>((event, emit)async {
     try{
      emit(AddCoinsLoadingState());
      await coinsServices.addCoins(coins: event.coins,userId: event.userId);
      emit(AddCoinsSuccessState());
     }catch(e){
      emit(AddCoinsErrorState(message: e.toString()));
     }
    });

    on<GetCurrentUserCoinsEvent>((event, emit)async {
        final authService = di.get<AuthServices>();
      try{
        emit(GetCurrentUserCoinsLoadingState());
        final coins = await coinsServices.getUserCoins(userId: authService.getCurrentUser()!.uid);
        emit(GetCurrentUserCoinsSuccessState(coins: coins));
      }
      catch(e){
        emit(GetCurrentUserCoinsErrorState(message: e.toString()));
      }
    });
  }
}
