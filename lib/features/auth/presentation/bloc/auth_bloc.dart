import 'dart:async';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/core/common/cubits/app_user/entities/users.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;



  AuthBloc({required UserSignUp userSignUp, required UserSignIn userSignIn, required CurrentUser currentUser, required AppUserCubit appUserCubit}) :
        _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial())
  {
    on<AuthEvent>(handleAuthEvent);
    on<AuthSignup>(handleUserSignup);
    on<AuthSignIn>(handleSignIn);
    on<AuthIsUserLoggedIn>(handleUserLoggedIn);
  }

  FutureOr<void> handleUserSignup(AuthSignup event, Emitter<AuthState> emit) async{
    final res = await _userSignUp(UserSignUpParams(name: event.name, email: event.email, password: event.password));

    res.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => _emitAuthSuccess(user,emit)
    );


  }

  FutureOr<void> handleSignIn(AuthSignIn event, Emitter<AuthState> emit)async {
    final res = await _userSignIn(UserSignInParams(event.email,event.password));
    res.fold(
            (failure) => emit(AuthFailure(message: failure.message)),
            (user) => _emitAuthSuccess(user,emit)
    );
  }

  FutureOr<void> handleUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit) async{
    final res = await _currentUser(NoParams());
    res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user,emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
    emit(AuthSuccess(user: user));
    _appUserCubit.updateUser(user);

  }


  FutureOr<void> handleAuthEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthLoading());
  }
}
