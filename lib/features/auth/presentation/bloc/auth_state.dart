part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});

}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}
