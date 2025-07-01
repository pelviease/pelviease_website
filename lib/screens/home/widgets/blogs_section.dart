import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pelviease_website/backend/providers/blogs_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogsSection extends StatefulWidget {
  const BlogsSection({super.key});

  @override
  State<BlogsSection> createState() => _BlogsSectionState();
}

class _BlogsSectionState extends State<BlogsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchBlogsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Consumer<BlogProvider>(builder: (context, blogProvider, child) {
      // print("Blog Provider in blog section : ${blogProvider.blogs}");
      if (blogProvider.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (blogProvider.blogs.isEmpty) {
        return const Center(
          child: Text(
            "No Blogs Available",
            style: TextStyle(color: Colors.black),
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Blogs',
                style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  color: darkViolet,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 380,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: blogProvider.blogs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final blog = blogProvider.blogs[index];
                    return BlogCard(
                      postUrl: blog.postUrl,
                      imagePath: blog.thumbnailUrl,
                      title: blog.title,
                      subtitle: blog.description,
                      date: DateFormat('dd-MM-yyyy').format(blog.timestamp),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class BlogCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String date;
  final String postUrl;

  const BlogCard(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.date,
      required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Blog Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image,
                    color: Colors.grey, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18, color: darkViolet)),
          const SizedBox(height: 6),
          // Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date Chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8D6E6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: darkViolet,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => _launchUrl(postUrl),
                  child: Text(
                    'Read More',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty && !await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
