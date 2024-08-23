part of 'blog_bloc.dart';

@immutable
abstract class BlogEvent {}

class BlogUpload extends BlogEvent{
  final String posterId;
  final String title;
  final String content;
  final List<String> topics;
  final File file;

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.topics,
    required this.file,
  });
}

class GetBlogs extends BlogEvent{}
