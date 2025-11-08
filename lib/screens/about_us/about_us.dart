import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/widgets/footer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget _buildHeroCard(String imagePath, Color backgroundColor, double height,
    double width, bool isMobile) {
  return Container(
    width: width,
    height: height,
    margin: isMobile ? EdgeInsets.symmetric(horizontal: 10) : null,
    decoration: BoxDecoration(
      color: backgroundColor.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.15),
      //     spreadRadius: 3,
      //     blurRadius: 10,
      //     offset: const Offset(0, 4),
      //   ),
      // ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: backgroundColor,
            child: Icon(
              Icons.medical_services,
              size: isMobile ? 20 : 40,
              color: Colors.grey.shade600,
            ),
          );
        },
      ),
    ),
  );
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;
    bool isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context, screenHeight, screenWidth, isMobile),

            // Vision and Mission Section
            _buildVisionMissionSection(context, isMobile, isTablet),

            // Pelvicare Section
            _buildPelvicareSection(
                context, screenHeight, screenWidth, isMobile, isTablet),

            SizedBox(height: isMobile ? 20 : 40),

            // TECHARO Section
            _buildTecharoSection(
                context, screenHeight, screenWidth, isMobile, isTablet),

            SizedBox(height: isMobile ? 40 : 60),

            // Team Members Section
            _buildTeamSection(context, isMobile),

            // Stop Silent Suffering Section
            _buildStopSilentSufferingSection(context, screenWidth, isMobile),

            // Footer
            FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, double screenHeight,
      double screenWidth, bool isMobile) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: isMobile ? screenHeight * 0.5 : screenHeight * 0.7,
        ),
        Container(
          width: double.infinity,
          height: isMobile ? screenHeight * 0.4 : screenHeight * 0.67,
          decoration: const BoxDecoration(color: buttonColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'About US',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
                child: Center(
                  child: Text(
                    isMobile
                        ? 'We support your journey through incontinence, postpartum recovery, and pelvic strength — with care and innovation.'
                        : 'We support your journey through incontinence, postpartum recovery, and pelvic \n strength — with care and innovation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isMobile ? 14 : 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: isMobile ? screenHeight * 0.05 : screenHeight * 0.25),
            ],
          ),
        ),
        Positioned(
          top: isMobile ? screenHeight * 0.35 : screenHeight * 0.55,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: isMobile ? screenHeight * 0.1 : screenHeight * 0.2,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.elliptical(isMobile ? 200 : 300, isMobile ? 30 : 50),
                topRight: Radius.elliptical(isMobile ? 150 : 200, 10),
              ),
            ),
          ),
        ),
        Positioned(
          top: isMobile ? screenHeight * 0.28 : screenHeight * 0.4,
          left: 0,
          right: 0,
          child: isMobile
              ? _buildMobileHeroCards()
              : _buildDesktopHeroCards(screenHeight, screenWidth),
        ),
      ],
    );
  }

  Widget _buildMobileHeroCards() {
    return SizedBox(
      height: 200,
      child: _MobileHeroCardsPageView(),
    );
  }

  Widget _buildDesktopHeroCards(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeroCard(
          'assets/team/about1.JPG',
          const Color(0xFFE3F2FD),
          screenHeight * 0.27,
          screenWidth * 0.17,
          false,
        ),
        const SizedBox(width: 15),
        _buildHeroCard(
          'assets/team/about2.jpg',
          const Color(0xFFFFE4E1),
          screenHeight * 0.2,
          screenWidth * 0.15,
          false,
        ),
        const SizedBox(width: 15),
        _buildHeroCard(
          'assets/team/about3.jpg',
          const Color(0xFFFFE4E1),
          screenHeight * 0.24,
          screenWidth * 0.11,
          false,
        ),
        const SizedBox(width: 15),
        _buildHeroCard(
          'assets/team/about4.jpg',
          const Color(0xFFE8F5E8),
          screenHeight * 0.25,
          screenWidth * 0.18,
          false,
        ),
      ],
    );
  }

  Widget _buildVisionMissionSection(
      BuildContext context, bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: isMobile
          ? Column(
              children: [
                _buildVisionCard(),
                const SizedBox(height: 20),
                _buildMissionCard(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildVisionCard()),
                const SizedBox(width: 30),
                Expanded(child: _buildMissionCard()),
              ],
            ),
    );
  }

  Widget _buildVisionCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0049).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: textColor),
              const SizedBox(width: 10),
              Text(
                'VISION',
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'To be the leading innovator in women’s health, empowering women through accessible, evidence-based medical technologies.\n ',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Color(0xFFF4E1F5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.handshake_outlined, color: textColor),
              const SizedBox(width: 10),
              Text(
                'MISSION',
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'To design and deliver smart, user-friendly diagnostic and rehabilitation devices that address pelvic health issues and postpartum health issues such as urinary incontinence, sexual dysfunction, and postpartum recovery: Diastasis recti , breast engorgement.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPelvicareSection(BuildContext context, double screenHeight,
      double screenWidth, bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: isMobile
          ? _buildPelvicareContent(screenWidth, isMobile)
          : Row(
              children: [
                Expanded(
                  flex: isTablet ? 6 : 7,
                  child: _buildPelvicareContent(screenWidth, isMobile),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: isTablet ? 4 : 3,
                  child:
                      _buildPelvicareImage(screenHeight, screenWidth, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildPelvicareContent(double screenWidth, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 25 : 40),
      decoration: BoxDecoration(
        color: const Color(0xFFFF0049).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PELVIEaSe',
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'At PelviEase, we stand as pioneers in Femtech in India. We are dedicated to revolutionizing pelvic health by raising awareness, fighting stigmas, and offering innovative & accessible solutions. So, if you\'re dealing with urinary incontinence, postpartum recovery, or general pelvic floor weakness, PelviEase is here to support your journey towards better health',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              height: 1.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPelvicareImage(
      double screenHeight, double screenWidth, bool isMobile) {
    return Container(
      height: screenHeight * 0.32,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/pelviease-website.firebasestorage.app/o/const%2Fskull.jpg?alt=media&token=cb7ac5b4-6217-4184-b844-29dac62d3779',
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFFF0049).withOpacity(0.2),
              child: Icon(
                Icons.medical_services,
                size: 40,
                color: Colors.grey.shade600,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTecharoSection(BuildContext context, double screenHeight,
      double screenWidth, bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: isMobile
          ? _buildTecharoContent(screenWidth, isMobile)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: isTablet ? 4 : 3,
                  child:
                      _buildTecharoImage(screenHeight, screenWidth, isMobile),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: isTablet ? 6 : 7,
                  child: _buildTecharoContent(screenWidth, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildTecharoImage(
      double screenHeight, double screenWidth, bool isMobile) {
    return Container(
      height: screenHeight * 0.31,
      width: screenWidth * 0.28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/pelviease-website.firebasestorage.app/o/const%2Ftecharo_aboutus.jpg?alt=media&token=c7181e5b-8f4c-4e04-a783-ac421ddc4eb2'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTecharoContent(double screenWidth, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 20 : 30,
        horizontal: isMobile ? 25 : 40,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TECHARO',
            style: TextStyle(
              fontSize: isMobile ? 24 : 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Techaro is a medical device company focused on women\'s health\n\nWe combine advanced research and expert manufacturing to deliver precise, safe, and reliable products that are transforming MedTech in India. Our goal is to provide affordable, high-quality solutions for critical healthcare needs. Beyond products, we\'re committed to raising awareness, improving accessibility, and creating real impact.',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Text(
            'OUR TEAM',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 20 : 40),
          child: Column(
            children: [
              Text(
                'Team Members',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 30),
              isMobile
                  ? Column(
                      children: [
                        _buildTeamMember(
                          'NISHANTH KUMAR MARTHA',
                          'Chief Executive Officer',
                          'assets/team/ceo.jpg',
                          isMobile,
                        ),
                        const SizedBox(height: 30),
                        _buildTeamMember(
                          'RUGVEDH GOPARI',
                          'Chief Technology Officer',
                          'assets/team/cto.jpg',
                          isMobile,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTeamMember(
                          'NISHANTH KUMAR MARTHA',
                          'Chief Executive Officer',
                          'assets/team/ceo.jpg',
                          isMobile,
                        ),
                        const SizedBox(width: 30),
                        _buildTeamMember(
                          'RUGVEDH GOPARI',
                          'Chief Technology Officer',
                          'assets/team/cto.jpg',
                          isMobile,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStopSilentSufferingSection(
      BuildContext context, double screenWidth, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '#STOPSILENT',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: buttonColor,
                  ),
                ),
                TextSpan(
                  text: 'SUFFERING',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : screenWidth * 0.7,
              ),
              child: Text(
                'At PelviEase, we go beyond just creating medical devices-we are building a movement. We are dedicated to making pelvic health a normalized, mainstream discussion, ensuring that accurate information, expert guidance, and supportive communities are available to all.\nJoin us in our mission to stop these silent sufferings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'With PelviEase, heal with dignity',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: buttonColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
      String name, String role, String imagePath, bool isMobile) {
    double cardWidth = isMobile ? 250 : 270;
    double cardHeight = isMobile ? 320 : 350;
    double imageHeight = isMobile ? 270 : 300;

    return Stack(
      children: [
        SizedBox(
          width: cardWidth,
          height: cardHeight,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: cardWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: cardWidth,
                    height: imageHeight,
                    color: backgroundColor,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
        Positioned(
          bottom: 25,
          left: 3,
          right: 3,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: backgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileHeroCardsPageView extends StatefulWidget {
  @override
  _MobileHeroCardsPageViewState createState() =>
      _MobileHeroCardsPageViewState();
}

class _MobileHeroCardsPageViewState extends State<_MobileHeroCardsPageView> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _heroCards = [
    {
      'imagePath': 'assets/team/about1.jpg',
      'backgroundColor': Color(0xFFE3F2FD),
    },
    {
      'imagePath': 'assets/team/about2.jpg',
      'backgroundColor': Color(0xFFFFE4E1),
    },
    {
      'imagePath': 'assets/team/about3.jpg',
      'backgroundColor': Color(0xFFFFE4E1),
    },
    {
      'imagePath': 'assets/team/about4.jpg',
      'backgroundColor': Color(0xFFE8F5E8),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.4,
      initialPage: 0,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _heroCards.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _heroCards.length,
            itemBuilder: (context, index) {
              return _buildHeroCard(
                _heroCards[index]['imagePath'],
                _heroCards[index]['backgroundColor'],
                50,
                50,
                true,
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: _heroCards.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: buttonColor,
            dotColor: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
