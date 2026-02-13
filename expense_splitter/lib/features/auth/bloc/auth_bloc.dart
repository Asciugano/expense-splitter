import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLogged>(_onIsUserLogged);
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {}
  void _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {}
  void _onIsUserLogged(AuthIsUserLogged event, Emitter<AuthState> emit) async {}
}
