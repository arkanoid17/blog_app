import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snack_bar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBLogPage extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const AddNewBLogPage());

  const AddNewBLogPage({super.key});

  @override
  State<AddNewBLogPage> createState() => _AddNewBLogPageState();
}

class _AddNewBLogPageState extends State<AddNewBLogPage> {

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<String> selectedTopics = [];

  File? file;

  final formKey = GlobalKey<FormState>();
  
  void selectImage()async{
     final file = await pickImage();
     if(file!=null){
        setState(() {
          this.file = file;
        });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _uploadBlog, icon: Icon(Icons.done_outlined))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
  listener: (context, state) {
    if(state is BlogFailure){
       showSnackBar(context, state.error);
    }
    if(state is BlogUploadSuccess){
      showSnackBar(context, 'Successfully posted!');
      Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route) => false);
    }
  },
  builder: (context, state) {

    if(state is BlogLoading){
      return const Loader();
    }

    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                file==null?GestureDetector(
                  onTap: selectImage,
                  child: DottedBorder(
                    color: AppPalette.borderColor,
                      dashPattern:const [
                        10,4
                      ],
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open,size: 40,),
                            SizedBox(height: 15,),
                            Text('Select your image!',style: TextStyle(fontSize: 15),)
                          ],
                        ),
                      ),

                  ),
                ):GestureDetector(
                  onTap: selectImage,
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(file!,fit: BoxFit.cover,) ,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Constants.topics.map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap:  (){
                                  if(selectedTopics.contains(e)){
                                    selectedTopics.remove(e);
                                  }else {
                                    selectedTopics.add(e);
                                  }
                                  setState(() {

                                  });
                                },
                                child: Chip(
                                    label: Text(e),
                                    color:  selectedTopics.contains(e)?const WidgetStatePropertyAll(AppPalette.gradient1):null,
                                    side: selectedTopics.contains(e)?null:const BorderSide(
                                      color: AppPalette.borderColor
                                    ),
                                ),
                              ),
                            )
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 20,),
                BlogEditor(controller: titleController, hintText: 'Blog Title'),
                const SizedBox(height: 20,),
                BlogEditor(controller: contentController, hintText: 'Blog Content'),
              ],
            ),
          ),
        ),
      );
  },
),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void _uploadBlog() {
    if(formKey.currentState!.validate() && selectedTopics.isNotEmpty && file!=null){
      final posterId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
          BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              topics: selectedTopics,
              file: file!
          )
      );
    }
  }
}
