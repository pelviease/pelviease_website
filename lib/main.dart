import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pelviease_website/app/providers.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'app/go_router_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase Functions emulator for local testing
  if (kDebugMode) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5002);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Pelviease',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}

// hosting command
// firebase deploy --only hosting:pelviease-website
