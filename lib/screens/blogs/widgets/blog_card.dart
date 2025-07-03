import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/blog.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Blog Image
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: widget.blog.thumbnailUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey.shade300,
                child: Center(
                  child:
                      Icon(Icons.image, color: Colors.grey.shade500, size: 40),
                ),
              ),
              errorWidget: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey.shade300,
                child: Center(
                  child:
                      Icon(Icons.image, color: Colors.grey.shade500, size: 40),
                ),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    widget.blog.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18, color: darkViolet)),
                const SizedBox(height: 6),
                // Subtitle
                Text(
                  widget.blog.description,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8D6E6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(widget.blog.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: darkViolet,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _launchUrl(widget.blog.postUrl),
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
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
