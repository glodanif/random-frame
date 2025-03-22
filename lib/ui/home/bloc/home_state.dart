part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadedState extends HomeState {
  final String username;
  final int randomDice;
  final double randomRotation;

  LoadedState({
    required this.randomDice,
    required this.randomRotation,
    required this.username,
  });
}

class InvalidLocationState extends HomeState {}
