part of 'coins_bloc.dart';

sealed class CoinsState extends Equatable {
  const CoinsState();

  @override
  List<Object> get props => [];
}

final class CoinsInitial extends CoinsState {}

final class AddCoinsLoadingState extends CoinsState {}
final class AddCoinsSuccessState extends CoinsState {}
final class AddCoinsErrorState extends CoinsState {
  final String message;
  const AddCoinsErrorState({required this.message});
}

final class GetCurrentUserCoinsLoadingState extends CoinsState {}
final class GetCurrentUserCoinsSuccessState extends CoinsState {
  final int coins;
  const GetCurrentUserCoinsSuccessState({required this.coins});
}
final class GetCurrentUserCoinsErrorState extends CoinsState {
  final String message;
  const GetCurrentUserCoinsErrorState({required this.message});
} 