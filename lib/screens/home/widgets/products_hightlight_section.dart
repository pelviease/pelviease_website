import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductHighlightSection extends StatefulWidget {
  const ProductHighlightSection({super.key});

  @override
  State<ProductHighlightSection> createState() =>
      _ProductHighlightSectionState();
}

class _ProductHighlightSectionState extends State<ProductHighlightSection> {
  final PageController _controller = PageController();
  late Timer _autoPlayTimer;

  final List<Map<String, String>> _products = [
    {
      'title': 'PERINEOMETER',
      'description':
          'Perineometer is an advanced diagnostic and rehabilitation device designed to assess and strengthen pelvic floor muscles.',
      'image': 'perineometer.png',
    },
    {
      'title': 'Dialator',
      'description':
          'Tracks muscle responses and helps in pelvic floor training using visual and auditory cues.',
      'image': 'dialator.png',
    },
    {
      'title': 'Vaginal Weights',
      'description':
          'Electrical stimulation device to assist in pelvic floor rehabilitation and therapy.',
      'image': 'product3.png',
    },
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % _products.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
      ),
      child: isMobile
          ? Column(
              children: [
                _LeftCard(isMobile),
                const SizedBox(height: 24),
                SizedBox(
                    height: 300,
                    child: _RightCarousel(_controller, _products, isMobile)),
                const SizedBox(height: 16),
                _buildDots(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _LeftCard(isMobile)),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: lightViolet,
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 350,
                          child:
                              _RightCarousel(_controller, _products, isMobile),
                        ),
                        _buildDots(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDots() {
    return SmoothPageIndicator(
      controller: _controller,
      count: _products.length,
      effect: ExpandingDotsEffect(
        activeDotColor: darkViolet,
        dotColor: darkViolet.withAlpha(100),
        dotHeight: 6,
        dotWidth: 6,
        expansionFactor: 3,
      ),
    );
  }
}

class _LeftCard extends StatelessWidget {
  final bool isMobile;
  const _LeftCard(this.isMobile);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        color: cyclamen.withAlpha(160),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 30,
            top: 50,
            child: Opacity(
              opacity: 1,
              child: Center(
                child: Text(
                  'OUR\nPRODUCTS',
                  style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.bold,
                      color: darkViolet,
                      letterSpacing: 2,
                      height: 0.9),
                ),
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 30,
            child: Text(
              'OUR\nPRODUCTS\nOUR\nPRODUCTS\nOUR\nPRODUCTS',
              style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = .8
                    ..color = darkViolet.withAlpha(100),
                  height: 1),
            ),
          ),
          Positioned(
            bottom: isMobile ? -35 : -50,
            left: 30,
            child: Image.asset(
              'perineometer.png',
              height: isMobile ? 200 : 280,
            ),
          ),
          Positioned(
            bottom: isMobile ? -20 : -30,
            left: 100,
            child: Image.asset(
              'dialator.png',
              height: isMobile ? 120 : 160,
            ),
          ),
          Positioned(
            bottom: -10,
            left: 220,
            child: Image.asset(
              'product3.png',
              height: isMobile ? 100 : 140,
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 2, color: darkViolet),
                  shape: BoxShape.circle),
              child: Icon(Icons.arrow_outward, color: darkViolet),
            ),
          ),
        ],
      ),
    );
  }
}

class _RightCarousel extends StatelessWidget {
  final PageController controller;
  final List<Map<String, String>> products;
  final bool isMobile;

  const _RightCarousel(this.controller, this.products, this.isMobile);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: isMobile ? EdgeInsets.all(0) : EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['title'] ?? '',
                        style: TextStyle(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.bold,
                          color: darkViolet,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: isMobile ? MediaQuery.of(context).size.width / 2.6 : MediaQuery.of(context).size.width / 2.6,
                        child: Text(
                          product['description'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: isMobile ? 14 : 20,
                                  color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.verified, size: 20, color: Colors.black87),
                          SizedBox(width: 8),
                          Text("CDSCO Certified",
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                  IntrinsicWidth(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: darkViolet,
                          borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("    Buy Now",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              Icons.arrow_outward_sharp,
                              color: darkViolet,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment:
                    isMobile ? Alignment.bottomRight : Alignment.centerRight,
                child: Image.asset(
                  product['image'] ?? '',


                  width: isMobile ? (product['image'] == 'product3.png' ? 80 : 80) : 228,

                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
