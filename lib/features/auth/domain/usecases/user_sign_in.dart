import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import 'package:blog_app/core/common/cubits/app_user/entities/users.dart';

class UserSignIn implements UseCase<User,UserSignInParams>{

  final AuthRepository authRepository;

  UserSignIn(this.authRepository);



  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async{
    return await authRepository.signInWithEmailPassword(email: params.email, password: params.password);
  }
}

class UserSignInParams{
   final String email;
   final String password;

  UserSignInParams(this.email, this.password);
}