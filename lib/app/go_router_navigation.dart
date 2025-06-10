import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/screens/about_us/about_us.dart';
import 'package:pelviease_website/screens/auth/auth_screen.dart';
import 'package:pelviease_website/screens/blogs/blogs_screen.dart';
import 'package:pelviease_website/screens/contact/contact_screen.dart';
import 'package:pelviease_website/screens/home/home_screen.dart';
import 'package:pelviease_website/screens/products/products_screen.dart';
import 'package:pelviease_website/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

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

        if (authProvider.user == null) {
          await authProvider.checkCurrentUser();
        }

        final bool isLoggedIn = authProvider.isAuthenticated;

        if (isLoggedIn) {
          return '/';
        }
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
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutUsScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductsScreen(),
        ),
        GoRoute(
          path: '/blogs',
          builder: (context, state) => const BlogsScreen(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactScreen(),
        ),
        // GoRoute(
        //     path: '/events',
        //     builder: (context, state) => const EventsScreen(),
        //     routes: [
        //       GoRoute(
        //         path: ':eventParam',
        //         builder: (context, state) {
        //           final eventData =
        //               state.extra is Event ? state.extra as Event : null;

        //           if (eventData != null) {
        //             return EventDetails(event: eventData);
        //           }

        //           final param = state.pathParameters['eventParam'] ?? '';
        //           final eventId = param.split('-').first;

        //           return FutureBuilder<Event?>(
        //             future: Provider.of<EventProvider>(context, listen: false)
        //                 .getEventById(eventId),
        //             builder: (context, snapshot) {
        //               if (snapshot.connectionState == ConnectionState.waiting) {
        //                 return const Scaffold(
        //                   body: ParticleBackground(
        //                     child: Center(
        //                       child: CircularProgressIndicator(
        //                         color: secondaryColor,
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               }

        //               if (snapshot.hasError || !snapshot.hasData) {
        //                 return const EventsScreen();
        //               }

        //               return EventDetails(event: snapshot.data!);
        //             },
        //           );
        //         },
        //         redirect: (context, state) async {
        //           if (state.extra is Event) {
        //             return null;
        //           }

        //           final param = state.pathParameters['eventParam'] ?? '';
        //           if (param.isEmpty) {
        //             return '/events';
        //           }

        //           final eventId = param.split('-').first;
        //           if (eventId.isEmpty) {
        //             return '/events';
        //           }

        //           final eventProvider =
        //               Provider.of<EventProvider>(context, listen: false);
        //           final event = await eventProvider.getEventById(eventId);

        //           if (event == null) {
        //             return '/events';
        //           }

        //           return null;
        //         },
        //       )
        // ]),
        // GoRoute(
        //   path: '/team',
        //   builder: (context, state) => const TeamScreen(),
        //   routes: [
        // GoRoute(
        //   path: 'recruitment',
        //   name: 'recruitmentScreen',
        //   builder: (context, state) => const UserOpenRecruitmentsList(),
        // ),
        // GoRoute(
        //   path: 'recruitment/:id/:department',
        //   name: 'recruitmentApplications',
        //   builder: (context, state) {
        //     final recruitmentId = state.pathParameters['id']!;
        //     final department = state.pathParameters['department']!;
        //     return RecruitmentFormScreen(
        //       recruitmentId: recruitmentId,
        //       dept: department,
        //     );
        //   },
        // ),
        // ],
        // ),

        // GoRoute(
        //     path: '/onGoingEvents',
        //     builder: (context, state) => const OngoingEventsPage(),
        //     routes: [
        // GoRoute(
        //   path: ':eventId',
        //   builder: (context, state) {
        //     final eventId = state.pathParameters['eventId']!;
        //     return OngoingEventDetails(eventId: eventId);
        //   },
        // ),
        // GoRoute(
        //   path: '/register/:eventId',
        //   builder: (context, state) {
        //     final eventId = state.pathParameters['eventId']!;
        //     return OngoingEventRegister(
        //       eventId: eventId,
        //     );
        //   },
        // ),
        // ]),
        // GoRoute(
        //   path: '/joinus',
        //   builder: (context, state) => const HomeScreen(section: 'footer'),
        // ),
      ],
    ),
  ],
);
