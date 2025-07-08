import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pelviease_website/screens/home/widgets/blogs_section.dart';
import 'package:pelviease_website/screens/home/widgets/hero_card_one.dart';
import 'package:pelviease_website/screens/home/widgets/partners_section.dart';
import 'package:pelviease_website/screens/home/widgets/products_hightlight_section.dart';
import 'package:pelviease_website/screens/home/widgets/testimonials_section.dart';
import 'package:pelviease_website/screens/home/widgets/watch_our_content_section.dart';
import 'package:pelviease_website/widgets/footer.dart';
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
  bool _isFollowUsExpanded = false;

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
      if (!controller.hasClients) return;
      int nextPage = (controller.page?.round() ?? 0) + 1;
      if (nextPage >= carouselCards.length) nextPage = 0;
      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkCurrentUser();
    });
  }

  @override
  void dispose() {
    autoScrollTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (_isFollowUsExpanded) {
              setState(() {
                _isFollowUsExpanded = false;
              });
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: SizedBox(
                      height:
                          isMobile ? screenHeight * 0.57 : screenHeight * 0.7,
                      width: isMobile ? screenWidth : screenWidth - 16,
                      child: Stack(
                        children: [
                          PageView.builder(
                              controller: controller,
                              itemBuilder: (_, index) {
                                return carouselCards[
                                    index % carouselCards.length];
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
                                  dotColor: Colors.white38),
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
                  PartnersSection(),
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: MediaQuery.of(context).size.height / 2 - 90,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isMobile ? 140 : 180,
            width: _isFollowUsExpanded
                ? (isMobile ? 200 : 280)
                : (isMobile ? 48 : 72),
            decoration: BoxDecoration(
              // gradient: const LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color(0xFF1A1A1A),
              //     Color(0xFF2C2C2C),
              //   ],
              // ),
              color: cyclamen,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: _isFollowUsExpanded
                ? _buildExpandedContent(isMobile)
                : _buildCollapsedContent(isMobile),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedContent(bool isMobile) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFollowUsExpanded = true;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  "Follow Us",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: isMobile ? 12 : 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 8),
              RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: buttonColor.withOpacity(0.7),
                  size: isMobile ? 12 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Follow Us",
                style: TextStyle(
                  color: buttonColor,
                  fontSize: isMobile ? 14 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFollowUsExpanded = false;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon('assets/icons/insta.png', 'Instagram', () {
                _launchURL('https://www.instagram.com/pelviease');
              }, isMobile),
              _buildSocialIcon('assets/icons/linkedin.png', 'LinkedIn', () {
                _launchURL(
                    'https://www.linkedin.com/company/techaro-innov-pvt-ltd/');
              }, isMobile),
              _buildSocialIcon('assets/icons/youtube.png', 'YouTube', () {
                _launchURL('https://www.youtube.com/@pelviease');
              }, isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(
      String assetPath, String label, VoidCallback onTap, bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    assetPath,
                    width: isMobile ? 20 : 28,
                    height: isMobile ? 20 : 28,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 7 : 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }
}
