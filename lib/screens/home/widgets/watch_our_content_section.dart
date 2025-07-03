import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:pelviease_website/backend/providers/our_content_provider.dart';
import 'package:pelviease_website/backend/models/our_content.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchOurContentSection extends StatefulWidget {
  const WatchOurContentSection({super.key});

  @override
  State<WatchOurContentSection> createState() => _WatchOurContentSectionState();
}

class _WatchOurContentSectionState extends State<WatchOurContentSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false).watchContents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            'Watch Our Content',
            style: TextStyle(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: darkViolet,
            ),
          ),
          const SizedBox(height: 40),
          StreamBuilder<List<WatchContent>>(
            stream: Provider.of<ContentProvider>(context).watchContents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading content'));
              }
              final contents = snapshot.data ?? [];
              if (contents.isEmpty) {
                return const Center(child: Text('No content available'));
              }
              return FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: isMobile ? height * 0.22 : height * 0.38,
                  viewportFraction: isMobile ? 0.7 : 0.3,
                  showIndicator: false,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.15,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  slideIndicator: CircularSlideIndicator(),
                ),
                items: contents.map((content) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => _launchUrl(content.videoUrl),
                        child: Container(
                          width: isMobile ? 240 : 360,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                // Thumbnail Image
                                Image.network(
                                  content.thumbnailUrl,
                                  height: isMobile ? 160 : 240,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    height: isMobile ? 160 : 240,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                // Play Button Overlay
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                // Caption Container
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    color: Colors.black.withOpacity(0.7),
                                    child: Text(
                                      content.caption,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty && !await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
