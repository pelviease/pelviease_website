import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/screens/about_us/about_us.dart';
import 'package:pelviease_website/screens/auth/auth_screen.dart';
import 'package:pelviease_website/screens/blogs/blogs_screen.dart';
import 'package:pelviease_website/screens/cart/cart_screen.dart';
import 'package:pelviease_website/screens/contact/contact_screen.dart';
import 'package:pelviease_website/screens/doctors/doctors_screen.dart';
import 'package:pelviease_website/screens/home/home_screen.dart';
import 'package:pelviease_website/screens/orders/checkout_screen.dart';
import 'package:pelviease_website/screens/orders/order_screen.dart';
import 'package:pelviease_website/screens/orders/payments/payment_test_screen.dart';
import 'package:pelviease_website/screens/products/products_screen.dart';
import 'package:pelviease_website/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../screens/orders/payment_status_screen.dart';
import '../screens/policies/delivery_policy_screen.dart';
import '../screens/policies/privacy_policy_screen.dart';
import '../screens/policies/terms_and_conditions_screen.dart';
import '../screens/product_details/product_details.dart';
import 'error_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  errorBuilder: (context, state) {
    return const ErrorPage404();
  },
  routes: [
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) {
    //     return const LoginScreen();
    //   },
    // ),
    // GoRoute(
    //   path: '/signup',
    //   builder: (context, state) {
    //     return const SignupScreen();
    //   },
    // ),
    GoRoute(
      path: "/authentication",
      name: 'authScreen',
      redirect: (BuildContext context, GoRouterState state) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // if (authProvider.user == null) {
        //   await authProvider.checkCurrentUser();
        // }
        if (authProvider.isAuthenticated) {
          return '/';
        }

        // final bool isLoggedIn = authProvider.isAuthenticated;

        // if (isLoggedIn) {
        //   return '/';
        // }
        return null;
      },
      builder: (context, state) {
        return AuthScreen(isLogin: true);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          // builder: (context, state) => const HomeScreen(),
          builder: (context, state) => const PaymentTestScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutUsScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductsScreen(),
          routes: [
            GoRoute(
              path: ':productId',
              name: 'productDetails',
              builder: (context, state) {
                final productId = state.pathParameters['productId'];
                return ProductDetailsScreen(productId: productId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/blogs',
          builder: (context, state) => const BlogsScreen(),
        ),
        GoRoute(
          path: '/doctors',
          builder: (context, state) => const DoctorsScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
        GoRoute(
            path: "/cart",
            name: 'cartScreen',
            builder: (context, state) {
              return const CartScreen();
            }),
        GoRoute(
          path: '/checkout',
          name: 'checkoutScreen',
          builder: (context, state) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            return CheckoutScreen(
              userId: authProvider.user?.id ?? '',
              userName: authProvider.user?.name ?? '',
              phoneNumber: authProvider.user?.phoneNumber ?? '',
            );
          },
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) {
            return MyOrdersScreen();
          },
        ),
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) {
            return PrivacyPolicyScreen();
          },
        ),
        GoRoute(
          path: '/terms-and-conditions',
          builder: (context, state) {
            return TermsAndConditionsScreen();
          },
        ),
        GoRoute(
          path: '/delivery-policy',
          builder: (context, state) {
            return DeliveryPolicyScreen();
          },
        ),
        GoRoute(
          path: '/payment-test',
          builder: (context, state) {
            return const PaymentTestScreen();
          },
        ),
        GoRoute(
            path: '/paymentStatus/:transactionId',
            builder: (context, state) {
              final transactionId = state.pathParameters['transactionId'];
              return PaymentStatusScreen(transactionId: transactionId);
            })
      ],
    ),
  ],
);
