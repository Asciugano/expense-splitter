part of 'auth_bloc.dart';

@immutable
class AuthState {}

final class AuthInitial implements AuthState {}

final class AuthLoading implements AuthState {}

final class AuthSuccess implements AuthState {
  final User user;

  AuthSuccess(this.user);
}

final class AuthFailure implements AuthState {
  final String message;

  AuthFailure([this.message = 'Opss... Something went wrong']);
}
