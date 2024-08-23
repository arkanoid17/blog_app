import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/cubits/app_user/entities/users.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';

import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;



import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{

  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({required this.remoteDataSource,required this.connectionChecker});

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({required String email, required String password}) async{
    return _getUser(() async => await remoteDataSource.signInWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({required String name, required String email, required String password}) async{
    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password));
  }

  Future<Either<Failure, User>>_getUser(Future<User> Function() fn)async{
    try{
      if(await connectionChecker.isConnected) {
        final user = await fn();
        return right(user);
      }else {
        return left(Failure(Constants.noInternet));
      }
    } on sb.AuthException catch(e){
      return left(Failure(e.message));
    }
    on ServerException catch(e){
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async{
    try{

      if(!await connectionChecker.isConnected){
        final session = remoteDataSource.currentUserSession;
        if(session==null){
          return left(Failure('User not logged in!'));
        }
        return right(UserModel(session.user.id, '', session.user.email?? ''));
      }

      final user = await remoteDataSource.getCurrentUserData();
      if(user==null){
        return left(Failure('User not logged in!'));
      }
      return right(user);
    }on ServerException catch(e){
      return left(Failure(e.message));
    }
  }
  
}