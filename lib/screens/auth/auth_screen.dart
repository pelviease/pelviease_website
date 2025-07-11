import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/const/toaster.dart';
import 'package:pelviease_website/screens/auth/widgets/build_text_field.dart';
import 'package:pelviease_website/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;
  const AuthScreen({super.key, this.isLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isDoctor = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      // Clear form when switching modes
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });

    // Update the URL to reflect the current mode
    // if (_isLogin) {
    //   context.pop();
    //   context.go('/auth/?mode=login');
    // } else {
    //   context.pop();
    //   context.go('/auth/?mode=signup');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isAuth: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if we're on desktop/tablet or mobile
                bool isDesktop = constraints.maxWidth > 600;
                double maxWidth = isDesktop ? 400 : double.infinity;

                return Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: _buildAuthCard(isDesktop),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 8),
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 0 : 16,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(1, 2),
                ),
              ]
            : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              _isLogin ? 'LOGIN' : 'SIGNUP',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F1F1F),
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isDesktop ? 24 : 18),

            // Name Field - Only show for signup
            if (!_isLogin) ...[
              BuildTextField(
                controller: _nameController,
                hintText: 'Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (!_isLogin && (value == null || value.isEmpty)) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],

            // Email Field
            BuildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // Password Field
            BuildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (!_isLogin && value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            if (!_isLogin) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _isDoctor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isDoctor = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(color: Colors.grey),
                  ),
                  SizedBox(width: 8), // Space between checkbox and text
                  Text(
                    'Mark me as a Doctor',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: isDesktop ? 24 : 18),

            // Auth Button
            Consumer<AuthProvider>(builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: _handleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF543855),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isDesktop ? 18 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: provider.isLoading
                    ? SizedBox(
                        height: isDesktop ? 18 : 16,
                        width: isDesktop ? 18 : 16,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isLogin ? 'Login' : 'Create Account',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              );
            }),

            SizedBox(height: isDesktop ? 24 : 18),

            // Toggle Auth Mode Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",
                  style: TextStyle(
                    color: const Color(0xFF1F1F1F).withOpacity(0.6),
                    fontSize: isDesktop ? 16 : 14,
                  ),
                ),
                InkWell(
                  onTap: _toggleAuthMode,
                  child: Text(
                    _isLogin ? 'Sign Up' : 'Login',
                    style: TextStyle(
                      color: const Color(0xFF543855),
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAuth() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        _handleLogin();
      } else {
        _handleSignup();
      }
    }
  }

  void _handleLogin() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider
        .login(_emailController.text, _passwordController.text)
        .then((_) {
      if (authProvider.isAuthenticated) {
        showCustomToast(
            title: 'Login Successful',
            type: ToastificationType.success,
            description:
                'Login successful! Welcome ${authProvider.user!.name}');

        if (mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      } else {
        showCustomToast(
            title: "Login Failed",
            type: ToastificationType.error,
            description: "${authProvider.errorMessage ?? 'Login failed'}");
      }
    });
  }

  void _handleSignup() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider
        .signup(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      _isDoctor,
    )
        .then((_) {
      if (authProvider.isAuthenticated) {
        showCustomToast(
            title: 'SignUp Successful',
            type: ToastificationType.success,
            description:
                "Signup successful! Welcome ${authProvider.user!.name}");

        // Navigate to home screen
        // context.go('/home');
        if (mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      } else {
        showCustomToast(
            title: "SignUp Failed",
            type: ToastificationType.error,
            description: "${authProvider.errorMessage ?? 'Signup failed'}");
      }
    });
  }
}
