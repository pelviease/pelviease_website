import 'package:flutter/material.dart';

class DeliveryPolicyScreen extends StatelessWidget {
  const DeliveryPolicyScreen({super.key});

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
                        Icon(Icons.local_shipping, color: Colors.deepPurple, size: isMobile ? 32 : 40),
                        SizedBox(width: 12),
                        Text(
                          'Delivery Policy',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 24 : 32,
                                color: Colors.deepPurple[800],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('1. SHIPPING POLICY', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 12),
                    Text('1. Order Processing Time:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Orders are typically processed within 1–2 business days (Monday to Friday, excluding public holidays). Orders placed on weekends or holidays will be processed the next business day.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text('2. Shipping Methods & Timeframes:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('We partner with leading courier services to ensure timely and reliable delivery. Estimated delivery times:', style: Theme.of(context).textTheme.bodyMedium),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Metro cities: 2–4 business days', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Tier 2 and rural areas: 5–7 business days', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Remote areas: 7–10 business days', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Text('Delays may occur due to courier partner issues, weather conditions, or regional lockdowns.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text('3. Shipping Charges:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Free shipping on orders above ₹10,000', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• A flat rate of ₹50 applies to orders below ₹10,000', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('4. Order Tracking:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Once shipped, you will receive an email and SMS with a tracking number and courier partner details. You can track your order using the provided link.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text('5. Delivery Issues:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('If your package is delayed or appears lost, please reach out to us at support@techaro.in with your order ID. We’ll coordinate with the courier to resolve the issue.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Divider(thickness: 1.2, color: Colors.deepPurple[100]),
                    const SizedBox(height: 16),
                    Text('2. RETURN POLICY', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 12),
                    Text('Due to the personal and medical nature of our products, returns are only accepted under the following conditions:', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text('1. Eligible Return Reasons:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• You received a damaged or defective product', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• You received a wrong item', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('2. Conditions for Return Approval:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• You must notify us within 48 hours of delivery', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• For approved returns, the replacement product will be delivered within 7-10 business days', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Product must be unused, unopened, and in original packaging', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Include images or videos showing the issue', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Include the original invoice/order confirmation email', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('3. Non-Returnable Items:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Products that have been used or tampered with', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Products returned without original packaging', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Products purchased during sale/clearance events (unless defective)', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('How to Initiate a Return:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Send an email to support@techaro.in with your order ID, a clear description of the issue, and photos/videos. We’ll review your request and initiate a return if eligible.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Divider(thickness: 1.2, color: Colors.deepPurple[100]),
                    const SizedBox(height: 16),
                    Text('3. REFUND POLICY', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    const SizedBox(height: 12),
                    Text('1. Refund Eligibility:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Returned items (if approved)', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Orders canceled before shipment', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Damaged/defective items not replaced', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('2. Refund Process:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Once your return is received and inspected, we will notify you of the approval status', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• If approved, the refund will be Credited within 7–10 business days', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• For online payments, the amount will be refunded to the original payment method', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• For Cash on Delivery, we will request your UPI or bank details for manual transfer', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('3. Non-Refundable Scenarios:', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Delay in delivery due to logistics partner (beyond our control)', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Minor packaging dents or wear that do not affect product functionality', style: Theme.of(context).textTheme.bodyMedium),
                          Text('• Refusal to accept delivery without valid reason', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
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