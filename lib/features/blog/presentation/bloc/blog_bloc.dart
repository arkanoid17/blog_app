import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {

  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog ,
    required GetAllBlogs getAllBlogs ,
  }) :
        _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => BlogLoading());
    on<BlogUpload>( _handleBlogUpload);
    on<GetBlogs>(_handleBlogsFetch);
  }

  

  FutureOr<void> _handleBlogUpload(BlogUpload event, Emitter<BlogState> emit) async{

    final res = await _uploadBlog(UploadBlogParams(posterId: event.posterId, title: event.title, content: event.content, topics: event.topics, file: event.file));


    res.fold(
        (e)=>emit(BlogFailure(error: e.message)),
        (blog) => emit(BlogUploadSuccess())
    );


  }

  FutureOr<void> _handleBlogsFetch(GetBlogs event, Emitter<BlogState> emit) async{
    final res = await _getAllBlogs(NoParams());
    res.fold(
        (error)=>emit(BlogFailure(error: error.message)),
        (blogs) => emit(BlogDisplaySuccess(blogs: blogs))
    );
  }
}
