import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:pelviease_website/const/theme.dart';

class WatchOurContentSection extends StatefulWidget {
  const WatchOurContentSection({super.key});

  @override
  State<WatchOurContentSection> createState() => _WatchOurContentSectionState();
}

class _WatchOurContentSectionState extends State<WatchOurContentSection> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
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
          FlutterCarousel(
            options: FlutterCarouselOptions(
              height: isMobile ? 200 : 300.0,
              viewportFraction: isMobile ? 0.6 : 0.25,
              showIndicator: false,
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              enlargeFactor: 0.1,
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 1),
              slideIndicator: CircularSlideIndicator(),
            ),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: isMobile ? 200 : 300,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  );
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}