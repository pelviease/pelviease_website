import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/product_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProductsId();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProductsId();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(isMobile
          ? 20
          : isTablet
              ? 30
              : 40),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftPart(
                    context, screenWidth, screenHeight, isMobile, isTablet),
                SizedBox(height: 20),
                _buildRightPart(context, screenWidth, isMobile, isTablet),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLeftPart(
                      context, screenWidth, screenHeight, isMobile, isTablet),
                ),
                SizedBox(width: isTablet ? 40 : 60),
                Expanded(
                  flex: 3,
                  child:
                      _buildRightPart(context, screenWidth, isMobile, isTablet),
                ),
              ],
            ),
    );
  }

  Widget _buildLeftPart(BuildContext context, double screenWidth,
      double screenHeight, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Image.asset(
          'assets/logo_with_tm.png',
          height: isMobile ? screenHeight * 0.02 : screenHeight * 0.03,
        ),
        Text(
          'A brand by Techaro',
          style: TextStyle(
            color: textColor,
            fontSize: isMobile
                ? 8
                : isTablet
                    ? 9
                    : 10,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: textColor,
              size: isMobile ? 16 : 18,
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(
              child: Text(
                'H.NO. 7-1-302/45/4, 5th Floor B.K Guda, Sanjeev Reddy Nagar,\nAmeerpet, Hyderabad-500038, Telangana.',
                style: TextStyle(
                  color: textColor,
                  fontSize: isMobile
                      ? 11
                      : isTablet
                          ? 12
                          : 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 10 : 15),
        // Illustration
        Center(
          child: SizedBox(
            height: isMobile
                ? 150
                : isTablet
                    ? 200
                    : 230,
            width: isMobile ? screenWidth * 0.8 : 600,
            child: Image.asset(
              'assets/icons/footer.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: isMobile ? 80 : 120,
                  width: isMobile ? 150 : 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.grey.shade400,
                    size: isMobile ? 30 : 40,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPart(
      BuildContext context, double screenWidth, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCompanySection(
                          context, screenWidth, isMobile, isTablet),
                      // SizedBox(: 20),
                      _buildProductsSection(
                          context, screenWidth, isMobile, isTablet),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildContactSection(screenWidth, isMobile, isTablet),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCompanySection(
                        context, screenWidth, isMobile, isTablet),
                  ),
                  SizedBox(width: isTablet ? 30 : 40),
                  Expanded(
                    child: _buildProductsSection(
                        context, screenWidth, isMobile, isTablet),
                  ),
                  SizedBox(width: isTablet ? 30 : 40),
                  Expanded(
                    child:
                        _buildContactSection(screenWidth, isMobile, isTablet),
                  ),
                ],
              ),
        SizedBox(height: isMobile ? 0 : 40),
        // R&D Center Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: textColor,
                size: isMobile ? 14 : 16,
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                'R&D CENTER :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 11 : 13,
                  color: textColor,
                ),
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Expanded(
                child: Text(
                  'JTBI, Admissions Block, Jawaharlal Nehru Technological University,\nHyderabad, Telangana-500085.',
                  style: TextStyle(
                    color: textColor,
                    fontSize: isMobile ? 11 : 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 0 : 20),
        // Bottom Footer Section
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 11 : 14,
                        fontFamily: 'sans-serif',
                      ),
                      children: [
                        const TextSpan(text: '© '),
                        TextSpan(text: '${DateTime.now().year}'),
                        const TextSpan(
                          text:
                              ' Pelviease. All rights reserved. Designed and Developed \n by @Octovu',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildSocialIcons(screenWidth, isMobile),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 11 : 14,
                        fontFamily: 'sans-serif',
                      ),
                      children: [
                        const TextSpan(text: '© '),
                        TextSpan(text: '${DateTime.now().year}'),
                        const TextSpan(
                          text:
                              ' Pelviease. All rights reserved. Designed and Developed by @Octovu',
                        ),
                      ],
                    ),
                  ),
                  _buildSocialIcons(screenWidth, isMobile),
                ],
              ),
      ],
    );
  }

  Widget _buildCompanySection(
      BuildContext context, double screenWidth, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Our Company',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        _buildFooterLink(context, 'About US', isMobile, '/about'),
        _buildFooterLink(context, 'Products', isMobile, '/products'),
        _buildFooterLink(context, 'Blogs', isMobile, '/blogs'),
        _buildFooterLink(context, 'Doctors', isMobile, '/doctors'),
        _buildFooterLink(context, 'Contact', isMobile, '/contact'),
      ],
    );
  }

  Widget _buildProductsSection(
      BuildContext context, double screenWidth, bool isMobile, bool isTablet) {
    final productsId = Provider.of<ProductProvider>(context).productsId;
    // print("Products ID in footer: $productsId");
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      if (productProvider.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (productsId.isEmpty) {
        return Center(
          child: Text(
            'No Products Available',
            style: TextStyle(color: textColor),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Products',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: isMobile ? 15 : 20),
          ...productsId.take(5).map((product) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFooterLink(context, product['name'].toString(),
                      isMobile, '/products/${product['id']}'),
                  // SizedBox(height: isMobile ? 10 : 12),
                ],
              )),
        ],
      );
    });
  }

  Widget _buildContactSection(
      double screenWidth, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: isMobile ? 15 : 20),
        Row(
          children: [
            Icon(
              Icons.phone_outlined,
              color: textColor,
              size: isMobile ? 14 : 16,
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Text(
              '+91 91826 64777',
              style: TextStyle(
                color: textColor,
                fontSize: isMobile ? 11 : 13,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 10 : 12),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              color: textColor,
              size: isMobile ? 14 : 16,
            ),
            SizedBox(width: isMobile ? 6 : 8),
            Expanded(
              child: Text(
                'techaroinnovpvtltd@gmail.com',
                style: TextStyle(
                  color: textColor,
                  fontSize: isMobile ? 11 : 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(
      BuildContext context, String text, bool isMobile, String path) {
    return TextButton(
      onPressed: () => context.go(path),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: isMobile ? 11 : 13,
        ),
      ),
    );
  }

  Widget _buildSocialIcons(double screenWidth, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _socialIcon('assets/icons/youtube.png', '', isMobile),
        SizedBox(width: isMobile ? 10 : 15),
        _socialIcon('assets/icons/linkedin.png', '', isMobile),
        SizedBox(width: isMobile ? 10 : 15),
        _socialIcon('assets/icons/insta.png', '', isMobile),
      ],
    );
  }

  Widget _socialIcon(String iconPath, String url, bool isMobile) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        width: isMobile ? 30 : 40,
        height: isMobile ? 30 : 45,
        padding: EdgeInsets.all(isMobile ? 4 : 6),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              color: Colors.grey.shade400,
              size: isMobile ? 16 : 20,
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty && !await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
