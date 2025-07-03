import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
                        Icon(Icons.gavel, color: Colors.deepPurple, size: isMobile ? 32 : 40),
                        SizedBox(width: 12),
                        Text(
                          'Terms and Conditions',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 22 : 30,
                                color: Colors.deepPurple[800],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'These terms govern your use of the PelviEase™ website and your interaction with our products.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: isMobile ? 14 : 16),
                    ),
                    const SizedBox(height: 24),
                    Divider(thickness: 1.2, color: Colors.deepPurple[100]),
                    const SizedBox(height: 16),
                    Text('1. Product Use Disclaimer:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• PelviEase™ devices are designed to support pelvic health and wellness', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• They are not a substitute for medical diagnosis or treatment', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Always consult a healthcare professional before beginning use', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('2. Intellectual Property:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• All content, logos, and product designs under PelviEase™ are the property of TECHARO INNOV PVT LTD', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Reproduction, resale, or unauthorized use is strictly prohibited', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('3. Pricing and Payments:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• All prices are listed in INR and inclusive of applicable taxes', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• We reserve the right to change prices at any time without prior notice', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Orders may be canceled or refunded at our discretion in case of pricing errors or stock unavailability', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('4. Limitation of Liability:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('TECHARO INNOV PVT LTD is not responsible for:', style: Theme.of(context).textTheme.bodyMedium),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Improper use of products', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Delay in deliveries caused by third-party logistics', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Minor side effects if products are used without professional guidance', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('5. Governing Law:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('These terms are governed by the laws of India, and any disputes will be resolved in the jurisdiction of Hyderabad, Telangana.', style: Theme.of(context).textTheme.bodyMedium),
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