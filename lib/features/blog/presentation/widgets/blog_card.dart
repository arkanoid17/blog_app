import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {

  final Blog blog;
  final Color color;

  const BlogCard({super.key,required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,BlogViewer.route(blog)),
      child: Container(
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4
        ),
        padding: const EdgeInsets.all(16),
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics.map(
                            (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(
                            label: Text(e),
                            color:  null,
                            side: null,
                          ),
                        )
                    ).toList(),
                  ),
                ),

                Text(blog.title,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

              ],

            ),
            Text('${calculateReadingTime(blog.content)} min')
          ],
        ),
      ),
    );
  }
}
