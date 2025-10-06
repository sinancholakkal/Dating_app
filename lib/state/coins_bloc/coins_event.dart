part of 'coins_bloc.dart';

sealed class CoinsEvent extends Equatable {
  const CoinsEvent();

  @override
  List<Object> get props => [];
}
class AddCoinsEvent extends CoinsEvent{
  final int coins;
  final String userId;
  const AddCoinsEvent({required this.coins, required this.userId});
}
class GetCurrentUserCoinsEvent extends CoinsEvent{}