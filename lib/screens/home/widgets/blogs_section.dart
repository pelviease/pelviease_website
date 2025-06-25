import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';

class BlogsSection extends StatelessWidget {
  const BlogsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final blogData = List.generate(7, (index) => {
          'title': 'Pelvis Floor Dysfunction',
          'subtitle':
              'Pelvic floor Dysfunction is a prevalent health issue affecting millions of women in India. But due to social stigma and taboos wrapped...',
          'date': '06-03-2025',
          'image': 'product3.png',
        });
    
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50)
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(
            height: 380,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: blogData.length,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final blog = blogData[index];
                return BlogCard(
                  imagePath: blog['image']!,
                  title: blog['title']!,
                  subtitle: blog['subtitle']!,
                  date: blog['date']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String date;

  const BlogCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.date,
  });

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
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              color: darkViolet
            )
          ),
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
              const Text(
                'Read More',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
