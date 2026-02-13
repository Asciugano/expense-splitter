import 'package:expense_splitter/core/entities/user.dart';
import 'package:expense_splitter/features/auth/domain/usecases/user_login.dart';
import 'package:expense_splitter/features/auth/domain/usecases/user_register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  final UserRegister _userRegister;

  AuthBloc({required UserLogin userLogin, required UserRegister userRegister})
    : _userLogin = userLogin,
      _userRegister = userRegister,
      super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLogged>(_onIsUserLogged);
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin.call(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {
    final res = await _userRegister.call(
      UserRegisterParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onIsUserLogged(AuthIsUserLogged event, Emitter<AuthState> emit) async {}

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    emit(AuthSuccess(user));
  }
}
