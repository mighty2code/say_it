part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class FirebaseLoginEvent extends LoginEvent {
  final String email;
  final String password;

  FirebaseLoginEvent({required this.email, required this.password});
}
