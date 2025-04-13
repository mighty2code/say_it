import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:say_it/data/models/firebase_status.dart';
import 'package:say_it/data/models/firebase_user.dart';
import 'package:say_it/data/remote/firebase/firebase_client.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<FirebaseLoginEvent>(_loginToFirebase);
  }

  init() {}

  Future<FutureOr<void>> _loginToFirebase(
      FirebaseLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    FirebaseAuthStatus status = await FirebaseClient.signIn(
        user: FirebaseUser(email: event.email, password: event.password));
    if (status.isSuccess) {
      emit(LoginSuccess(message: status.message));
    } else {
      emit(LoginFailure(error: status.message));
    }
  }
}
