import 'package:blog_app/core/common/cubits/app_user/entities/users.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthRepository{

  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User >> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

}