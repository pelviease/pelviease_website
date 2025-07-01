import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/providers/product_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
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

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        if (productProvider.products.isNotEmpty) {
          _currentPage = (_currentPage + 1) % productProvider.products.length;
          _controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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
      child:
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (productProvider.error != null) {
          return Center(child: Text('Error: ${productProvider.error}'));
        }
        if (productProvider.products.isEmpty) {
          return const Center(child: Text('No products available'));
        }
        return isMobile
            ? Column(
                children: [
                  _LeftCard(isMobile),
                  const SizedBox(height: 24),
                  SizedBox(
                      height: 300,
                      child: _RightCarousel(_controller, isMobile)),
                  const SizedBox(height: 16),
                  _buildDots(productProvider.products.length),
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
                            child: _RightCarousel(_controller, isMobile),
                          ),
                          _buildDots(productProvider.products.length),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildDots(int length) {
    return SmoothPageIndicator(
      controller: _controller,
      count: length,
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
  final bool isMobile;

  const _RightCarousel(this.controller, this.isMobile);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final products =
        Provider.of<ProductProvider>(context, listen: false).products;
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
                        product.name,
                        style: TextStyle(
                          fontSize: isMobile ? 32 : 48,
                          fontWeight: FontWeight.bold,
                          color: darkViolet,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: isMobile
                            ? MediaQuery.of(context).size.width / 2.6
                            : MediaQuery.of(context).size.width / 2.6,
                        child: Text(
                          product.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
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
                          product.isCDSCOCertified
                              ? Text("CDSCO Certified",
                                  style: Theme.of(context).textTheme.bodyMedium)
                              : Text('')
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
                child: Image.network(
                  product.images.first,
                  width: isMobile ? screenWidth * 0.25 : screenWidth * 0.17,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: isMobile ? 80 : screenWidth * 0.17,
                    height: isMobile ? 80 : screenWidth * 0.17,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey, size: isMobile ? 40 : 60),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
