part of 'auth_bloc.dart';

@immutable
class AuthState {}

final class AuthInitial implements AuthState {}

final class AuthLoading implements AuthState {}

final class AuthSuccess implements AuthState {}

final class AuthFailure implements AuthState {}
