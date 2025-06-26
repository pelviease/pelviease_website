import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuth;
  final bool isAuthenticated;
  const CustomAppBar(
      {super.key, this.isAuth = false, this.isAuthenticated = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    bool isMobile = MediaQuery.of(context).size.width < 720;
    final GlobalKey dropdownKey = GlobalKey();

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
                context.go('/');
              },
              child: Image.asset(
                'assets/logo_with_tm.png',
                height: 24,
              ),
            ),
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
                      context.goNamed('authScreen');
                    },
                    style: ElevatedButton.styleFrom().copyWith(
                      backgroundColor: WidgetStateProperty.all(buttonColor),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    child: Text("Login"),
                  ),
                ],
              ),
            if (!isMobile && !isAuth && isAuthenticated)
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
                    key: dropdownKey,
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final RenderBox? button = dropdownKey.currentContext
                          ?.findRenderObject() as RenderBox?;
                      final RenderBox? overlay = Overlay.of(context)
                          .context
                          .findRenderObject() as RenderBox?;
                      if (button == null || overlay == null) return;

                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(
                              button.size.bottomRight(Offset.zero),
                              ancestor: overlay),
                        ),
                        Offset.zero & overlay.size,
                      );

                      final value = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          position.left,
                          position.top + 8,
                          position.right,
                          position.bottom,
                        ),
                        items: <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Profile',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'orders',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Orders',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(height: 1),
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        elevation: 4,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(minWidth: 160),
                      );

                      if (value == 'profile') {
                        context.go('/orders');
                      } else if (value == 'orders') {
                        context.go('/orders');
                      } else if (value == 'logout') {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              title: Text(
                                'Logout',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              content: Text(
                                'Are you sure you want to logout?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final authProvider =
                                        context.read<AuthProvider>();
                                    authProvider.logout();
                                    Navigator.of(context).pop();
                                    Future.microtask(() => context.go('/'));
                                  },
                                  child: Text(
                                    'Logout',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 24,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.user?.name.split(' ').first ?? 'User',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
