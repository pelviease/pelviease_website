import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const EmptyCartWidget({
    super.key,
    this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.7,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: isTablet ? 140 : 120,
                  height: isTablet ? 140 : 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 8,
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: isTablet ? 70 : 60,
                    color: Colors.grey[400],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: isTablet ? 40 : 32),

          // Main Title
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isTablet ? 16 : 12),

          // Subtitle
          Container(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 400 : 280,
            ),
            child: Text(
              'Looks like you haven\'t added anything to your cart yet. Start shopping to fill it up!',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: isTablet ? 24 : 18),

          // Continue Shopping Button
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: isTablet ? 300 : 250,
            ),
            child: ElevatedButton(
              onPressed: onContinueShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 18 : 16,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: isTablet ? 22 : 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
