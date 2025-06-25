import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuth;
  final bool isAuthenticated;
  const CustomAppBar(
      {super.key, this.isAuth = false, this.isAuthenticated = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    // final currentuser = provider.user;
    // final username = provider.username;

    // Check if the screen width is less than 768px (mobile view)
    bool isMobile = MediaQuery.of(context).size.width < 720;

    return Container(
      padding: isMobile
          ? EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // Scaffold.of(context).openDrawer();
                context.go('/');
              },
              child: Image.asset(
                'assets/logo_with_tm.png',
                height: 24,
              ),
            ),
            // if (isMobile)
            //   Text(
            //     "pelviease",
            //     style: Theme.of(context).textTheme.titleLarge?.copyWith(),
            //   ),
            if (!isMobile && !isAuth)
              Container(
                height: 46,
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    _navItem("Home", context, "/"),
                    _navItem("About Us", context, "/about"),
                    _navItem("Products", context, "/products"),
                    _navItem("Blogs", context, "/blogs"),
                    _navItem("Doctors", context, "/doctors"),
                    _navItem("Contact", context, "/contact"),
                  ],
                ),
              ),
            if (!isMobile && !isAuth && !isAuthenticated)
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).pop();

                        context.goNamed('authScreen');
                      },
                      style: ElevatedButton.styleFrom().copyWith(
                        backgroundColor: WidgetStateProperty.all(buttonColor),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text("Login"))
                ],
              ),
            if (!isMobile && !isAuth && isAuthenticated) ...[
              Row(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 28,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          context.go('/cart');
                        },
                      ),
                      Positioned(
                        right: 1,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${context.watch<CartProvider>().cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width,
                          kToolbarHeight + 10,
                          16,
                          0,
                        ),
                        items: <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'profile',
                            child: ListTile(
                              leading:
                                  Icon(Icons.person, color: Colors.black54),
                              title: Text('Profile'),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'orders',
                            child: ListTile(
                              leading: Icon(Icons.shopping_bag_outlined,
                                  color: Colors.black54),
                              title: Text('Orders'),
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: ListTile(
                              leading:
                                  Icon(Icons.logout, color: Colors.redAccent),
                              title: Text('Logout',
                                  style: TextStyle(color: Colors.redAccent)),
                            ),
                          ),
                        ],
                        elevation: 8,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).then((value) {
                        if (value == 'profile') {
                          context.go('/profile');
                        } else if (value == 'orders') {
                          context.go('/orders');
                        } else if (value == 'logout') {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final authProvider =
                                          context.read<AuthProvider>();
                                      authProvider.logout();
                                      Navigator.of(dialogContext).pop();
                                      context.go('/');
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 3,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 28,
                            color: Colors.black54,
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.black54, size: 28),
                          // if (username != null)
                          //   Text(
                          //     username,
                          //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          //           color: textColor,
                          //         ),
                          //   ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],

            if (isMobile)
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 32,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String title, BuildContext context, String route) {
    final ValueNotifier<bool> isHovered = ValueNotifier(false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          context.go(route);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: ValueListenableBuilder<bool>(
            valueListenable: isHovered,
            builder: (context, value, child) {
              return Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: value ? textColor : Colors.grey.shade700,
                      fontSize: 16,
                    ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
