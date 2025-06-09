import 'package:flutter/material.dart';
import 'package:pelviease_website/app/providers.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';

import 'app/go_router_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp.router(
        title: 'Pelviease',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
