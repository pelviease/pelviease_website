import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/const/theme.dart';
// import 'package:provider/provider.dart';

import 'custom_app_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProvider>(context);
    // final currentuser = provider.user;
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: Drawer(
        backgroundColor: backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 56,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // const Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "pelviease",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 30,
                    //       ),
                    //     ),
                    //     // Text(
                    //     //   "VITB",
                    //     //   style: TextStyle(
                    //     //     fontSize: 32,
                    //     //     color: secondaryColor,
                    //     //     fontFamily: "Lora",
                    //     //   ),
                    //     // ),
                    //   ],
                    // )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildDrawerNavItem("Home", context, "/"),
              _buildDrawerNavItem("About Us", context, "/about"),
              _buildDrawerNavItem("Products", context, "/products"),
              _buildDrawerNavItem("Blogs", context, "/blogs"),
              _buildDrawerNavItem("Contact", context, "/contact"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Builder(
                  builder: (context) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      // backgroundColor: secondaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: backgroundColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: child,
    );
  }

  Widget _buildDrawerNavItem(String title, BuildContext context, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Icon(
          Icons.chevron_right, // Use a subtle icon for drawer items
          size: 20,
          color:
              Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        ),
        // hoverColor: secondaryColor.withOpacity(0.1),
        splashColor: cyclamen.withOpacity(0.2),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          context.go(route); // Navigate to the specified route
        },
      ),
    );
  }
}
