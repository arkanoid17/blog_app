
import 'package:blog_app/core/common/cubits/app_user/entities/users.dart';

class UserModel extends User{

  UserModel(super.id, super.name, super.email);

  factory UserModel.fromJson(Map<String,dynamic> map){
    return UserModel(
        map['id'] ?? '',
        map['name'] ?? '',
        map['email'] ?? ''
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
  }){
    return UserModel(
        id ?? this.id,
        name ?? this.name,
        email ?? this.email
    );
  }

}