import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/widgets/custom_app_bar.dart';

import 'widgets/build_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
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
                double horizontalPadding = isDesktop ? 0 : 18;

                return Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: _buildLoginCard(isDesktop),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(32),
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
              'SIGNUP',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F1F1F),
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isDesktop ? 24 : 18),
            // Name Field
            BuildTextField(
              controller: _nameController,
              hintText: 'Name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Email Field
            BuildTextField(
              controller: _emailController,
              hintText: 'Email',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
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
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            SizedBox(height: isDesktop ? 24 : 18),

            // Login Button
            ElevatedButton(
              onPressed: _handleSignup,
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
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            SizedBox(height: isDesktop ? 24 : 18),

            // Create Account Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: const Color(0xFF1F1F1F).withOpacity(0.6),
                    fontSize: isDesktop ? 16 : 14,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.pushReplacement('/login');
                  },
                  child: Text(
                    'Login',
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

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // Handle login logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('signup functionality would be implemented here'),
          backgroundColor: Color(0xFF543855),
        ),
      );
    }
  }
}
