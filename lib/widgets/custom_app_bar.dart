import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/const/theme.dart';
// import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuth;
  const CustomAppBar({super.key, this.isAuth = false});

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AuthProvider>(context);
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
            if (!isMobile && !isAuth)
              Row(
                children: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // context.go("/signup");

                  //       context.go('/auth?mode=signup');
                  //     },
                  //     style: ElevatedButton.styleFrom().copyWith(
                  //       backgroundColor: WidgetStateProperty.all(lightViolet),
                  //       foregroundColor: WidgetStateProperty.all(textColor),
                  //     ),
                  //     child: Text("Signup")),
                  // SizedBox(
                  //   width: 12,
                  // ),
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
