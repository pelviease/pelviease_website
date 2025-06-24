import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
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
          children: [
            InkWell(
              onTap: () {
                // Scaffold.of(context).openDrawer();
                context.go('/');
              },
              child: Image.asset(
                'assets/icons/logo.png',
                height: 46,
              ),
            ),
            // if (isMobile)
            //   Text(
            //     "pelviease",
            //     style: Theme.of(context).textTheme.titleLarge?.copyWith(),
            //   ),
            if (!isMobile && !isAuth)
              Row(
                children: [
                  _navItem("Home", context, "/"),
                  _navItem("About Us", context, "/about"),
                  _navItem("Products", context, "/products"),
                  _navItem("Blogs", context, "/blogs"),
                  _navItem("Doctors", context, "/doctors"),
                  _navItem("Contact", context, "/contact"),
                ],
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
            // if (!isMobile)
            //   (provider.user != null && provider.currentUserModel != null)
            //       ? DropdownButtonHideUnderline(
            //           child: DropdownButton<String>(
            //           value: username!,
            //           icon: const Icon(Icons.arrow_drop_down,
            //               color: Colors.amberAccent),
            //           items: [
            //             DropdownMenuItem(
            //               value: username,
            //               child: Text(username),
            //             ),
            //             const DropdownMenuItem(
            //               value: 'logout',
            //               child: Text("Logout"),
            //             ),
            //           ],
            //           onChanged: (String? value) {
            //             if (value == 'logout') {
            //               provider.logout(); // refresh UI
            //             }
            //           },
            //         ))
            //       : ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 12, vertical: 8),
            //             backgroundColor: secondaryColor,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(8),
            //             ),
            //           ),
            //           onPressed: () {
            //             if (currentuser != null) {
            //               provider.logout();
            //             } else {
            //               bool authSuccessful = false;
            //               showDialog(
            //                 context: context,
            //                 builder: (dialogContext) {
            //                   return Dialog(
            //                     backgroundColor: Colors.white,
            //                     child: SizedBox(
            //                       height:
            //                           MediaQuery.sizeOf(context).height * 0.8,
            //                       width: MediaQuery.sizeOf(context).width * 0.4,
            //                       child: Consumer<AuthProvider>(
            //                         builder: (context, auth, _) {
            //                           if (auth.currentUserModel != null &&
            //                               !authSuccessful) {
            //                             authSuccessful = true;

            //                             WidgetsBinding.instance
            //                                 .addPostFrameCallback((_) {
            //                               Navigator.of(dialogContext).pop(true);
            //                             });
            //                           }

            //                           return GradientBoxAuth(
            //                             radius: 16,
            //                             height:
            //                                 MediaQuery.sizeOf(context).height *
            //                                     0.8,
            //                             width:
            //                                 MediaQuery.sizeOf(context).width *
            //                                     0.4,
            //                             child: auth.page.widget,
            //                           );
            //                         },
            //                       ),
            //                     ),
            //                   );
            //                 },
            //               ).then((_) {
            //                 final authProvider = Provider.of<AuthProvider>(
            //                     context,
            //                     listen: false);

            //                 authProvider.setPage(Pages.login);
            //               });
            //             }

            //             // // Navigator.pushNamed(context, JoinPage.joinPageRoute);
            //             // context.go("/joinus");
            //           },
            //           child: Text(
            //             "Login",
            //             style: Theme.of(context).textTheme.titleMedium,
            //           ),
            //         ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: cyclamen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.go(route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontSize: 20,
                  // fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
