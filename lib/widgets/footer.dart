import 'package:flutter/material.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Part (up to the image)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    const Text(
                      'PELVI',
                      style: TextStyle(
                        color: buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Ease',
                      style: TextStyle(
                        color: const Color(0xFFFF0049).withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      '™',
                      style: TextStyle(
                        color: Color(0xFF8B4A8B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: textColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'H.NO. 7-1-302/45/4, 5th Floor B.K Guda, Sanjeev Reddy Nagar,\nAmeerp et, Hyderabad-500038, Telangana.',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                // Illustration
                Center(
                  child: SizedBox(
                    height: 230,
                    width: 600,
                    child: Image.asset(
                      'assets/icons/footer.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.grey.shade400,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 60),
          // Right Part (remaining sections)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Our Company Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Our Company',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFooterLink('About US'),
                          const SizedBox(height: 12),
                          _buildFooterLink('Products'),
                          const SizedBox(height: 12),
                          _buildFooterLink('Blogs'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Products Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFooterLink('Dilator 1'),
                          const SizedBox(height: 12),
                          _buildFooterLink('Dilator 2'),
                          const SizedBox(height: 12),
                          _buildFooterLink('Dilator 3'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Contact Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: textColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+91 91826 64777',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: textColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'techaroinnovpvtltd@gmail.com',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 13,
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
                const SizedBox(height: 40),
                // R&D Center Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: textColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'R&D CENTER :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'JTBI , Admissions Block , Jawaharlal Nehru Technological University,\nHyderabad,Telangana-500085.',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Bottom Footer Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '© 2025 Pelviease. All rights reserved.    Powered by @Octovu',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    _buildSocialIcons(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for footer links
  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textColor,
        fontSize: 13,
      ),
    );
  }

  // Social icons
  Widget _buildSocialIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _socialIcon('assets/icons/twitter.png', 'https://x.com/Ecellvitb'),
        const SizedBox(width: 15),
        _socialIcon('assets/icons/linkedin.png', ""),
        const SizedBox(width: 15),
        _socialIcon('assets/icons/insta.png', ""),
        const SizedBox(width: 15),
      ],
    );
  }

  // Individual social icon
  Widget _socialIcon(String iconPath, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              color: Colors.grey.shade400,
              size: 20,
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
