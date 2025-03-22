part of 'sharing_bloc.dart';

@immutable
abstract class SharingState {}

class SharingInitial extends SharingState {}

class LoadingState extends SharingState {}

class InfoState extends SharingState {
  final String? username;
  final String appVersion;
  final String date;

  InfoState({
    required this.username,
    required this.appVersion,
    required this.date,
  });
}
