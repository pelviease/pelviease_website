import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/widgets/footer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.7,
                ),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.67,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: buttonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'About US',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Center(
                            child: Text(
                              'We support your journey through incontinence, postpartum recovery, and pelvic \n strength — with care and innovation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.25),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.55,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.2,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(300, 50),
                        topRight: Radius.elliptical(200, 10),
                      ),
                    ),
                    child: SizedBox(),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.4,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeroCard(
                          'assets/aboutus_images/image1.png',
                          const Color(0xFFE3F2FD),
                          screenHeight * 0.27,
                          screenWidth * 0.17),
                      const SizedBox(width: 15),
                      _buildHeroCard(
                          'assets/aboutus_images/image2.png',
                          const Color(0xFFFFE4E1),
                          screenHeight * 0.2,
                          screenWidth * 0.15),
                      const SizedBox(width: 15),
                      _buildHeroCard(
                          'assets/aboutus_images/image3.png',
                          const Color(0xFFFFE4E1),
                          screenHeight * 0.24,
                          screenWidth * 0.11),
                      const SizedBox(width: 15),
                      _buildHeroCard(
                          'assets/aboutus_images/image4.png',
                          const Color(0xFFE8F5E8),
                          screenHeight * 0.25,
                          screenWidth * 0.18),
                    ],
                  ),
                ),
              ],
            ),

            // Vision and Mission Section
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(50),
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
                                    fontSize: 30,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'PelviEase is India’s leading Femtech brand, transforming pelvic health for women. We support your journey through incontinence, postpartum recovery, and pelvic wellness — with innovation and care.',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(50),
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
                                    fontSize: 30,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'At PelviEase, we innovate pelvic care devices, empower women through education, collaborate with health experts, and make advanced, affordable healthcare accessible to women across India.',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pelvicare Section
            SizedBox(
              height: screenHeight * 0.37,
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(50),
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
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: screenWidth * 0.5,
                            child: const Text(
                              'At PelviEase, we stand as pioneers in Femtech in India. We are dedicated to revolutionizing pelvic health by raising awareness, fighting stigmas, and offering innovative & accessible solutions. So, if you’re dealing with urinary incontinence, postpartum recovery, or general pelvic floor weakness, PelviEase is here to support your journey towards better health',
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      )),
                  // const SizedBox(width: 20),
                  SizedBox(
                      height: screenHeight * 0.37,
                      width: screenWidth * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(
                          'assets/aboutus_images/pelviease.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                      )),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // TECHARO Section
            SizedBox(
              height: screenHeight * 0.4,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.39,
                    width: screenWidth * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: AssetImage('assets/aboutus_images/techaro.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
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
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TECHARO',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: screenWidth * 0.56,
                              child: const Text(
                                'Techaro is a medical device company focused on women’s health \n \n We combine advanced research and expert manufacturing to deliver precise, safe, and reliable products that are transforming MedTech in India. Our goal is to provide affordable, high-quality solutions for critical healthcare needs. Beyond products, we’re committed to raising awareness, improving accessibility, and creating real impact.',
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Team Members Section

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
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const Text(
                    'Team Members',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTeamMember(
                        'NISHANTH KUMAR MARTHA',
                        'Chief Executive Officer',
                        'assets/aboutus_images/nishanth.png',
                      ),
                      const SizedBox(width: 30),
                      _buildTeamMember(
                        'RUGVEDH GOPARI',
                        'Chief Technology Officer',
                        'assets/aboutus_images/rugvedh.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stop Silent Suffering Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '#STOPSILENT',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                        TextSpan(
                          text: 'SUFFERING',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.5,
                      child: const Text(
                        'At PelviEase, we go beyond just creating medical devices-we are building a movement. We are dedicated to making pelvic health a normalized, mainstream discussion, ensuring that accurate information, expert guidance, and supportive communities are available to all.\nJoin us in our mission to stop these silent sufferings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  )
                ],
              ),
            ),

            // Footer
            FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(
      String imagePath, Color backgroundColor, double height, double width) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                size: 40,
                color: Colors.grey.shade600,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imagePath) {
    return Stack(children: [
      SizedBox(
        width: 270,
        height: 350,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imagePath,
              width: 270,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
