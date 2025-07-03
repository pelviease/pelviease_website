import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 700,
              ),
              margin: EdgeInsets.symmetric(
                vertical: isMobile ? 16 : 32,
                horizontal: isMobile ? 8 : 24,
              ),
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 20 : 32,
                horizontal: isMobile ? 12 : 32,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.privacy_tip, color: Colors.deepPurple, size: isMobile ? 32 : 40),
                        SizedBox(width: 12),
                        Text(
                          'Privacy Policy',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 24 : 32,
                                color: Colors.deepPurple[800],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'At TECHARO INNOV PVT LTD, we prioritize your privacy. This policy explains how we collect, use, and protect your personal data when you visit our website or purchase our products.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 14 : 16),
                    ),
                    const SizedBox(height: 24),
                    Divider(thickness: 1.2, color: Colors.deepPurple[100]),
                    const SizedBox(height: 16),
                    Text('1. Information We Collect:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Name, address, email, and contact number', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Payment and billing details (processed securely through payment gateways)', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Device and browsing data (for analytics and improvements)', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('2. Use of Information:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• To process orders and deliver products', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• To send updates, promotions, and offers (only with your consent)', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• To enhance website performance and user experience', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('3. Data Protection:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('We implement security measures including SSL encryption, secure hosting, and trusted third-party payment processors.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    Text('4. Sharing of Data:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('We do not sell, rent, or share your personal information with any third party, except:', style: Theme.of(context).textTheme.bodyMedium),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Delivery partners (for shipping)', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Payment processors (for transactions)', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('5. User Rights:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('You may access, update, or delete your personal data by contacting support@techaro.in. We will respond within 7 days.', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}