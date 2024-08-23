

import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource{

  Future<BlogModel> uploadBlog(BlogModel blogModel);

  Future<String> uploadBlogImage({required File file,required BlogModel blogModel});

  Future<List<BlogModel>> getAllBogs();

 }

 class BlogRemoteDataSourceImpl implements BlogRemoteDataSource{

 final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async{
    try{
      final res = await supabaseClient.from('blogs').insert(blogModel.toJson()).select();
      return BlogModel.fromJson(res.first);

    } catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({required File file, required BlogModel blogModel})async {
    try{
      await supabaseClient.storage.from('blog_images').upload(blogModel.id, file);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blogModel.id);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBogs() async{
    try{
      final blogs = await supabaseClient.from('blogs').select('*, profiles (name) ');
      return blogs.map((blog) => BlogModel.fromJson(blog).copyWith(posterName: blog['profiles']['name'])).toList();
    }catch(e){
      throw ServerException(e.toString());
    }
  }
}