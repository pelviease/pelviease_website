import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/screens/blogs/blogs_screen.dart';
import 'package:pelviease_website/screens/home/widgets/blogs_section.dart';
import 'package:pelviease_website/screens/home/widgets/hero_card_one.dart';
import 'package:pelviease_website/screens/home/widgets/partners_section.dart';
import 'package:pelviease_website/screens/home/widgets/products_hightlight_section.dart';
import 'package:pelviease_website/screens/home/widgets/testimonials_section.dart';
import 'package:pelviease_website/screens/home/widgets/watch_our_content_section.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final PageController controller;
  late final Timer autoScrollTimer;

  final List<Widget> carouselCards = [
    HeroCardOne(),
    HeroCardOne(),
    HeroCardOne(),
    HeroCardOne(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 1, keepPage: true);

    autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      int nextPage = controller.page!.round() + 1;
      if (nextPage >= carouselCards.length) nextPage = 0;
      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: SizedBox(
                height: screenHeight - 120,
                width: screenWidth < 400 ? screenWidth : screenWidth - 16,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller,
                      itemBuilder: (_, index) {
                        return carouselCards[index % carouselCards.length];
                    }),
                    Positioned(
                      bottom: 20,
                      left: screenWidth / 2 - 100,
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: carouselCards.length,
                        effect: const WormEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          type: WormType.thinUnderground,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white38
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ProductHighlightSection(),

            WatchOurContentSection(),

            BlogsSection(),

            TestimonialsSection(),

            PartnersSection()
          ],
        ),
      ),
    );
  }
}
