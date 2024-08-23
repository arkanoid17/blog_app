
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {

  @override
  void initState() {
    context.read<BlogBloc>().add(GetBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, AddNewBLogPage.route());
          }, icon: const Icon(CupertinoIcons.add))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if(state is BlogFailure){
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {

          if(state is BlogLoading){
            return Loader();
          }
          if(state is BlogDisplaySuccess){
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(
                    blog: blog,
                    color: index%3==0?AppPalette.gradient1:index%3==1?AppPalette.gradient2:AppPalette.gradient3 ,
                  );
                }
            );
          }

          return Container();

        },
      ),
    );
  }
}
