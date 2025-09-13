import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/providers/our_content_provider.dart';
import 'package:pelviease_website/backend/models/our_content.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false).testimonials;
    });
  }

  int currentIndex = 0;

  void _goToPrevious(List<Testimony> testimonials) {
    setState(() {
      currentIndex =
          (currentIndex - 1 + testimonials.length) % testimonials.length;
    });
  }

  void _goToNext(List<Testimony> testimonials) {
    setState(() {
      currentIndex = (currentIndex + 1) % testimonials.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return SizedBox(
      width: double.infinity,
      height: 520,
      child: Stack(
        children: [
          // Pink background
          if (!isMobile)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 550,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: cyclamen.withAlpha(120),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),

          if (isMobile)
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2 - 120,
              child: Text(
                "Testimonials",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 32, color: darkViolet),
              ),
            ),

          // Left Card
          Positioned(
            top: 50,
            left: isMobile
                ? MediaQuery.of(context).size.width * 0.5 - 170
                : MediaQuery.of(context).size.width * 0.006 - 250,
            child: Row(
              spacing: 20,
              children: [
                if (!isMobile)
                  Container(
                    height: 400,
                    width: 400,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 90, 47, 90).withAlpha(150),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                StreamBuilder<List<Testimony>>(
                  stream: Provider.of<ContentProvider>(context).testimonials,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 400,
                        width: isMobile ? 300 : 400,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: darkViolet,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Container(
                        height: 400,
                        width: isMobile ? 300 : 400,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: darkViolet,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                            child: Text('Error loading testimonials')),
                      );
                    }
                    final testimonials = snapshot.data ?? [];
                    if (testimonials.isEmpty) {
                      return Container(
                        height: 400,
                        width: isMobile ? 300 : 400,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: darkViolet,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            'No testimonials available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                    final testimony = testimonials[currentIndex];
                    return Container(
                      height: 400,
                      width: isMobile ? 300 : 400,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: darkViolet,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.format_quote,
                              color: Colors.white, size: isMobile ? 32 : 48),
                          const SizedBox(height: 16),
                          Text(
                            testimony.testimony,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "- ${testimony.name}, ${testimony.about}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Right Static Text
          isMobile
              ? SizedBox.shrink()
              : Positioned(
                  left: MediaQuery.of(context).size.width * 0.44,
                  top: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Testimonials",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              color: darkViolet,
                            ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "What Our Customers\nSay About us",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 46,
                              color: darkViolet,
                            ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Hear directly from our satisfied customers! Discover how our products and services\nhave made a difference in their lives through their honest reviews and feedback.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              color: darkViolet,
                            ),
                      ),
                    ],
                  ),
                ),

          // Navigation Buttons
          StreamBuilder<List<Testimony>>(
            stream: Provider.of<ContentProvider>(context).testimonials,
            builder: (context, snapshot) {
              final testimonials = snapshot.data ?? [];
              return Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: testimonials.isNotEmpty
                          ? () => _goToPrevious(testimonials)
                          : null,
                      tooltip: "Previous",
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: testimonials.isNotEmpty
                          ? () => _goToNext(testimonials)
                          : null,
                      tooltip: "Next",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
